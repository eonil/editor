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
    private(set) var series = Series(State())
    var state: State { return series.latest }

    private func appendMutation(_ f: (_ state: inout State) -> Void) {
        var st = state
        f(&st)
        series.append(st)
    }

    func process(_ command: Command) -> Result<Void, ProcessIssue> {
        switch command {
        case .setNodeFoldingState(let idxp, let isFolded):
            guard state.files[idxp].node.isFolded != isFolded else { return .success(Void()) }
            // Update in-memory state.
            appendMutation({ (state) in
                state.files[idxp].node.isFolded = isFolded
            })
            // Perform I/O.
            storeProjectFileList()
            // Broadcast changes.
            changes.cast([.filesOptimized(.replaceNode(at: idxp))])
            signal.cast(Void())
            return .success(Void())

        case .setSelection(let newSelection):
            guard newSelection.isValid(for: self) else { return .failure(.setSelection(.timepointMismatch)) }
            appendMutation({ (state) in
                state.selection = newSelection
            })
            changes.cast([.selection])
            signal.cast(Void())
            return .success(Void())

        case .makeFile(let idxp, let kind):
            return makeFile(at: idxp, as: kind).mapIssue(ProcessIssue.makeFile)

        case .makeFileAtInferredPosition(let kind):
            return makeFileAtInferredPosition(as: kind).mapIssue(ProcessIssue.makeFile)

        case .renameFile(let idxp, let newName):
            return renameFile(at: idxp, with: newName).mapIssue(ProcessIssue.renameFile)

        case .moveFile(let old_idxp, let new_idxp):
            return moveFile(from: old_idxp, to: new_idxp).mapIssue(ProcessIssue.moveFile)

        case .deleteSelectedFiles:
            let r = deleteFiles(in: state.selection)
            return r.mapIssue(ProcessIssue.deleteFilesIssue)
        }
    }
    enum ProcessIssue {
        case makeFile(MakeFileIssue)
        case setSelection(SetSelectionIssue)
        case renameFile(RenameFileIssue)
        case moveFile(MoveFileIssue)
        case deleteFilesIssue(DeleteFilesIssue)
    }

    enum SetSelectionIssue {
        case timepointMismatch
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
    /// Make a new node right under the current selection.
    ///
    private func makeFileAtInferredPosition(as kind: NodeKind) -> Result<Void, MakeFileIssue> {
        switch findInsertionPointForNewNode() {
        case .failure(let issue):   return .failure(.noGoodInsertionPoint(reason: issue))
        case .success(let idxp):    return makeFile(at: idxp, as: kind)
        }
    }
    ///
    /// Add a new node of specified type.
    ///
    /// - Parameter at:
    ///     An index to designate position of new node to be inserted into.
    ///     Intermediate nodes MUST exists. Otherwise this fails.
    ///     Empty index (index to root node) is not allowed.
    ///
    private func makeFile(at idxp: IndexPath, as kind: NodeKind) -> Result<Void, MakeFileIssue> {
        assertMainThread()
        guard idxp != .root else { return .failure(.rootNodeCannotBeInserted) }

        let newName = makeNewNodeName(at: idxp, as: kind)
        let newNode = FileNode(name: newName, kind: kind)
        let newSubtree = FileTree(node: newNode)
        appendMutation { state in
            state.files.insert(at: idxp, newSubtree)
        }

        // Perform I/O.
        // Though I/O fails, in-memory representation keeps changes.
        let namep = state.files.namePath(at: idxp)
        let r = createActualFileImpl(at: namep, as: newNode.kind)
        storeProjectFileList()

        // Cast events.
        changes.cast([.files(.insert(at: idxp))])
        signal.cast(Void())
        return r
    }
    enum MakeFileIssue {
        case makeFileSystemURLIssue(MakeFileSystemURLIssue)
        case fileSystemError(Error)
        case rootNodeCannotBeInserted
        ///
        /// Program could not find a good insertion point
        /// for new file-node with current selection.
        /// This can happen if selected item does not support
        /// adding new subitems.
        ///
        case noGoodInsertionPoint(reason: String)
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
        let targetFileSystemURL: URL
        switch makeURLForFile(at: idxp) {
        case .failure(let issue):   return .failure(.makeFileSystemURLIssue(issue))
        case .success(let url):     targetFileSystemURL = url
        }
        let oldName = state.files[idxp].node.name
        let oldURL = targetFileSystemURL
        let newURL = oldURL.deletingLastPathComponent().appendingPathComponent(newName)

        // Check input validity.
        guard oldName != newName else { return .success(Void()) }

        // Update in-memory representation.
        appendMutation { (state) in
            state.files[idxp].node.name = newName
        }

        // Perform I/O.
        do {
            try services.fileSystem.moveItem(at: oldURL, to: newURL)
        }
        catch let err {
            return .failure(.fileSystemError(err))
        }
        storeProjectFileList()

        signal.cast(Void())
        changes.cast([.filesOptimized(.replaceNode(at: idxp))])
        return .success(Void())
    }
    enum RenameFileIssue {
        case makeFileSystemURLIssue(MakeFileSystemURLIssue)
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

        // Mutate in-memory file-tree.
        let nodeToMove = state.files[from].node
        appendMutation { (state) in
            state.files.insert(at: to, FileTree(node: nodeToMove))
        }
        appendMutation { (state) in
            // Remove last to prevent changes in indices.
            state.files.remove(at: from)
        }

        // Perform I/O.
        // Platform file-system operation.
        let fromFileSystemURL: URL
        let toFileSystemURL: URL
        switch makeURLForFile(at: from) {
        case .failure(let issue):   return .failure(.makeFileSystemURLIssue(issue))
        case .success(let url):     fromFileSystemURL = url
        }
        switch makeURLForFile(at: to) {
        case .failure(let issue):   return .failure(.makeFileSystemURLIssue(issue))
        case .success(let url):     toFileSystemURL = url
        }
        do {
            try services.fileSystem.moveItem(at: fromFileSystemURL, to: toFileSystemURL)
        }
        catch let err {
            return .failure(.fileSystemError(err))
        }
        storeProjectFileList()

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
        case makeFileSystemURLIssue(MakeFileSystemURLIssue)
//        case sourcePathIsNotInProject
//        case destinationPathIsAlreadyInProject
        case sourcePathIsRoot
        case destinationPathIsRoot
        case fileSystemError(Error)
    }

//    func deleteFiles(at paths: [IndexPath]) -> Result<Void,DeleteIssue> {
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
    private func deleteFiles(in selection: ProjectSelection) -> Result<Void, DeleteFilesIssue> {
        assertMainThread()

        // Prepare inputs.
        // Delete from leaf to root.
        // We don't need proper stable sort. Just leaf-to-root is enough.
        let sorted_idxps = ProjectItemPathClustering.sortLeafToRoot(selection)

        // Update in-memory representations.
        var changeSignals = [Change]()
        appendMutation { (state) in
            for idxp in sorted_idxps {
                state.files.remove(at: idxp)
                changeSignals.append(.files(.remove(at: idxp)))
            }
        }

        // Perform I/O.
        for idxp in sorted_idxps {
            let targetFileSystemURL: URL
            switch makeURLForFile(at: idxp) {
            case .failure(let issue):   return .failure(.makeFileSystemURLIssue(issue))
            case .success(let url):     targetFileSystemURL = url
            }
            do {
                try services.fileSystem.removeItem(at: targetFileSystemURL)
            }
            catch let err {
                return .failure(.fileSystemError(err))
            }
        }

        signal.cast(())
        changes.cast(changeSignals)
        storeProjectFileList()
        return .success(Void())
    }
    enum DeleteFilesIssue {
        case makeFileSystemURLIssue(MakeFileSystemURLIssue)
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
    private func createActualFileImpl(at path: ProjectItemPath, as kind: NodeKind) -> Result<Void, MakeFileIssue> {
        let targetFileSystemURL: URL
        switch makeURLForFile(at: path) {
        case .failure(let issue):   return .failure(.makeFileSystemURLIssue(issue))
        case .success(let url):     targetFileSystemURL = url
        }
        do {
            switch kind {
            case .folder:
                try services.fileSystem.createDirectory(at: targetFileSystemURL, withIntermediateDirectories: true, attributes: nil)
            case .file:
                try Data().write(to: targetFileSystemURL, options: [.atomicWrite])
            }
        }
        catch let err {
            return .failure(.fileSystemError(err))
        }
        return .success(Void())
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
    typealias Series = ClippingSeries<State>
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
        public var isFolded: Bool

        init(name: String, kind: NodeKind, isFolded: Bool = true) {
            self.name = name
            self.kind = kind
            self.isFolded = isFolded
        }
        static var root: FileNode {
            return FileNode(name: "", kind: .folder, isFolded: false)
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

    enum MakeFileSystemURLIssue {
        case projectHasNoLocationOnFileSystem
    }
    ///
    /// - Returns:
    ///     `nil` if `location == nil`.
    ///     Otherwise a URL.
    ///
    /// - Note:
    ///     This requires an existing file node at the index-path.
    ///     If a file node does not exist at the path, this crash
    ///     the app.
    ///
    func makeURLForFile(at idxp: IndexPath) -> Result<URL, MakeFileSystemURLIssue> {
        guard let u = state.location else { return .failure(.projectHasNoLocationOnFileSystem) }
        var u1 = u
        let namep = state.files.namePath(at: idxp)
        for n in namep.components {
            u1 = u1.appendingPathComponent(n)
        }
        return .success(u1)
    }
    ///
    /// This doesn't require an existing file node in state.
    /// Works always.
    ///
    func makeURLForFile(at namep: ProjectItemPath) -> Result<URL, MakeFileSystemURLIssue> {
        guard let u = state.location else { return .failure(.projectHasNoLocationOnFileSystem) }
        var u1 = u
        for n in namep.components {
            u1 = u1.appendingPathComponent(n)
        }
        return .success(u1)
    }
}
extension ProjectFeature {
    private func findInsertionPointForNewNode() -> Result<IndexPath, String> {
        guard let idxp = state.selection.toArray().last else {
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

