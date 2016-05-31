//
//  FileTree.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/14.
//  Copyright © 2016 Eonil. All rights reserved.
//

private let DefaultJournalingLimit = 16

struct FileID2: Hashable {
    private var internalRefkey: ReferencingKey
    var hashValue: Int {
        get { return internalRefkey.hashValue }
    }
}
func ==(a: FileID2, b: FileID2) -> Bool {
    return a.internalRefkey == b.internalRefkey
}

enum FileTree2Error: ErrorType {
    case DuplicatedFileName
    case EmptyStringFileName
    case BadFileID(FileID2)
}


/// Behaves like a `Dictionary<FileID2, FileState2>`.
/// Intentionally abstracted to change internal implementation.
struct FileTree2: VersioningStateType {
    private var fileTable = ReferencingTable<FileState2>()
    private(set) var rootID: FileID2
    private(set) var version = Version()
    private(set) var journal = KeyJournal<FileID2>(capacityLimit: DefaultJournalingLimit)

    init(rootState: FileState2) {
        rootID = fileTable.insert(rootState).toFileID()
    }
    var count: Int {
        get { return fileTable.count }
    }
    private mutating func logAndRevise(mutation: KeyMutation<FileID2>) {
        journal.append((version, mutation))
        version.revise()
    }
    private mutating func clearAndRevise(mutation: KeyMutation<FileID2>) {
        journal.removeAll()
        version.revise()
    }
    func searchFileIDForPath(path: FileNodePath) -> FileID2? {
        return searchFileIDForPath(path, with: rootID)
    }
    private func searchFileIDForPath(path: FileNodePath, with fileID: FileID2) -> FileID2? {
        if path.keys.count == 0 { return fileID }
        guard let (first, tail) = path.splitFirst() else { return nil }
        for subfileID in fileTable[fileID.internalRefkey].subfileIDs {
            if fileTable[subfileID.internalRefkey].name == first {
                return searchFileIDForPath(tail, with: subfileID)
            }
        }
        return nil
    }
    func searchFileIDForIndex(index: FileNodeIndex) -> FileID2 {
        return searchFileIDForIndex(index, with: rootID)
    }
    private func searchFileIDForIndex(index: FileNodeIndex, with fileID: FileID2) -> FileID2 {
        if index.indexes.count == 0 { return fileID }
        guard let (first, tail) = index.splitFirst() else { fatalError("Invalid index `\(index)`.") }
        let subfileID = fileTable[fileID.internalRefkey].subfileIDs[first]
        return searchFileIDForIndex(tail, with: subfileID)
    }
    /// Gets file-state for a file ID.
    ///
    /// - Note:
    ///     Setter is intentionally removed because careless modification on `FileState` can result some
    ///     inconsistent state. Instead, another mutator methods which provides proper consistency.
    ///
    subscript(key: FileID2) -> FileState2 {
        get { return fileTable[key.internalRefkey] }
    }
    subscript(path: FileNodePath) -> FileState2? {
        get {
            guard let fileID = searchFileIDForPath(path, with: rootID) else { return nil }
            return fileTable[fileID.internalRefkey]
        }
    }
//    subscript(index: FileNodeIndex) -> FileState2? {
//    }

    /// - Returns:
    ///     A path to the node for the ID.
    ///     A path always exists if the node ID exists in this tree.
    ///     Crashes if the ID is not a part of thie tree.
    ///
    /// - Note:
    ///     O(N) where N is depth of the file node.
    func resolvePathFor(fileID: FileID2) -> FileNodePath {
        if fileID == rootID { return FileNodePath([]) }
        guard let superfileID = fileTable[fileID.internalRefkey].superfileID else { fatalError("Non root file ID `\(fileID)` must have a super-file ID.") }
        let name = fileTable[fileID.internalRefkey].name
        return resolvePathFor(superfileID).appendingLast(name)
    }
    mutating func append(state: FileState2, asSubnodeOf superfileID: FileID2) throws -> FileID2 {
        let index = fileTable[superfileID.internalRefkey].subfileIDs.count
        return try insert(state, at: index, to: superfileID)
    }
    mutating func insert(state: FileState2, at index: Int, to superfileID: FileID2) throws -> FileID2 {
        try validateName(state.name)
        try validateUniqueName(state.name, forSubfilesOf: superfileID)
        var state1 = state
        state1.superfileID = superfileID
        let subfileID = fileTable.insert(state1).toFileID()
        fileTable[superfileID.internalRefkey].subfileIDs.insert(subfileID, atIndex: index)
        logAndRevise(.Insert(subfileID))
        logAndRevise(.Update(superfileID))
        return subfileID
    }
    mutating func remove(fileID: FileID2) {
        assert(fileID != rootID, "You cannot remove root `\(fileID)`.")
        assert(fileTable.contains(fileID.internalRefkey))
        if fileID == rootID { return reportErrorToDevelopers("Tried to remove root file ID and ignored.") }

        // Remove subfiles first.
        while let lastSubfileID = fileTable[fileID.internalRefkey].subfileIDs.last {
            remove(lastSubfileID) // This will also remove itself from superfile's subfile list.
            assert(fileTable[fileID.internalRefkey].subfileIDs.contains(lastSubfileID) == false)
            logAndRevise(.Update(fileID))
        }
        // Remove from superfile last.
        if let superfileID = fileTable[fileID.internalRefkey].superfileID {
            // Very likely to be removed from last.
            REMOVE: do {
                for i in fileTable[superfileID.internalRefkey].subfileIDs.entireRange.reverse() {
                    if fileTable[superfileID.internalRefkey].subfileIDs[i] == fileID {
                        fileTable[superfileID.internalRefkey].subfileIDs.removeAtIndex(i)
                        break REMOVE
                    }
                }
                fatalError("Superfile `\(superfileID)` is set in file `\(fileID)`. but cannot be found from this tree.")
            }
        }
        fileTable.remove(fileID.internalRefkey)
        logAndRevise(.Delete(fileID))
    }
    mutating func rename(fileID: FileID2, to newName: String) throws {
        try validateName(newName)
        try validateUniqueName(newName, forSiblingsOf: fileID)
        fileTable[fileID.internalRefkey].name = newName
        logAndRevise(.Update(fileID))
    }



    ////////////////////////////////////////////////////////////////

    private func validateName(name: String) throws {
        guard name != "" else { throw FileTree2Error.EmptyStringFileName }
    }
    private func validateUniqueName(name: String, forSubfilesOf superfileID: FileID2) throws {
        for subfileID in fileTable[superfileID.internalRefkey].subfileIDs {
            guard fileTable[subfileID.internalRefkey].name != name else { throw FileTree2Error.DuplicatedFileName }
        }
    }
    private func validateUniqueName(name: String, forSiblingsOf fileID: FileID2) throws {
        guard let superfileID = fileTable[fileID.internalRefkey].superfileID else {
            precondition(fileID == rootID, "Inconsistent internal state. A node with no `superfileID`, but the file ID is not root ID.")
            return
        }
        for subfileID in fileTable[superfileID.internalRefkey].subfileIDs {
            guard subfileID != fileID else { continue } // Skip current file. Because its name is going to be changed.
            guard fileTable[subfileID.internalRefkey].name != name else { throw FileTree2Error.DuplicatedFileName }
        }
    }
}
extension FileTree2: SequenceType {
    /// Iterate all file nodes in random order, but fastest.
    func generate() -> AnyGenerator<(FileID2, FileState2)> {
        let g = fileTable.generate()
        return AnyGenerator {
            if let next = g.next() {
                return (next.0.toFileID(), next.1)
            }
            return nil
        }
    }
}
extension FileTree2 {
    func contains(fileID: FileID2) -> Bool {
        return fileTable.contains(fileID.internalRefkey)
    }
    /// - Returns:
    ///     `nil` if passed file ID is root.
    ///     Throws `FileTree2Error.BadFileID` if the file ID does not exist in this tree.
    ///     Otherwise, this should return a file ID.
    func searchContainerFileIDOf(fileID: FileID2) throws -> FileID2? {
        let path = resolvePathFor(fileID)
        guard let parentPath = path.splitLast()?.head else { return nil }
        guard let parentID = searchFileIDForPath(parentPath) else { throw FileTree2Error.BadFileID(fileID) }
        return parentID
    }
}

enum FilePhase {
    case Editing
    case Normal
}
enum FileForm {
    case Container
    case Data
}
struct FileState2: VersioningStateType {
    private(set) var version = Version()
    private(set) var superfileID: FileID2? {
        didSet {
            version.revise()
        }
    }
    private(set) var subfileIDs: [FileID2] = [] {
        didSet {
            version.revise()
        }
    }
    let form: FileForm
    var phase = FilePhase.Normal
    var name: String {
        didSet {
            version.revise()
        }
    }
    var comment: String? {
        didSet {
            version.revise()
        }
    }
    init(form: FileForm, phase: FilePhase, name: String) {
        self.form = form
        self.phase = phase
        self.name = name
    }
}

private extension ReferencingKey {
    func toFileID() -> FileID2 {
        return FileID2(internalRefkey: self)
    }
}
private extension Array where Element: Equatable {
    mutating func removeFirstEqualElement(element: Element) {
        for i in entireRange {
            if self[i] == element {
                removeAtIndex(i)
                return
            }
        }
    }
}


















