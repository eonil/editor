//
//  FileTreeModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import EditorCommon

public class FileTreeModel: ModelSubnode<WorkspaceModel> {

	public var workspace: WorkspaceModel {
		get {
			assert(owner != nil)
			return	owner!
		}
	}

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
		_install()
	}
	override func willLeaveModelRoot() {
		_deinstall()
		super.willLeaveModelRoot()
	}

	///

	public var root: ValueStorage<FileNodeModel?> {
		get {
			return	_root
		}
	}
	public var isBusy: ValueStorage<Bool> {
		get {
			return	_isBusy
		}
	}

	///

	public func runRestoringSnapshot() {
		_runRestoringSnapshot()
	}
	public func runStoringSnapshot() {
		_runStoringSnapshot()
	}

	///

//	public func runCreatingFolderInContainerFolderAtPath(containerFolderPath: WorkspaceItemPath) {
//
//	}
	public func runCreatingFolderAtPath(path: WorkspaceItemPath) {

	}
	public func runDeletingFolderAtPath(path: WorkspaceItemPath) {

	}
	public func runCreatingFileAtPath(path: WorkspaceItemPath) {

	}
	public func runDeletingFileAtPath(path: WorkspaceItemPath) {
		
	}

	///

	private let	_root	=	MutableValueStorage<FileNodeModel?>(nil)
	private var	_db	=	WorkspaceItemTreeDatabase()
	private let	_isBusy	=	MutableValueStorage<Bool>(false)

	///

	private func _install() {
		_root.value			=	FileNodeModel()
		_root.value!.owner		=	self
		_root.value!._path.value	=	WorkspaceItemPath.root
		_root.value!._comment.value	=	_db.commentOfItemAtPath(WorkspaceItemPath.root)
	}
	private func _deinstall() {
		_root.value!._comment.value	=	nil
		_root.value!._path.value	=	nil
		_root.value!.owner		=	nil
		_root.value			=	nil
	}

	///

	private func _runRestoringSnapshot() {
		precondition(_isBusy.value == false)
		_isBusy.value	=	true
		let	u	=	_snapshotFileURL()
//		dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { [weak self] in
			if let d = NSData(contentsOfURL: u) {
				if let s = NSString(data: d, encoding: NSUTF8StringEncoding) as String? {
					let	db		=	try! WorkspaceItemTreeDatabase(snapshot: s, repairAutomatically: false)
					let	node		=	_rebuildFileNodeModelTree(db)
					self._db		=	db
					self._root.value	=	node
				}
				else {
					assert(false, "Could not read a valid UTF-8 string from file `\(u)`.")
					markUnimplemented()
				}
			}
			else {
				assert(false, "Could not find file `\(u)`.")
				markUnimplemented()
			}

			dispatchToMainQueueAsynchronously { [weak self] in
				self?._isBusy.value	=	false
			}
//		}
	}
	private func _runStoringSnapshot() {
		precondition(_isBusy.value == false)
		_isBusy.value	=	true
		let	db1	=	_db.duplicate()
		let	u	=	_snapshotFileURL()
//		dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
			let	s	=	db1.snapshot()
			let	d	=	s.dataUsingEncoding(NSUTF8StringEncoding)
			let	ok	=	d!.writeToURL(u, atomically: true)
			assert(ok)
			dispatchToMainQueueAsynchronously { [weak self] in
				self?._isBusy.value	=	false
			}
//		}
	}
	private func _snapshotFileURL() -> NSURL {
		assert(workspace.location.value != nil)
		return	workspace.location.value!.URLByAppendingPathComponent("Workspace.EditorFileList")
	}

	///

	private func _findNodeForPath(path: WorkspaceItemPath) -> FileNodeModel? {
		return	_root.value?._findNodeForPath(path)
	}
}





/// NO LAZY LOADING RIGHT NOW. UNIMPLEMENTED YET.
///
/// You must manually `loadSubnodes` subnodes before accesing `subnode` proeprty.
/// Also you must manually call `unloadSubodes` when you don't use them anymore.
public class FileNodeModel: ModelSubnode<FileTreeModel> {

	public var tree: FileTreeModel {
		get {
			return	owner!
		}
	}

	public private(set) weak var supernode: FileNodeModel?

	///

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
		_install()
	}
	override func willLeaveModelRoot() {
		_deinstall()
		super.willLeaveModelRoot()
	}

	///

	public var path: ValueStorage<WorkspaceItemPath?> {
		get {
			return	_path
		}
	}
	public var comment: ValueStorage<String?> {
		get {
			return	_comment
		}
	}
	public var subnodes: ArrayStorage<FileNodeModel> {
		get {
			precondition(_isLoaded == true)
			return	_subnodes
		}
	}

//	public func relocate(location: WorkspaceItemPath?) {
//		_path.value	=	location
//	}

	///

	private let	_path		=	MutableValueStorage<WorkspaceItemPath?>(nil)
	private let	_comment	=	MutableValueStorage<String?>(nil)
	private let	_subnodes	=	MutableArrayStorage<FileNodeModel>([])
	private var	_isLoaded	=	true

	///

	private func _install() {

	}
	private func _deinstall() {
	}

	private func _insertSubnodes(subnodes: [FileNodeModel], at index: Int) {
		_subnodes.insert(subnodes, atIndex: index)
		for subnode in subnodes {
			subnode.owner		=	owner!
			subnode.supernode	=	self
		}
	}
	private func _deleteSubnodeInRange(range: Range<Int>) {
		for subnode in _subnodes.array[range] {
			subnode.supernode	=	nil
			subnode.owner		=	nil
		}
		_subnodes.delete(range)
	}
//	private func _moveSubnodeToPath(toPath: WorkspaceItemPath, from fromPath: WorkspaceItemPath) {
//		_subnodes
//	}

	/// This searches only in subtree including self.
	private func _findNodeForPath(path: WorkspaceItemPath) -> FileNodeModel? {
		if let selfPath = _path.value {
			if path == selfPath {
				return	self
			}
			for subnode in _subnodes.array {
				if let subpath = subnode.path.value {
					if subpath.hasPrefix(selfPath) {
						return	subnode._findNodeForPath(path)
					}
				}
			}
		}

		return	nil
	}
}



















/// Can be executed in any single thread.
private func _rebuildFileNodeModelTree(snapshotDatabase: WorkspaceItemTreeDatabase) -> FileNodeModel {
	return	_rebuildFileNodeModelSubtree(snapshotDatabase, `for`: WorkspaceItemPath.root)
}
/// Can be executed in any single thread.
private func _rebuildFileNodeModelSubtree(snapshotDatabase: WorkspaceItemTreeDatabase, `for` path: WorkspaceItemPath) -> FileNodeModel {
	let	node		=	FileNodeModel()
	node._path.value	=	path
	node._comment.value	=	snapshotDatabase.commentOfItemAtPath(path)

	let	subpaths	=	snapshotDatabase.allSubitemsOfItemAtPath(path)
	var	subnodes	=	[FileNodeModel]()
	subnodes.reserveCapacity(subpaths.count)
	for subpath in subpaths {
		let	subnode		=	_rebuildFileNodeModelSubtree(snapshotDatabase, `for`: subpath)
		subnodes.append(subnode)
	}
	node._subnodes.extend(subnodes)
	return	node
}























