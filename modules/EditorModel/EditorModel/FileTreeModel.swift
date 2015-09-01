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

	deinit {
		assert(_isInstalled == false)
	}

	///

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
	public var storing: CompletionChannel {
		get{
			return	_storing
		}
	}
	public var restoring: CompletionChannel {
		get {
			return	_restoring
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
		markUnimplemented()
	}
	public func runDeletingFolderAtPath(path: WorkspaceItemPath) {
		markUnimplemented()

	}
	public func runCreatingFileAtPath(path: WorkspaceItemPath) {
		let	fu	=	path.absoluteFileURL(`for`: workspace)
		let 	ok	=	NSData().writeToURL(fu, atomically: true)
		if ok {
			_insertNodeAtPath(path)
		}
		else {
			markUnimplemented()
		}
	}
	public func runDeletingFileAtPath(path: WorkspaceItemPath) {
		_deleteNodeAtPath(path)
	}

	///

	private let	_root	=	MutableValueStorage<FileNodeModel?>(nil)
	private var	_db	=	WorkspaceItemTreeDatabase()
	private let	_isBusy	=	MutableValueStorage<Bool>(false)

	private let	_storing	=	CompletionQueue()
	private let	_restoring	=	CompletionQueue()

	private var	_isInstalled	=	false

	///

	private func _install() {
		assert(_root.value == nil)
		assert(_isInstalled == false)

		_installRoot()
		_isInstalled		=	true
	}
	private func _deinstall() {
		assert(_root.value != nil)
		assert(_isInstalled == true)

		_deinstallRoot()
		_isInstalled		=	false
	}

	/// Installs a new root node from database.
	private func _installRoot() {
		assert(_root.value === nil)

		let	node		=	_rebuildFileNodeModelTree(self, _db)
		node._path.value	=	WorkspaceItemPath.root
		node._comment.value	=	_db.commentOfItemAtPath(WorkspaceItemPath.root)
		node.owner		=	self
		_root.value		=	node
	}
	private func _deinstallRoot() {
		assert(_root.value !== nil)

		let	node		=	_root.value!
		_root.value		=	nil
		node.owner		=	nil
		node._comment.value	=	nil
		node._path.value	=	nil
	}

	///

	private func _runRestoringSnapshot() {
		precondition(_isBusy.value == false)
		_isBusy.value	=	true
		let	u	=	_snapshotFileURL()
		dispatchToMainQueueAsynchronously { [weak self] in
//		dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { [weak self] in
			self?._restoreSnapshotFromURL(u)
			dispatchToMainQueueAsynchronously { [weak self] in
				self?._restoring.cast()
				self?._isBusy.value	=	false
			}
		}
	}

	private func _restoreSnapshotFromURL(u: NSURL) {
//		Debug.assertNonMainThread()
		do {
			let	data	=	try Platform.thePlatform.fileSystem.contentOfFileAtURLAtomically(u)
			if let s = NSString(data: data, encoding: NSUTF8StringEncoding) as String? {
				_deinstallRoot()

				let	db		=	try! WorkspaceItemTreeDatabase(snapshot: s, repairAutomatically: false)
				_db		=	db

				_installRoot()
			}
			else {
				assert(false, "Could not read a valid UTF-8 string from file `\(u)`.")
				markUnimplemented()
			}
		}
		catch let error as NSError {
			assert(false, "Could not find file `\(u)`. An error `\(error)` occured.")
			markUnimplemented()
		}

	}
	private func _runStoringSnapshot() {
		_isBusy.value	=	true
		let	db1	=	_db.duplicate()
		let	u	=	_snapshotFileURL()
		dispatchToMainQueueAsynchronously { [weak self] in
//		dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
			guard self != nil else {
				return
			}

			precondition(self!._isBusy.value == false)
			self!._storeSnapshotToURL(u, database: db1)
			dispatchToMainQueueAsynchronously { [weak self] in
				if let _ = self {
					self!._storing.cast()
					self!._isBusy.value	=	false
				}
			}
		}
	}
	private func _storeSnapshotToURL(u: NSURL, database: WorkspaceItemTreeDatabase) {
//		Debug.assertNonMainThread()
		let	s	=	database.snapshot()
		Debug.log("Storing snapshot `\(s)`...")
		let	d	=	s.dataUsingEncoding(NSUTF8StringEncoding)!
		do {
			try Platform.thePlatform.fileSystem.replaceContentOfFileAtURLAtomically(u, data: d)
		}
		catch let error as NSError {
			assert(false, "Could not write to file `\(u)`. An error `\(error)` occured.")
			markUnimplemented()
		}
	}

	private func _snapshotFileURL() -> NSURL {
		assert(workspace.location.value != nil)
		return	workspace.location.value!.URLByAppendingPathComponent("Workspace.EditorFileList")
	}

	///

	private func _insertNodeAtPath(path: WorkspaceItemPath) {
		let	containerPath	=	path.pathByDeletingLastComponent()
		if let node = _findNodeForPath(containerPath) {
			for subnode in node.subnodes.array {
				if subnode.path.value == path {
					markUnimplemented()
					return
				}
			}
//			assert(node.subnodes.array.filter({ $0.path.value == path }).count == 0)

			_db.insertItemAtPath(path)
			_db.appendSubitemAtPath(path, to: containerPath)
			let	newnode		=	FileNodeModel()
			newnode.owner		=	self
			newnode.supernode	=	node
			newnode._path.value	=	path
			node._subnodes.append(newnode)
			return
		}
		assert(false)
	}
	private func _deleteNodeAtPath(path: WorkspaceItemPath) {
		if let node = _findNodeForPath(path) {
			if let supernode = node.supernode {
				if let idx = supernode.subnodes.array.indexOfValueByReferentialIdentity(node) {
					supernode._subnodes.delete(idx...idx)
					_db.deleteItemAndSubtreeRecursivelyAtPath(path)
					return
				}
			}
		}
		assert(false)
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

	deinit {
		assert(_isInstalled == false)
	}

	///

	public var tree: FileTreeModel {
		get {
			assert(owner != nil)
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
	internal var	_isInstalled	=	false

	///

	private func _install() {
		assert(_isInstalled == false)

		for subnode in subnodes.array {
			assert(subnode.owner === nil)
			subnode.owner	=	owner!
		}

		_isInstalled	=	true
	}
	private func _deinstall() {
		assert(_isInstalled == true)

		for subnode in subnodes.array {
			assert(subnode.owner === owner!)
			subnode.owner	=	nil
		}

		_isInstalled	=	false
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
private func _rebuildFileNodeModelTree(tree: FileTreeModel, _ snapshotDatabase: WorkspaceItemTreeDatabase) -> FileNodeModel {
	return	_rebuildFileNodeModelSubtree(tree, snapshotDatabase, `for`: WorkspaceItemPath.root)
}
/// Can be executed in any single thread.
private func _rebuildFileNodeModelSubtree(tree: FileTreeModel, _ snapshotDatabase: WorkspaceItemTreeDatabase, `for` path: WorkspaceItemPath) -> FileNodeModel {
	let	node		=	FileNodeModel()
	node._path.value	=	path
	node._comment.value	=	snapshotDatabase.commentOfItemAtPath(path)
	node.owner		=	tree

	let	subpaths	=	snapshotDatabase.allSubitemsOfItemAtPath(path)
	var	subnodes	=	[FileNodeModel]()
	subnodes.reserveCapacity(subpaths.count)
	for subpath in subpaths {
		let	subnode		=	_rebuildFileNodeModelSubtree(tree, snapshotDatabase, `for`: subpath)
		subnode.supernode	=	node
		subnodes.append(subnode)
	}
	node._subnodes.extend(subnodes)
	return	node
}






internal func TEST_STUB_rebuildFileNodeModelTree(tree: FileTreeModel, _ snapshotDatabase: WorkspaceItemTreeDatabase) -> FileNodeModel {
	return	_rebuildFileNodeModelTree(tree, snapshotDatabase)
}
extension FileTreeModel {
	internal func TEST_STUB_restoreSnapshotFromURL(u: NSURL) {
		_restoreSnapshotFromURL(u)
	}
}














