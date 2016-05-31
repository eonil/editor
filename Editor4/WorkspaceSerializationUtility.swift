//
//  WorkspaceFileList.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/27.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// Provides serialization of workspace path items.
///
/// This serializes a path item into a custom schemed URL.
/// Each path items will be stored in this form.
///
/// 	editor://workspace/folder1/folder2?group
/// 	editor://workspace/folder1/folder2/file3?comment=extra%20info
///
/// Rules
/// -----
/// 1. Conforms RFC URL standards. (done by Cocoa classes)
/// 2. Slashes(`/`) cannot be a part of node name. Even with escapes.
///    This equally applied to all of Unix file systems and URL standards.
///    You must use slashes as a directory separator to conform URL standard
///    even if you're using this data on Windows.
/// 3. All files are stored in sorted flat list. Yes, base paths are
///    duplicated redundant data, but this provides far more DVCS-friendly
///    (diff/merge) data form, and I believe that is far more important
///    then micro spatial efficiency. Also, in most cases, you will be
///    using at least a kind of compression, and this kind of redundancy
///    is very compression friendly.
///
/// Workspace is defined by a sorted list of paths to files in the workspace.
/// All items are full paths to workspace root.
/// Container directories must have an explicit entry. Missing container
/// is an error.
///
/// Strict reader requires all intermediate folders comes up before any
/// descendant nodes. Anyway error-tolerant reader will be provided later
/// for practical use with DVCS systems by inferring missing containers.
///
/// **WARNING:**
/// In early development stage, all items must be sorted in TOPOLOGICAL ORDER.
/// In later version we will ship an error-tolerant version that performs;
/// - Filling missing group items automatically.
/// - Re-sorting items in topologic order.
/// - Removing duplicated group entries.
/// - Removing duplicated non-group entries.
///
struct WorkspaceSerializationUtility {
    static func deserialize(s: String) throws -> WorkspaceState {
        var workspaceState = WorkspaceState()
        try workspaceState.files.deserializeAndReset(s)
        return workspaceState
    }
    static func serialize(workspaceState: WorkspaceState) throws -> AnySequence<String> {
        let fileLines = try workspaceState.files.serialize()
        var fileLineGenerator = fileLines.generate()
        var isSeparator = true
        return AnySequence {
            return AnyGenerator { () -> String? in
                isSeparator.flip()
                if isSeparator { return "\n" }
                return fileLineGenerator.next()
            }
        }
    }
}
private extension Bool {
    mutating func flip() {
        self = !self
    }
}

struct SerializationError: ErrorType {
    var message: String
    init(_ message: String) {
        self.message = message
    }
}

import Foundation.NSURL
private extension FileTree2 {
    private mutating func deserializeAndReset(s: String) throws {
        let lines = s.componentsSeparatedByString("\n")
        var newTree = FileTree2(rootState: FileState2(form: .Container, phase: .Normal, name: ""))
        try lines.filter({ $0.isEmpty == false }).forEach({ try newTree.deserializeAndAppendFile($0) })
        // Atomic transaction.
        self = newTree
    }
    private mutating func deserializeAndAppendFile(s: String) throws {
        guard let u = NSURLComponents(string: s) else { throw SerializationError("Ill-formed code `\(s)`. Not a proper URL.") }
        guard u.scheme == "editor" else { throw SerializationError("Bad scheme `\(u.scheme ?? "nil")`.") }
        guard u.host == "workspace" else { throw SerializationError("Bad host `\(u.host ?? "nil")`.") }
        guard let p = u.path else { throw SerializationError("Missing path from url `\(s)`.") }
        let qs = u.queryItems ?? []
        let path = FileNodePath(p.componentsSeparatedByString("/").filter({ $0.isEmpty == false }))
        guard let (superfilePath, fileName) = path.splitLast() else { return () /* Root path. Already exists. */ }
        var fileState = FileState2(form: (qs.contains({ $0.name == "group" }) ? .Container : .Data),
                                   phase: .Normal,
                                   name: fileName)
        fileState.comment = qs.filter({ $0.name == "comment" }).first?.value
        guard let superfileID = self.searchFileIDForPath(superfilePath) else { throw SerializationError("Missing super-file ID for path `\(superfilePath)`.") }
        try append(fileState, asSubnodeOf: superfileID)
    }
}
private extension FileTree2 {
    private func collectAllFileIDsInDFS() -> [FileID2] {
        var buffer = [FileID2]()
        buffer.reserveCapacity(count)
        func collectIn(fileID: FileID2) {
            buffer.append(fileID)
            for subfileID in self[fileID].subfileIDs {
                collectIn(subfileID)
            }
        }
        collectIn(rootID)
        return buffer
    }
    /// Performs serialization for all files in DFS order.
    private func serialize() throws -> [String] {
        return try collectAllFileIDsInDFS().map(serializeFile)
    }
    private func serializeFile(fileID: FileID2) throws -> String {
        assert(contains(fileID))
        let fileState = self[fileID]
        let filePath = self.resolvePathFor(fileID)
        let u = NSURLComponents()
        u.scheme = "editor"
        u.host = "workspace"
        u.path = "/" + filePath.keys.joinWithSeparator("/")
        u.queryItems = [
            fileState.serializeGrouping(),
            fileState.serializeComment(),
        ].flatMap({ $0 })
        guard let s = u.string else { throw SerializationError("Cannot get `string` from `\(u)`.") }
        return s
    }
}

private extension FileState2 {
    private func serializeGrouping() -> NSURLQueryItem? {
        guard form == .Container else { return nil }
        return NSURLQueryItem(name: "group", value: nil)
    }
    private func serializeComment() -> NSURLQueryItem? {
        guard let comment = comment else { return nil }
        return NSURLQueryItem(name: "comment", value: comment)
    }
}























