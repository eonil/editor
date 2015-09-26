////
////  WorkspaceItemTreeDatabase.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/08/29.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
///// Manages workspace items.
/////
///// Workspace item is a sorted list of paths to files in the workspace.
///// All items are full paths to workspace root.
///// Container directories must have an explicit entry. Missing container
///// is an error, and will not be created implicitly.
/////
///// Thread Consideration
///// --------------------
///// This class is single-thread only. Do not use this object from multiple 
///// thread. Anyway it's fine to use this from non-main thread.
/////
//final class WorkspaceItemTreeDatabase {
//
//	/// Creates a database with default root element that has no child.
//	init() {
//		_createEmptyRootItem()
//	}
//	/// Creates a database with list of path-contents.
//	///
//	/// - Parameters:
//	///	- mappings
//	///		List of path-contents. This list must contain
//	///		a root element at first.
//	private init(mappings: [WorkspaceItemPath: _InMemoryContent]) {
//		_mappings	=	mappings
//	}
//
//	/// Creates a new, separated database intance that contains exact 
//	/// copy of current database.
//	func duplicate() -> WorkspaceItemTreeDatabase {
//		assert(_checkValidity())
//		return	WorkspaceItemTreeDatabase(mappings: _mappings)
//	}
//
//	///
//
//	var count: Int {
//		get {
//			return	_mappings.count
//		}
//	}
//	func containsItemForPath(path: WorkspaceItemPath) -> Bool {
//		assert(_checkValidity())
//		return	_mappings[path] != nil
//	}
//	func insertItemAtPath(path: WorkspaceItemPath) {
//		precondition(_mappings[path] == nil, "A item for path `path` already exists.")
//		assert(_checkValidity())
//
//		_mappings[path]	=	(nil, false, [])
//
//		assert(_checkValidity())
//	}
//	func deleteItemAtPath(path: WorkspaceItemPath) {
//		precondition(_mappings[path] != nil)
//		precondition(_mappings[path]!.subitems.count == 0)
//		assert(_checkValidity())
//
//		_mappings[path]	=	nil
//
//		assert(_checkValidity())
//	}
//	func deleteItemAndSubtreeRecursivelyAtPath(path: WorkspaceItemPath) {
//		precondition(_mappings[path] != nil)
//		assert(_checkValidity())
//
//		let	subpaths	=	_mappings[path]!.subitems
//		for subpath in subpaths.reverse() {
//			deleteItemAndSubtreeRecursivelyAtPath(subpath)
//		}
//		deleteItemAtPath(path)
//
//		assert(_checkValidity())
//	}
//
////	func relocateItemAndSubtreeRecursivelyAtPath(from: WorkspaceItemPath, to: WorkspaceItemPath) {
////		precondition(from != to)
////		assert(_checkValidity())
////
////		let	content	=	_mappings[from]!
////		_mappings[from]	=	nil
////		_mappings[to]	=	content
////
////		for k in _mappings.keys {
////			// Ah fuck. This can't be done just by moving content.
////			// ALL THE KEYS in the database need to be updated.
////			markUnimplemented()
////		}
////
////
////		assert(_checkValidity())
////	}
//
//	///
//
//	func allSubitemsOfItemAtPath(containerItemPath: WorkspaceItemPath) -> [WorkspaceItemPath] {
//		precondition(_mappings[containerItemPath] != nil)
//		return	_mappings[containerItemPath]!.subitems
//	}
//	func appendSubitemAtPath(subitemPath: WorkspaceItemPath, to containerAtPath: WorkspaceItemPath) {
//		assert(_mappings[containerAtPath] != nil)
//		assert(_mappings[subitemPath] != nil)
//		precondition(_mappings[containerAtPath] != nil)
//		assert(_checkValidity())
//
//		_mappings[containerAtPath]!.subitems.append(subitemPath)
//
//		assert(_checkValidity())
//	}
//	func insertSubitemAtPath(subitemPath: WorkspaceItemPath, at index: Int, to containerAtPath: WorkspaceItemPath) {
//		assert(_mappings[containerAtPath] != nil)
//		assert(_mappings[subitemPath] != nil)
//		precondition(_mappings[containerAtPath] != nil)
//		assert(_checkValidity())
//
//		_mappings[containerAtPath]!.subitems.insert(subitemPath, atIndex: index)
//
//		assert(_checkValidity())
//	}
//	func removeSubitemAtPath(subitemPath: WorkspaceItemPath, at index: Int, from containerAtPath: WorkspaceItemPath) {
//		assert(_mappings[containerAtPath] != nil)
//		assert(_mappings[subitemPath] != nil)
//		precondition(_mappings[containerAtPath] != nil)
//		assert(_checkValidity())
//
//		let	index	=	_mappings[containerAtPath]!.subitems.indexOf(subitemPath)
//		assert(index != nil)
//		removeSubitemAtIndex(index!, from: containerAtPath)
//
//		assert(_checkValidity())
//	}
//	func removeSubitemAtIndex(index: Int, from containerAtPath: WorkspaceItemPath) {
//		assert(_mappings[containerAtPath] != nil)
//		precondition(_mappings[containerAtPath] != nil)
//		assert(_checkValidity())
//
//		_mappings[containerAtPath]!.subitems.removeAtIndex(index)
//
//		assert(_checkValidity())
//	}
//
//	///
//
//	func commentOfItemAtPath(path: WorkspaceItemPath) -> String? {
//		precondition(_mappings[path] != nil)
//		return	_mappings[path]!.comment
//	}
//	func setComment(comment: String?, ofItemAtPath path: WorkspaceItemPath) {
//		precondition(_mappings[path] != nil)
//		assert(_checkValidity())
//
//		_mappings[path]!.comment	=	comment
//
//		assert(_checkValidity())
//	}
//
//	///
//
//	func folderFlagOfItemAtPath(path: WorkspaceItemPath) -> Bool {
//		precondition(_mappings[path] != nil)
//		return	_mappings[path]!.group
//	}
//	func setFolderFlag(flag: Bool, ofItemAtPath path: WorkspaceItemPath) {
//		precondition(_mappings[path] != nil)
//		_mappings[path]!.group		=	flag
//	}
//
//	///
//
//	private var	_mappings	=	[WorkspaceItemPath: _InMemoryContent]()
//
//	private func _createEmptyRootItem() {
//		_mappings[WorkspaceItemPath(parts: [])]	=	(nil, true, [])
//	}
//
//	///
//
//	private func _checkValidity() -> Bool {
//		for (path, content) in _mappings {
//			if path == WorkspaceItemPath.root {
//				// Nothing to do.
//			}
//			else {
//				let	superpath	=	path.pathByDeletingLastComponent()
//				guard _mappings[superpath] != nil else {
//					assert(false)
//					return	false
//				}
//			}
//
//			for subpath in content.subitems {
//				guard subpath.pathByDeletingLastComponent() == path else {
//					assert(false)
//					return	false
//				}
//			}
//		}
//		return	true
//	}
//
//}
//
//private typealias	_InMemoryContent	=	(comment: String?, group: Bool, subitems: [WorkspaceItemPath])
//
//
//
//
//
//
//extension WorkspaceItemTreeDatabase {
//	typealias	Error	=	WorkspaceItemSerialization.Error
//
//	convenience init(snapshot: String, repairAutomatically: Bool) throws {
//		precondition(repairAutomatically == false, "Repairing is not supported nor implemented yet.")
//		self.init()
//
//		func insertItem(item: WorkspaceItemSerialization.PersistentItem) {
//			precondition(_mappings[item.path] == nil)
//			_mappings[item.path]	=	(item.comment, item.group, [])
//		}
//
//		let	items	=	try WorkspaceItemSerialization.deserializeList(snapshot)
//		for item in items {
//			let	path	=	item.path
//			if path == WorkspaceItemPath.root {
//				// Root entry should exists here.
//				// Nothing to do.
//			}
//			else {
//				guard containsItemForPath(path) == false else {
//					throw Error(message: "There's a duplicated path entry `\(path)` in snapshot.")
//				}
//				
//				insertItem(item)
//				let	containerPath	=	path.pathByDeletingLastComponent()
//				guard allSubitemsOfItemAtPath(path).indexOf(containerPath) == nil else {
//					throw Error(message: "There's a duplicated subitem path entry `\(path)` in container item at path `\(containerPath)`.")
//				}
//				appendSubitemAtPath(path, to: containerPath)
//			}
//		}
//	}
//
//	/// Makes a string that can be used as a content of
//	/// a persistent project file.
//	///
//	/// Produced string is a list of URLs that separated
//	/// by `\n` character.
//	/// URL is not a file url. This uses special scheme
//	/// to eliminate vague bahavior of file-URL.
//	/// Also employes query-string to store extra data.
//	///
//	/// - `comment` stores extra comment for the file entry.
//	///
//	func snapshot() -> String {
//		let	items	=	_snapshotListOfAllPathsAsPersistentItem()
//		return	WorkspaceItemSerialization.serializeList(items)
//	}
//
//	///
//
//	private func _snapshotListOfAllPathsAsPersistentItem() -> [WorkspaceItemSerialization.PersistentItem] {
//		var	ps		=	Array<WorkspaceItemSerialization.PersistentItem>()
//		_iterateDFS { (path, content) -> () in
//			ps.append((path, content.group, content.comment))
//		}
//		return	ps
//	}
//
//	private func _iterateDFS(onNode: (path: WorkspaceItemPath, content: _InMemoryContent)->()) {
//		let	rootPath	=	WorkspaceItemPath(parts: [])
//		return	_iterateDFSItemAtPath(rootPath, onNode: onNode)
//	}
//	private func _iterateDFSItemAtPath(path: WorkspaceItemPath, onNode: (path: WorkspaceItemPath, content: _InMemoryContent)->()) {
//		assert(_mappings[path] != nil)
//		let	content		=	_mappings[path]!
//		onNode(path: path, content: content)
//
//		for subpath in content.subitems {
//			_iterateDFSItemAtPath(subpath, onNode: onNode)
//		}
//
//	}
//}
//
//
//
//
//
//
