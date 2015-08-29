//
//  WorkspaceItemTreeDatabase.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/29.
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
/// thread. Anyway it's fine to use this from non-main thread.
///
final class WorkspaceItemTreeDatabase {

	init() {
		_createEmptyRootItem()
	}
	private init(mappings: [WorkspaceItemPath: _InMemoryContent]) {
		_mappings	=	mappings
	}

	func duplicate() -> WorkspaceItemTreeDatabase {
		return	WorkspaceItemTreeDatabase(mappings: _mappings)
	}

	///

	var count: Int {
		get {
			return	_mappings.count
		}
	}
	func containsItemForPath(path: WorkspaceItemPath) -> Bool {
		return	_mappings[path] != nil
	}
	func insertItemAtPath(path: WorkspaceItemPath) {
		precondition(_mappings[path] == nil)
		_mappings[path]	=	(nil, [])
	}
	func deleteItemAtPath(path: WorkspaceItemPath) {
		precondition(_mappings[path] != nil)
		_mappings[path]	=	nil
	}

	///

	func allSubitemsOfItemAtPath(containerItemPath: WorkspaceItemPath) -> [WorkspaceItemPath] {
		precondition(_mappings[containerItemPath] != nil)
		return	_mappings[containerItemPath]!.subitems
	}
	func appendSubitemAtPath(subitemPath: WorkspaceItemPath, to containerAtPath: WorkspaceItemPath) {
		precondition(_mappings[containerAtPath] != nil)
		_mappings[containerAtPath]!.subitems.append(subitemPath)
	}
	func insertSubitemAtPath(subitemPath: WorkspaceItemPath, at index: Int, to containerAtPath: WorkspaceItemPath) {
		precondition(_mappings[containerAtPath] != nil)
		_mappings[containerAtPath]!.subitems.insert(subitemPath, atIndex: index)
	}
	func removeSubitemAtPath(subitemPath: WorkspaceItemPath, at index: Int, from containerAtPath: WorkspaceItemPath) {
		precondition(_mappings[containerAtPath] != nil)
		let	index	=	_mappings[containerAtPath]!.subitems.indexOf(subitemPath)
		assert(index != nil)
		removeSubitemAtIndex(index!, from: containerAtPath)
	}
	func removeSubitemAtIndex(index: Int, from containerAtPath: WorkspaceItemPath) {
		precondition(_mappings[containerAtPath] != nil)
		_mappings[containerAtPath]!.subitems.removeAtIndex(index)
	}

	///

	func commentOfItemAtPath(path: WorkspaceItemPath) -> String? {
		precondition(_mappings[path] != nil)
		return	_mappings[path]!.comment
	}
	func setComment(comment: String?, ofItemAtPath path: WorkspaceItemPath) {
		precondition(_mappings[path] != nil)
		_mappings[path]!.comment	=	comment
	}

	///

	private var	_mappings	=	[WorkspaceItemPath: _InMemoryContent]()

	private func _createEmptyRootItem() {
		_mappings[WorkspaceItemPath(parts: [])]	=	(nil, [])
	}

}

private typealias	_InMemoryContent	=	(comment: String?, subitems: [WorkspaceItemPath])






extension WorkspaceItemTreeDatabase {
	typealias	Error	=	WorkspaceItemSerialization.Error

	convenience init(snapshot: String, repairAutomatically: Bool) throws {
		assert(repairAutomatically == false, "Repairing is not supported nor implemented yet.")
		self.init()

		func insertItem(item: WorkspaceItemSerialization.PersistentItem) {
			precondition(_mappings[item.path] == nil)
			_mappings[item.path]	=	(item.comment, [])
		}

		let	items	=	try WorkspaceItemSerialization.deserializeList(snapshot)
		for item in items {
			let	path	=	item.path
			guard containsItemForPath(path) else {
				throw Error(message: "There's a duplicated path entry `\(path)` in snapshot.")
			}
			insertItem(item)
			if path == WorkspaceItemPath.root {
				// Nothing to do.
			}
			else {
				let	containerPath	=	path.pathByDeletingLastComponent()
				guard allSubitemsOfItemAtPath(path).indexOf(containerPath) == nil else {
					throw Error(message: "There's a duplicated subitem path entry `\(path)` in container item at path `\(containerPath)`.")
				}
				appendSubitemAtPath(path, to: containerPath)
			}
		}
	}

	/// Makes a string that can be used as a content of
	/// a persistent project file.
	///
	/// Produced string is a list of URLs that separated
	/// by `\n` character.
	/// URL is not a file url. This uses special scheme
	/// to eliminate vague bahavior of file-URL.
	/// Also employes query-string to store extra data.
	///
	/// - `comment` stores extra comment for the file entry.
	///
	func snapshot() -> String {
		let	items	=	_snapshotListOfAllPathsAsPersistentItem()
		return	WorkspaceItemSerialization.serializeList(items)
	}

	///

	private func _snapshotListOfAllPathsAsPersistentItem() -> [WorkspaceItemSerialization.PersistentItem] {
		var	ps		=	Array<WorkspaceItemSerialization.PersistentItem>()
		_iterateDFS { (path, content) -> () in
			ps.append((path, content.comment))
		}
		return	ps
	}

	private func _iterateDFS(onNode: (path: WorkspaceItemPath, content: _InMemoryContent)->()) {
		let	rootPath	=	WorkspaceItemPath(parts: [])
		return	_iterateDFSItemAtPath(rootPath, onNode: onNode)
	}
	private func _iterateDFSItemAtPath(path: WorkspaceItemPath, onNode: (path: WorkspaceItemPath, content: _InMemoryContent)->()) {
		let	content		=	_mappings[path]!
		for subpath in content.subitems {
			_iterateDFSItemAtPath(subpath, onNode: onNode)
		}

	}
}






