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
final class ProjectFeature {
    let transaction = Relay<Transaction>()
    weak var services: WorkspaceServices?

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
        state.location = newLocation
        transaction.cast(.location)
    }

    ///
    /// Add a new node of specified type.
    ///
    /// - Parameter at:
    ///     An index to designate position of new node to be inserted into.
    ///     Intermediate nodes MUST exists. Otherwise this fails.
    ///     Empty index (index to root node) is not allowed.
    ///
    func makeNode(at: FileTree.IndexPath, content: NodeKind) {
        assertMainThread()
        precondition(at != FileTree.IndexPath.root)
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
        state.files[at] = (ck, content)
        let m = Tree2Mutation.insert(at)
        transaction.cast(.files(m))
    }
    ///
    /// Imports a subtree from an external file-system location.
    ///
    func importNode(at: FileTree.IndexPath, from externalFileLocation: URL) {
        guard let services = services else { REPORT_missingServiceAndFatalError() }
        MARK_unimplemented()
    }
    ///
    /// Exports a subtree to an external file-system location.
    ///
    func exportNode(at: FileTree.IndexPath, to externalFileLocation: URL) {
        guard let services = services else { REPORT_missingServiceAndFatalError() }
        MARK_unimplemented()
    }
    func moveNode(from: Path, to: Path) {
        assertMainThread()
        MARK_unimplemented()
    }
    func deleteNode(at: FileTree.IndexPath) {
        assertMainThread()
        guard state.files[at] != nil else {
            reportIssue("Cannot find a file or folder at location `\(at)`.")
            return
        }
        state.files[at] = nil
        let m = Tree2Mutation.delete(at)
        transaction.cast(.files(m))
    }
    func deleteNodes(at locations: [FileTree.IndexPath]) {
        assertMainThread()
        for location in locations {
            deleteNode(at: location)
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
        let b = state.issues.endIndex
        let e = b + 1
        let issue = Issue(state: message)
        state.issues.append(issue)
        let m = ArrayMutation<Issue>.insert(b..<e)
        transaction.cast(.issues(m))
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
    }
    enum Transaction {
        case location
        case files(Tree2Mutation<Path, NodeKind>)
        case issues(ArrayMutation<Issue>)
    }
    public typealias FileTree = Tree2<Path, NodeKind>
    typealias Node = (id: Path, state: NodeKind)
    struct Path: Hashable {
        private var core = URL(fileURLWithPath: "./")
        init(components initialCompoenents: [String]) {
            var u = URL(fileURLWithPath: "./")
            for c in initialCompoenents {
                u = u.appendingPathComponent(c)
            }
            core = u
        }
        var components: [String] {
            get { return core.pathComponents }
            set { self = Path(components: components) }
        }
        var hashValue: Int {
            return core.hashValue
        }
        var isRoot: Bool {
            return components.isEmpty
        }
        func appendingComponent(_ component: String) -> Path {
            return Path(components: components + [component])
        }
        func deletingLastComponent() -> Result<Path, String> {
            guard components.isEmpty == false else { return .failure("This is root path(`/`). Cannot delete more.") }
            return .success(Path(components: Array(components.dropLast())))
        }
        static func == (_ a: Path, _ b: Path) -> Bool {
            return a.components == b.components
        }
        static var root: Path {
            return Path(components: [])
        }
    }
    enum NodeKind {
        case file
        case folder
    }

    struct Issue {
        let id = ObjectAddressID()
        let state: String
    }
}
extension ProjectFeature.Path {
    enum ConversionError: Error {
        case nonFileURLUnsupported
        case hasNoRelativeFilePath
    }
    init(relativeFileURLFromWorkspaceRoot u: URL) throws {
        guard u.isFileURL else { throw ConversionError.nonFileURLUnsupported }
        guard u.path.hasPrefix("./") else { throw ConversionError.hasNoRelativeFilePath }
        self = ProjectFeature.Path(components: u.pathComponents)
    }
    func makeRelativeFileURLFromWorkspaceRoot() -> URL {
        var u = URL(fileURLWithPath: "./")
        for c in components {
            u = u.appendingPathComponent(c)
        }
        return u
    }
}

private extension Tree2 where Key == ProjectFeature.Path {
    func index(of path: Key) -> Tree2.IndexPath? {
        if path == .root { return .root }
        let parentPathResult = path.deletingLastComponent()
        switch parentPathResult {
        case .failure(_):
            return nil
        case .success(let parentPath):
            guard let cs = children(of: parentPath) else { return nil }
            guard let lastIndexComp = cs.index(of: path) else { return nil }
            guard let parentIndex = index(of: parentPath) else { return nil }
            let finalIndex = parentIndex.appendingLastComponent(lastIndexComp)
            return finalIndex
        }
    }
}

