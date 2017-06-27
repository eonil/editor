//
//  ProjectFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilSignet
import EonilToolbox

///
/// Manages project files.
///
/// A project allows no-location state.
/// See `relocate` method for details.
///
final class ProjectFeature: ServiceDependent {
    ///
    /// Notifies change of something.
    /// This guarantees state consistency at
    /// the point of casting.
    ///
    let signal = Relay<()>()
    ///
    /// Notifies a detailed information of where 
    /// has been changed in state.
    /// This provides precise timing. You get the
    /// signals at exactly when the change happen.
    /// This DOES NOT provide state consistency.
    /// State can be inconsistent between changes.
    /// If you want to access state only at 
    /// consistent point, do it with `signal` 
    /// relay.
    ///
    /// This is an intentional design because
    /// "signal" is notification of "timing",
    /// not data. If you want data-based 
    /// signaling it must be asynchronous, and
    /// that is not how this app is architected.
    /// FRP has been avoided intentionally because
    /// it requires forgetting precise resource
    /// life-time management, and that is not 
    /// something I can accept for soft-realtime 
    /// human-facing application.
    ///
    let changes = Relay<Change>()
    private(set) var state = State()

    ///
    /// Sets a new location.
    ///
    /// All contained files will be moved to the new location if changed.
    /// Result undefined if new location is `nil`.
    ///
    /// Idempotent.
    ///
    func relocate(_ newLocation: URL?) {
        guard state.location != newLocation else { return }
        guard newLocation != nil else { MARK_unimplemented() }

        if state.location != nil {
            assert(state.files.isEmpty == false)
            state.files[.root] = nil
            changes.cast(.files(.delete(.root)))
        }
        state.location = newLocation
        if state.location != nil {
            let k = Path.root
            let v = NodeKind.folder
            state.files[.root] = (k, v)
            changes.cast(.files(.insert(.root)))
        }
        signal.cast()
    }

    ///
    /// Add a new node of specified type.
    ///
    /// - Parameter at:
    ///     An index to designate position of new node to be inserted into.
    ///     Intermediate nodes MUST exists. Otherwise this fails.
    ///     Empty index (index to root node) is not allowed.
    ///
    func makeFile(at: FileTree.IndexPath, content: NodeKind) {
        assertMainThread()
        guard at != .root else {
            // Make a root node.
            state.files[.root] = (Path.root, .folder)
            let m = Tree2Mutation.insert(at)
            changes.cast(.files(m))
            return
        }
        let parentIndex = at.deletingLastComponent()
        guard let (k, v) = state.files[parentIndex] else {
            reportIssue("Cannot find parent node.")
            return
        }
        guard v == .folder else {
            reportIssue("Parent node is not a folder node. Cannot create a subnode in it.")
            return
        }
        guard let cs = state.files.children(of: k) else {
            reportIssue("Bad parent key `\(k)`.")
            return
        }
        let n = makeNewNodeName(at: at, kind: content)
        let ck = k.appendingComponent(n)
        guard cs.contains(ck) == false else {
            reportIssue("A same named file or folder already exists in the folder.")
            return
        }

        // Do the job.
        state.files[at] = (ck, content)
        createActualFileImpl(at: ck, as: content)

        // Cast events.
        let m = Tree2Mutation.insert(at)
        changes.cast(.files(m))
        signal.cast()
    }
    ///
    /// Imports a subtree from an external file-system location.
    ///
    func importFile(at: FileTree.IndexPath, from externalFileLocation: URL) {
        MARK_unimplemented()
    }
    ///
    /// Exports a subtree to an external file-system location.
    ///
    func exportFile(at: FileTree.IndexPath, to externalFileLocation: URL) {
        MARK_unimplemented()
    }
    func moveFile(from: Path, to: Path) {
        assertMainThread()
        MARK_unimplemented()
    }
    func deleteFile(at: FileTree.IndexPath) {
        assertMainThread()
        guard let (k, _) = state.files[at] else {
            reportIssue("Cannot find a file or folder at location `\(at)`.")
            return
        }

        // Do the job.
        state.files[at] = nil
        deleteActualFileImpl(at: k)

        // Cast events.
        let m = Tree2Mutation.delete(at)
        changes.cast(.files(m))
        signal.cast()
    }
    func deleteFiles(at locations: [FileTree.IndexPath]) {
        assertMainThread()
        for location in locations {
            deleteFile(at: location)
        }
    }




    func setSelection(_ newSelection: AnyProjectSelection) {
        state.selection = newSelection
        changes.cast(.location)
        signal.cast()
    }






    ///
    /// Make actual file node on disk.
    /// Failure on disk I/O will be ignored and
    /// lead the node to be an invalid node.
    /// That's an acceptable and intentional decision.
    ///
    private func createActualFileImpl(at path: ProjectItemPath, as kind: NodeKind) {
        guard let u = makeFileURL(for: path) else { return }
        do {
            switch kind {
            case .folder:
                try services.fileSystem.createDirectory(at: u, withIntermediateDirectories: true, attributes: nil)
            case .file:
                try! Data().write(to: u, options: [.atomicWrite])
            }
        }
        catch let err {
            reportIssue("File I/O error: \(err)")
        }
    }
    private func deleteActualFileImpl(at path: ProjectItemPath) {
        guard let u = makeFileURL(for: path) else { return }
        do {
            try services.fileSystem.removeItem(at: u)
        }
        catch let err {
            reportIssue("File I/O error: \(err)")
        }
    }

    private func makeNewNodeName(at: FileTree.IndexPath, kind: NodeKind) -> String {
        func makeKindText() -> String {
            switch kind {
            case .file:     return "file"
            case .folder:   return "folder"
            }
        }
        let n = 0
        let s = kind
        return "(new \(s) \(n))"
    }
    private func reportIssue(_ message: String) {
        DEBUG_log("Issue: \(message)")
        let b = state.issues.endIndex
        let e = b + 1
        let issue = Issue(state: message)
        state.issues.append(issue)
        let m = ArrayMutation<Issue>.insert(b..<e)
        changes.cast(.issues(m))
    }
}
extension ProjectFeature {
    ///
    /// File-tree state is provided in transition form to
    /// make easy to track changes between states.
    ///
    struct State {
        var location: URL?
        ///
        /// Indicates whether this object is currently performing 
        /// a long running operation.
        ///
        var busy = false
        var files = FileTree()
        ///
        /// All discovered targets.
        ///
        var targets = [Target]()
        var issues = [Issue]()
        ///
        /// This MSUT guarantee sorted in row-index order.
        ///
        var selection = AnyProjectSelection.none
    }
    public typealias FileTree = Tree2<Path, NodeKind>
    typealias Node = (id: Path, state: NodeKind)
    typealias Path = ProjectItemPath
    enum NodeKind {
        case file
        case folder
    }
    enum Change {
        case location
        case files(Tree2Mutation<Path, NodeKind>)
        /// 
        /// Selection snapshot has been changed.
        /// Selection change does not provide mutation details
        /// because there's no such source data and it's
        /// expensive to produce from snapshots.
        ///
        case selection
        case issues(ArrayMutation<Issue>)
    }
    struct Issue {
        let id = ObjectAddressID()
        let state: String
    }
}
extension ProjectFeature {
    ///
    /// - Returns:
    ///     `nil` if location is unclear.
    ///     A URL otherwise.
    ///
    func makeFileURL(for path: Path) -> URL? {
        guard let u = state.location else { return nil }
        var u1 = u
        for c in path.components {
            u1 = u1.appendingPathComponent(c)
        }
        return u1
    }
}
extension ProjectFeature {
    func findInsertionPointForNewNode() -> Result<FileTree.IndexPath, String> {
        guard let last = state.selection.items.last else {
            // No item. Unexpected situation. Ignore.
            return .failure([
                "Tried to find an insertion point when no file node is selected.",
                "This is unsupported."
                ].joined(separator: " "))
        }
        let insertionPoint: FileTree.IndexPath
        if last == .root {
            // Make a new child node at last.
            let cs = state.files.children(of: last)!
            insertionPoint = FileTree.IndexPath.root.appendingLastComponent(cs.count)
        }
        else {
            // Make a new sibling node at next index.
            let idxp = state.files.index(of: last)!
            let pidxp = idxp.deletingLastComponent()
            insertionPoint = pidxp.appendingLastComponent(idxp.components.last! + 1)
        }
        return .success(insertionPoint)
    }
}
