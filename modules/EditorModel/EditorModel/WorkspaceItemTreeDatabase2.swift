//
//  WorkspaceItemTreeDatabase2.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/09/22.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation



/// Manages workspace items.
///
/// Workspace item is a sorted list of paths to files in the workspace.
/// All items are full paths to workspace root.
/// Container directories must have an explicit entry. Missing container
/// is an error, and will not be created implicitly.
///
/// Thread Consideration
/// --------------------
/// This class is single-thread only. Do not use this object from multiple
/// thread simultaneously. Anyway it's fine to use this from non-main thread.
///
/// Performance Design
/// ------------------
/// This database is designed for acceptable average performance for all
/// operations. All of insert/update/delete/move trigger local update, and
/// do not trigger whole database update or lookup.
///
/// Previous design was simple `path -> content` map, and it works well if
/// you don't need "move" operation. With this design, "move" needs update of
/// every paths of target subtree, and that is ridiculously expensive, and
/// unacceptable.
///
/// This design keeps a separated unique ID and does not use path as a key.
/// So all the keys don't need to be updated for "move" operation. Anyway,
/// lookup-by-path cost increased from hash-lookup `O(1) ~ O(n)` to binary-
/// tree lookup `O(log n)`. But I think this is better because cost is 
/// distributed over multiple operations. So total cost curve will be 
/// increased linearly with no spikes.
///
public class WorkspaceItemTreeDatabase {

	public struct ID: Hashable, CustomStringConvertible {
		public var hashValue: Int {
			get {
				return	ObjectIdentifier(_identity).hashValue
			}
		}
		public var description: String {
			get {
				let	num	=	ObjectIdentifier(_identity).uintValue
				let	str	=	String(format: "%2x", num)
				return	str
			}
		}

		///

		/// Designed to be shared by many the nodes in the tree.
		private let	_identity	=	_Identity()

		private init() {
		}
	}

	///

	/// Creates an empty database.
	///
	/// Newrly created database is fully empty, and does not even have
	/// a root node. You need to call `createRoot` to make it usable
	/// state. You cannot add any subitem with no root.
	public init() {
	}

	///

	/// Creates a new, separated database intance that contains exact
	/// copy of current database.
	public func duplicate() -> WorkspaceItemTreeDatabase {
		_assertValidity()
		let	copy	=	WorkspaceItemTreeDatabase()
		copy._rootID	=	_rootID
		copy._mappings	=	_mappings
		return	copy
	}

	///

	/// Number of all nodes in this database.
	public var count: Int {
		get {
			_assertValidity()
			return	_mappings.count
		}
	}
	internal func IDForPath(path: WorkspaceItemPath) -> ID? {
		_assertValidity()
		return	_findIDForPath(path)
	}
	internal func IDToPath(id: ID) -> WorkspaceItemPath {
		if let content = _mappings[id] {
			if let supernodeID = content.supernode {
				return	IDToPath(supernodeID).pathByAppendingLastComponent(content.name)
			}
		}
		fatalError()
	}

	internal func allSubitemIDsOfItemForID(id: ID) -> [ID] {
		_assertValidity()

		if let content = _mappings[id] {
			return	content.subnodes
		}
		else {
			fatalError()
		}
	}

	///

	public func createRoot() {
		precondition(_rootID == nil)
		_assertValidity()

		let	id	=	ID()
		_rootID		=	id
		_mappings[id]	=	_Content(group: true, name: "", comment: nil, supernode: nil, subnodes: [])

		_assertValidity()
	}
	public func deleteRoot() {
		precondition(_rootID != nil)
		_assertValidity()

		let	id	=	_rootID!
		_mappings[id]	=	nil
		_rootID		=	nil

		_assertValidity()
	}

	internal func insertSubitem(group: Bool, name: String, at index: Int, of containerItemID: ID) {
		_assertValidity()
		precondition(_mappings[containerItemID] != nil)

		let	id	=	ID()
		_mappings[id]	=	_Content(group: group, name: name, comment: nil, supernode: containerItemID, subnodes: [])
		_mappings[containerItemID]!.subnodes.insert(id, atIndex: index)

		_assertValidity()
	}

	/// Deletes specified subitem and all its descendants.
	internal func deleteSubtreeOfID(id: ID) {
		_assertValidity()

		if let content = _mappings[id] {
			for subnodeID in content.subnodes.reverse() {
				deleteSubtreeOfID(subnodeID)
			}
			_mappings[id]	=	nil
		}

		_assertValidity()
	}

	///

	private var	_rootID		:	_ID?
	private var	_mappings	=	[_ID: _Content]()

	///

	/// Pretty expensive.
	/// O(m) ~ O(n * m) where m == depth of path.
	private func _findIDForPath(path: WorkspaceItemPath) -> _ID? {
		guard _mappings.count > 0 else {
			return	nil
		}

		struct PathPartCursor {
			var	path	:	WorkspaceItemPath
			var	index	:	Int

			func currentPart() -> String {
				return	path.parts[index]
			}
			func nextPartCursor() -> PathPartCursor? {
				guard index < path.parts.count else {
					return	nil
				}
				return	PathPartCursor(path: path, index: index+1)
			}
		}

		func findIDForPathWithinNodeForID(cursor: PathPartCursor, containerID: _ID) -> _ID? {
			let	containerContent	=	_mappings[containerID]!
			let	currentPart		=	cursor.currentPart()
			for subnodeID in containerContent.subnodes {
				assert(_mappings[subnodeID] != nil)
				if _mappings[subnodeID]!.name == currentPart {
					if let nc = cursor.nextPartCursor() {
						return	findIDForPathWithinNodeForID(nc, containerID: subnodeID)
					}
					else {
						return	subnodeID
					}
				}
				else {
					continue
				}
			}
			return	nil
		}

		precondition(_rootID != nil)
		return	findIDForPathWithinNodeForID(PathPartCursor(path: path, index: 0), containerID: _rootID!)
	}

	private func _assertValidity() {
		func run() -> Bool {
			do {
				try _checkValidity()
				return	true
			}
			catch let error {
				fatalError("\(error)")
			}
		}
		assert(run())
	}
	private func _checkValidity() throws {
		struct InconsistentStateError: ErrorType {
			var	message	:	String
		}

		// Supernode existence check.
		for (k,v) in _mappings {
			if let supernode = v.supernode {
				guard _mappings[supernode] != nil else {
					throw 	InconsistentStateError(message: "A node for ID `\(k)` has a supernode `\(supernode)`, but the supernode ID does not exist in database.")
				}
			}
		}

		// Subnode existence check.
		for (k,v) in _mappings {
			for subnode in v.subnodes {
				guard _mappings[subnode] != nil else {
					throw 	InconsistentStateError(message: "A node for ID `\(k)` has a subnode `\(subnode)`, but the subnode ID does not exist in database.")
				}
			}
		}

		// Cycle reference check.
		for k in _mappings.keys {
			func checkDuplicatedKey(var keyset: Set<_ID>, nodeID: _ID) throws {
				keyset.insert(nodeID)

				// Guaranteed to be exists for the ID by previous checks.
				let	nodeContent	=	_mappings[nodeID]!
				for subnode in nodeContent.subnodes {
					guard keyset.contains(subnode) == false else {
						throw InconsistentStateError(message: "A node for ID `\(nodeID)` has a cycle reference to node ID `\(subnode)` that is one of its supernode.")
					}
					try checkDuplicatedKey(keyset, nodeID: subnode)
				}
			}
			try checkDuplicatedKey([], nodeID: k)
		}

		// Group state check. (best effort)
		for (k,v) in _mappings {
			guard v.subnodes.count == 0 || v.group == true else {
				throw InconsistentStateError(message: "A node for ID `\(k)` has some subnodes, but was not marked as a group. (`.group == false`)")
			}
		}
	}
}

public func == (a: WorkspaceItemTreeDatabase.ID, b: WorkspaceItemTreeDatabase.ID) -> Bool {
	return	a._identity === b._identity
}






public extension WorkspaceItemTreeDatabase {

	public func containsNodeAtPath(path: WorkspaceItemPath) -> Bool {
		_assertValidity()
		return	_findIDForPath(path) != nil
	}

	public func allSubitemPathsOfItemAtPath(path: WorkspaceItemPath) -> [WorkspaceItemPath] {
		_assertValidity()
		assert(_findIDForPath(path) != nil)

		if let id = _findIDForPath(path) {
			let	subitemIDs	=	allSubitemIDsOfItemForID(id)
			let	subitemPaths	=	subitemIDs.map(self.IDToPath)
			return	subitemPaths
		}
		else {
			fatalError()
		}
	}
	public func commentOfItemAtPath(path: WorkspaceItemPath) -> String? {
		_assertValidity()

		if let id = IDForPath(path) {
			assert(_mappings[id] != nil)
			return	_mappings[id]!.comment
		}
		else {
			fatalError()
		}

		_assertValidity()
	}
	public func setComment(comment: String?, ofItemAtPath path: WorkspaceItemPath) {
		_assertValidity()

		if let id = IDForPath(path) {
			assert(_mappings[id] != nil)
			_mappings[id]!.comment	=	comment
		}
		else {
			fatalError()
		}

		_assertValidity()
	}

	///

	public func insertSubitem(group group: Bool, name: String, at index: Int, of containerItemPath: WorkspaceItemPath) {
		if let id = IDForPath(containerItemPath) {
			insertSubitem(group, name: name, at: index, of: id)
		}
		else {
			fatalError("Cannot find ID for path `\(containerItemPath)`.")
		}
	}

	/// Moves specified subitem and all its descendants to a new location.
	///
	/// - parameter index:	Specifies index of new location in its supernode.
	public func moveSubtree(from from: (subitemIndex: Int, superitemPath: WorkspaceItemPath), to: (subitemIndex: Int, superitemPath: WorkspaceItemPath)) {
		_assertValidity()

		if let fromID = IDForPath(from.superitemPath) {
			if let toID = IDForPath(to.superitemPath) {
				let	subtreeID		=	_mappings[fromID]!.subnodes[from.subitemIndex]

				// Everything is ready.
				// Perform transaction.
				assert(_mappings[fromID] != nil)
				assert(_mappings[subtreeID]!.supernode == fromID)

				_mappings[fromID]!.subnodes.removeAtIndex(from.subitemIndex)
				_mappings[toID]!.subnodes.insert(subtreeID, atIndex: to.subitemIndex)
				_mappings[subtreeID]!.supernode	=	toID

				_assertValidity()
			}
		}
	}
//
//	/// Moves specified subitem and all its descendants to a new location.
//	///
//	/// - parameter index:	Specifies index of new location in its supernode.
//	public func moveSubtreeAtPath(from: WorkspaceItemPath, to: WorkspaceItemPath, at index: Int) {
//		_assertValidity()
//		precondition(to != WorkspaceItemPath.root)
//
//		if let fromID = IDForPath(from) {
//			if let fromContainerID = _mappings[fromID]!.supernode {
//				let	toContainerPath	=	to.pathByDeletingLastComponent()
//				if let toContainerID = IDForPath(toContainerPath) {
//					// Everything is ready.
//					// Perform transaction.
//					assert(_mappings[fromContainerID] != nil)
//					assert(_mappings[fromContainerID]!.subnodes.indexOf(fromID) != nil)
//					assert(_mappings[fromID] != nil)
//
//					let	fromIndex	=	_mappings[fromContainerID]!.subnodes.indexOf(fromID)!
//					_mappings[fromContainerID]!.subnodes.removeAtIndex(fromIndex)
//					_mappings[toContainerID]!.subnodes.insert(fromID, atIndex: index)
//
//					assert(_mappings[fromID]!.supernode == fromContainerID)
//					_mappings[fromID]!.supernode	=	toContainerID
//
//					_assertValidity()
//				}
//			}
//		}
//
//	}

	/// Deletes specified subitem and all its descendants.
	public func deleteSubtree(at path: WorkspaceItemPath) {
		if let id = IDForPath(path) {
			deleteSubtreeOfID(id)
		}
		else {
			fatalError("Cannot find ID for path `\(path)`.")
		}
	}

}









private typealias	_ID	=	WorkspaceItemTreeDatabase.ID


private struct _Content {
	var	group		:	Bool
	var	name		:	String
	var	comment		:	String?

	var	supernode	:	_ID?
	var	subnodes	:	[_ID]
}








private final class _Identity {
}




