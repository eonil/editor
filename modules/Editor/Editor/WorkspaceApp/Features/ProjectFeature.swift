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
import EonilTree

///
/// Manages project files.
///
/// A project allows no-location state.
/// See `relocate` method for details.
///
final class ProjectFeature: ServicesDependent {
    ///
    /// Notifies change of something.
    /// This guarantees state consistency at
    /// the point of casting.
    ///
    let signal = Relay<()>()
    ///
    /// Notifies a detailed information of "what"
    /// has been changed in state. Optionally
    /// can contain "how" it's been changed.
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
    /// signaling, it must be asynchronous, and
    /// that is not how this app is architected.
    /// FRP has been avoided intentionally because
    /// it requires forgetting precise resource
    /// life-time management, and that is not
    /// something I can accept for soft-realtime
    /// human-facing application.
    ///
    let changes = Relay<[Change]>()
    private(set) var series = Series<State>()
    var state: State { return series.last! }
//    private(set) var series = ClippingSeries<State>(State())
//    var state: State { return series.current }

    private func appendMutation(_ f: (_ state: inout State) -> Void) {
        var st = state
        f(&st)
        series.append(st)
    }

    func process(_ command: Command) {
        switch command {
        case .setSelection(let newSelection):
            var st = state
            st.selection = newSelection
            series.append(st)
            changes.cast([.location])
            signal.cast(())

        case .deleteSelectedFiles:
            deleteFilesWithSortedIndexPaths(at: state.selection.indexPaths)
        }
    }
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

//        if state.location != nil {
//            assert(state.files.isEmpty == false)
//            state.files.delete(at: .root)
//            changes.cast(.files(.delete(.root)))
//        }
        var st = state
        st.location = newLocation
        series.append(st)
//        if state.location != nil {
//            let k = Path.root
//            let v = NodeKind.folder
//            state.files.insert(at: .root, (k, v))
//            changes.cast(.files(.insert(.root)))
//        }
        changes.cast([.location])
        signal.cast(())
        restoreProjectFileList()
    }

    ///
    /// Add a new node of specified type.
    ///
    /// - Parameter at:
    ///     An index to designate position of new node to be inserted into.
    ///     Intermediate nodes MUST exists. Otherwise this fails.
    ///     Empty index (index to root node) is not allowed.
    ///
    func makeFile(at idxp: IndexPath, as kind: NodeKind) -> Result<Void, MakeFileIssue> {
        assertMainThread()
        guard idxp != .root else { return .failure(.rootNodeCannotBeInserted) }

        let newNode = FileNode(
            name: makeNewNodeName(at: idxp, as: kind),
            kind: kind)
        var newSubtree = FileTree(node: newNode)
        appendMutation { state in
            state.files.insert(at: idxp, newSubtree)
        }

        // Perform I/O.
        let namep = state.files.namePath(at: idxp)
        createActualFileImpl(at: namep, as: kind)

        // Cast events.
        changes.cast([.files(.insert(at: idxp))])
        signal.cast(Void())
        storeProjectFileList()
        return .success(Void())
    }
    enum MakeFileIssue {
        case rootNodeCannotBeInserted
    }

    ///
    /// Imports a subtree from an external file-system location.
    ///
    /// Whole subtree will be copied.
    /// You can't import from any file that is already in project directory.
    /// You can't import to anywhere out of project directory.
    ///
    func importFile(at: IndexPath, from externalFileLocation: URL) {
        MARK_unimplemented()
    }
    ///
    /// Exports a subtree to an external file-system location.
    ///
    /// Whole subtree will be copied.
    /// You can't export from any file that is not in project directory.
    /// You can't export to anywhere in project directory.
    ///
    func exportFile(at: IndexPath, to externalFileLocation: URL) {
        MARK_unimplemented()
    }

    func makeURLForFile(at path: IndexPath) -> URL {
            MARK_unimplemented()
    }
    func makeURLForFile(at npath: ProjectItemPath) -> URL {
        MARK_unimplemented()
    }

    ///
    /// - Note:
    ///     You can rename root node. That renames project directory.
    ///
    /// - Note:
    ///     If old name and new name are equals, return is no-op and returns `.success`.
    ///
    func renameFile(at idxp: IndexPath, with newName: String) -> Result<Void,RenameFileIssue> {
        assertMainThread()

        // Prepare inputs.
        let targetFileURL = makeURLForFile(at: idxp)
        let oldName = state.files[idxp].node.name
        let oldURL = targetFileURL
        let newURL = oldURL.deletingLastPathComponent().appendingPathComponent(newName)

        // Check input validity.
        guard oldName != newName else { return .success(Void()) }

        // Perform I/O.
        do {
            try services.fileSystem.moveItem(at: oldURL, to: newURL)
        }
        catch let err {
            return .failure(.fileSystemError(err))
        }

        // Update in-memory representation.
        appendMutation { (state) in
            state.files[idxp].node.name = newName
        }
        signal.cast(Void())
        changes.cast([.filesOptimized(.replaceNode(at: idxp))])

        MARK_unimplemented()
    }
    enum RenameFileIssue {
        case filesCollectionIsMissingInProject
        case fileSystemError(Error)
    }
    ///
    /// Moves a file from one location to another location.
    ///
    /// This literally moves a file node to a new position.
    /// You cannot change file name.
    /// If `from == to`, this becomes no-op, and return `.success(_)`.
    ///
    func moveFile(from: IndexPath, to: IndexPath) -> Result<Void,MoveFileIssue> {
        assertMainThread()
        guard from != to else { return .success(Void()) } // No-op.

        // Check input validity.
        guard from != .root else { return .failure(.sourcePathIsRoot) }
        guard to != .root else { return .failure(.destinationPathIsRoot) }

        // Perform I/O.
        // Platform file-system operation.
        let fromURL = makeURLForFile(at: from)
        let toURL = makeURLForFile(at: to)
        do {
            try services.fileSystem.moveItem(at: fromURL, to: toURL)
        }
        catch let err {
            return .failure(.fileSystemError(err))
        }

        // Mutate in-memory file-tree.
        let nodeToMove = state.files[from].node
        appendMutation { (state) in
            state.files.insert(at: to, FileTree(node: nodeToMove))
        }
        appendMutation { (state) in
            // Remove last to prevent changes in indices.
            state.files.remove(at: from)
        }

        // Cast events.
        changes.cast([.files(.remove(at: from)), .files(.insert(at: to))])
        signal.cast(())
        storeProjectFileList()
        return .success(Void())
    }
//    ///
//    /// Moves a file from one location to another location.
//    ///
//    /// This literally moves a file node to a new position.
//    /// You cannot change file name.
//    /// If `from == to`, this becomes no-op, and return `.success(_)`.
//    ///
//    func moveFileByNamePath(from: ProjectItemPath, to: ProjectItemPath) -> Result<Void,MoveFileIssue> {
//        assertMainThread()
//        guard from != to else { return .success(Void()) } // No-op.
//
//        // Check input validity.
//        guard state.files.contains(from) else { return .failure(.sourcePathIsNotInProject) }
//        guard state.files.contains(to) == false else { return .failure(.destinationPathIsAlreadyInProject) }
//        guard from.isRoot == false else { return .failure(.sourcePathIsRoot) }
//        guard to.isRoot == false else { return .failure(.destinationPathIsRoot) }
//
//        // Perform I/O.
//        // Platform file-system operation.
//        guard let fromURL = makeFileURL(for: from) else { REPORT_criticalBug("File URL for an existing path could not be resolved.") }
//        guard let toURL = makeFileURL(for: to) else { REPORT_criticalBug("File URL for an existing path could not be resolved.") }
//        do {
//            try services.fileSystem.moveItem(at: fromURL, to: toURL)
//        }
//        catch let err {
//            return .failure(.fileSystemError(err))
//        }
//
//        // Mutate in-memory file-tree.
//        let kind = state.files[from]
//        guard let fromIndex = state.files.index(of: from) else { REPORT_criticalBug("Index to an existing path could not be resolved.") }
//        state.files.delete(at: fromIndex)
//        let parentOfTo = to.deletingLastComponent().successValue!
//        guard let indexOfParentOfTo = state.files.index(of: parentOfTo) else { REPORT_criticalBug("Index to an existing path could not be resolved.") }
//        guard let siblings = state.files.children(of: parentOfTo) else { REPORT_criticalBug("Children of an existing path could not be resolved.") }
//        let toIndex = indexOfParentOfTo.appendingLastComponent(siblings.count)
//        let toNode = (to, kind)
//        state.files.insert(at: toIndex, toNode)
//
//        // Cast events.
//        changes.cast(.files(.delete(fromIndex)))
//        changes.cast(.files(.insert(toIndex)))
//        signal.cast(())
//        storeProjectFileList()
//        return .success(Void())
//    }
    enum MoveFileIssue {
        case sourcePathIsNotInProject
        case destinationPathIsAlreadyInProject
        case sourcePathIsRoot
        case destinationPathIsRoot
        case fileSystemError(Error)
    }

//    func deleteFiles(at paths: [IndexPath]) -> Result<Void,DeleteIssue> {
//        // Prepare inputs.
//        // Delete from leaf to root.
//        let sortedPathsInDeleteOrder = paths.sorted(by: { $0.count < $1.count }).reversed()
//        deleteFilesWithSortedIndexPaths(sortedPathsInDeleteOrder)
//    }
    ///
    /// Delete multiple file nodes at once.
    ///
    /// When you deleting multiple file nodes, nested nodes
    /// in the target list MUST be removed. Because the node
    /// won't be available at the point of deletion time.
    /// Otherwise, you can just ignore such situation, but
    /// I don't think it's a good practice.
    ///
    /// - Todo: Implementation is currently O(n^2). Optimize this.
    ///
    /// - Note:
    ///     As this method performs on multiple files, operation
    ///     can be stopped in the middle of operation. In that
    ///     case, file-system change will stop there, and in-memory
    ///     state won't be changed. Also, a `failure(_)` will be
    ///     returned. In other words, file-system state becomes
    ///     out-sync.
    ///
    private func deleteFilesWithSortedIndexPaths<S>(at idxpsSortedInDFS: S) -> Result<Void,DeleteIssue> where S: Sequence, S.Element == IndexPath {
        assertMainThread()

        // Perform I/O.
        for idxp in idxpsSortedInDFS {
            let targetFileURL = makeURLForFile(at: idxp)
            do {
                try services.fileSystem.removeItem(at: targetFileURL)
            }
            catch let err {
                return .failure(.fileSystemError(err))
            }
        }

        // Update in-memory representations.
        var changeSignals = [Change]()
        appendMutation { (state) in
            for idxp in idxpsSortedInDFS {
                state.files.remove(at: idxp)
                changeSignals.append(.files(.remove(at: idxp)))
            }
        }
        signal.cast(())
        changes.cast(changeSignals)
        storeProjectFileList()
        return .success(Void())
    }
    enum DeleteIssue {
        case fileSystemError(Error)
    }













    private func storeProjectFileList() {
        do {
            guard let loc = state.location?.appendingPathComponent(".eews") else {
                reportIssue("Cannot locate project.")
                return
            }
            let dto = DTOProjectFile(files: state.files)
            try dto.write(to: loc)
        }
        catch let err {
            reportIssue("File I/O error: \(err)")
        }
    }
    private func restoreProjectFileList() {
        do {
            guard let loc = state.location?.appendingPathComponent(".eews") else {
                reportIssue("Cannot locate project.")
                return
            }
            let d = try Data(contentsOf: loc)
            let s = String(data: d, encoding: .utf8) ?? ""
            let r = DTOProjectFile.decode(s)
            let dto: DTOProjectFile
            switch r {
            case .failure(let issue):
                reportIssue(issue)
                return
            case .success(let newDTO):
                dto = newDTO
            }
            appendMutation { (state) in
                state.files = dto.files
            }
            changes.cast([.files(.replace(at: []))])
            signal.cast(())
        }
        catch let err {
            reportIssue("File I/O error: \(err)")
        }
    }

    ///
    /// Make actual file node on disk.
    /// Failure on disk I/O will be ignored and
    /// lead the node to be an invalid node.
    /// That's an acceptable and intentional decision.
    ///
    private func createActualFileImpl(at path: ProjectItemPath, as kind: NodeKind) {
        let u = makeURLForFile(at: path)
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

    private func makeNewNodeName(at path: IndexPath, as kind: NodeKind) -> String {
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
        var st = state
        st.issues.append(issue)
        series.append(st)
        let m = ArrayMutation<Issue>.insert(b..<e)
        changes.cast([.issues(m)])
    }
}
extension ProjectFeature {
//    typealias Series = ClippingSeries<State>
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
        ///
        /// - ToDo:
        ///     Consider migration to `FileTree2` type.
        ///
        var files = FileTree(node: .root)
        ///
        /// All discovered targets.
        ///
        var targets = [Target]()
        var issues = [Issue]()
        ///
        /// This MSUT guarantee sorted in row-index order.
        ///
        var selection = ProjectSelection()
    }
    public typealias FileTree = Tree<FileNode>
    ///
    /// A `FileNode` can have any name in memory.
    /// Anyway, some name can be rejected by OS for some operations.
    ///
    public struct FileNode {
        public var name: String
        public var kind: NodeKind
        public var isExpanded: Bool

        init(name: String, kind: NodeKind, isExpanded: Bool = false) {
            self.name = name
            self.kind = kind
            self.isExpanded = isExpanded
        }
        static var root: FileNode {
            return FileNode(name: "", kind: .folder, isExpanded: true)
        }
    }
    enum NodeKind {
        case file
        case folder
    }
    enum Change {
        case location
        case files(FileTree.Mutation)
        case filesOptimized(FileTree.OptimizedMutation)
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
//    ///
//    /// - Returns:
//    ///     `nil` if location is unclear.
//    ///     A URL otherwise.
//    ///
//    func makeFileURL(for path: Path) -> URL? {
//        guard let u = state.location else { return nil }
//        var u1 = u
//        for c in path.components {
//            u1 = u1.appendingPathComponent(c)
//        }
//        return u1
//    }
}
extension ProjectFeature {
    func findInsertionPointForNewNode() -> Result<IndexPath, String> {
        guard let idxp = state.selection.indexPaths.toArray().last else {
            // No item. Unexpected situation. Ignore.
            return .failure([
                "Tried to find an insertion point when no file node is selected.",
                "This is unsupported."
                ].joined(separator: " "))
        }
        let insertionPoint: IndexPath
        if idxp == .root {
            // Make a new child node at last.
            let tree = state.files.at(idxp)
            insertionPoint = IndexPath.root.appending(tree.subtrees.count)
        }
        else {
            // Make a new sibling node at next index.
            let parent_idxp = idxp.dropLast()
            insertionPoint = parent_idxp.appending(idxp.last! + 1)
        }
        return .success(insertionPoint)
    }
}

extension IndexPath {
    static var root = IndexPath(indexes: [])
}

