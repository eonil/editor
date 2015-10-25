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

/// `FileTreeModel` manages file tree.
///
/// A file-system on Unix-like systems is always a remote storage.
/// That means all operations are asynchronous at core level regardless
/// of high level interfaces. So you cannot get a synchronous state 
/// query or specific state guarantee. All operations are done in 
/// try-and-see manner. You just issue a command and see what happens.
///
/// All file operations are provided in synchronous interface only for 
/// your convenience, and you'll get result synchronously. All file operations
/// `return` on success, and `throw` on failure.
///
/// Anyway, non-file-operations are not written in this manner. For 
/// example, file view node management are fully predictable and synchronous,
/// so it can be asserted, and checked regardless of file operations.
///
/// Internally, this class maintains a `WorkspaceItemTree` instance to 
/// track file item list.
///
public class FileTreeModel: ModelSubnode<WorkspaceModel> {

	struct Error: ErrorType {
		enum Code {
			case CannotRestoreBecuaseCannotReadWorkspaceFileListAsUTF8String
			case CannotCreateFolderBecuaseThereIsAlreadyAnotherNodeAtPath
			case CannotMoveDueToLackOfFromContainerNode
			case CannotMoveDueToLackOfToContainerNode
			case CannotMoveBecauseOriginationIndexIsOutOfRange
			case CannotMoveBecauseDestinationIndexIsOutOfRange
			case CannotMoveDueToExistingNodeAtToPath
		}
		
		var code	:	Code
		var message	:	String
	}

	typealias	Event	=	FileTreeEvent

	///

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

//	public let selection	=	FileSelectionModel()

	///

	public var root: FileNodeModel? {
		get {
			return	_rootNodeModel
		}
	}

	///

	public func restoreSnapshot() throws {
		let u	=	_snapshotFileURL()
		try _restoreSnapshotFromURL(u)
	}
	public func storeSnapshot() {
		let u	=	_snapshotFileURL()
		_storeSnapshotToURL(u)
	}

	///

	public func containsNodeAtPath(path: WorkspaceItemPath) -> Bool {
		return	_dataTree!.root!.searchNodeForPath(path) != nil
	}

	public func searchNodeAtPath(path: WorkspaceItemPath) -> FileNodeModel? {
		return	_rootNodeModel?.search(path)
	}

//	/// This does not create any intermediate node. Due to lack of destination index informations
//	/// for intermediate nodes.
//	public func createFolder(location: (containerPath: WorkspaceItemPath, destinationIndex: Int), name: String) throws {
//		Debug.assertMainThread()
//		assert(_checkFileTreeAndWorkspaceItemTreeStructuralEquality())
//
//		guard let containerNode = _tree.root.findNodeForPath(location.containerPath) else {
//			fatalError("You must supply a proper container path")
//		}
//		guard containerNode.subnodes.count >= location.destinationIndex else {
//			fatalError("You must supply a proper destination index.")
//		}
//		guard containerNode.subnodes[name] == nil else {
//			fatalError("There's already node at the destination location `\(location)` + `\(name)`.")
//		}
//		guard _tree.root.findNodeForPath(location.containerPath) == nil else {
//			throw Error(code: FileTreeModel.Error.Code.CannotCreateFolderBecuaseThereIsAlreadyAnotherNodeAtPath, message: "Cannot create folder at path `\(location.containerPath)` because there's already a node.")
//		}
//
//		let	destinationPath	=	location.containerPath.pathByAppendingLastComponent(name)
//		let	fileURL		=	destinationPath.absoluteFileURL(`for`: workspace)
//		do {
//			try Platform.thePlatform.fileSystem.createDirectoryAtURL(fileURL, recursively: false)
//		}
//		catch let error as PlatformFileSystemError where error == .AlreadyExists {
//			// Just ignore it.
//		}
//		catch let error {
//			throw error
//		}
//
//		let	newFolderNode	=	WorkspaceItemNode(name: name, isGroup: true)
//		containerNode.subnodes.insert(newFolderNode, atIndex: location.destinationIndex)
//
//		ModelNotification.WorkspaceNotification(WorkspaceNotification.FileNodeNotification(FileNodeNotification.DidInsertSubnode(supernode: containerNode, subnode: newFolderNode, index: location.destinationIndex)))
//		_onDidChange.value	=	()
//	}
//	public func deleteFolderAtPath(path: WorkspaceItemPath) throws {
//		markUnimplemented()
//
//		_onDidChange.value	=	()
//	}
//	public func createFileAtPath(path: WorkspaceItemPath) throws {
//		let	fu	=	path.absoluteFileURL(`for`: workspace)
//		do {
//			try Platform.thePlatform.fileSystem.createFileAtURL(fu)
//			_insertNodeAtPath(path)
//
//		}
//		catch {
//			markUnimplemented()
//		}
//
//		_onDidChange.value	=	()
//	}
//	public func deleteFileAtPath(path: WorkspaceItemPath) {
//		_deleteNodeAtPath(path)
//
//		_onDidChange.value	=	()
//	}

	///

	private var	_dataTree	:	WorkspaceItemTree?
	private var	_rootNodeModel	:	FileNodeModel?
	private var	_isInstalled	=	false
	private let	_onDidChange	=	MutableValueStorage<()>(())

	///

	private func _install() {
		Debug.assertMainThread()
		assert(_rootNodeModel == nil)
		assert(_isInstalled == false)

//		selection.owner		=	self

		_dataTree		=	WorkspaceItemTree()
		_dataTree!.createRoot()		// Now root has no child.
		_installModelRoot()

		_isInstalled		=	true
	}
	private func _deinstall() {
		Debug.assertMainThread()
		assert(_rootNodeModel != nil)
		assert(_isInstalled == true)

		_deinstallModelRoot()
		_rootNodeModel		=	nil
		_dataTree!.deleteRoot()
		_dataTree		=	nil

//		selection.owner		=	nil

		_isInstalled		=	false
	}

	private func _installModelRoot() {
		assert(_rootNodeModel == nil)
		assert(_dataTree != nil)
		assert(_dataTree!.root != nil)
		_rootNodeModel		=	FileNodeModel(dataNode: _dataTree!.root!)
		_rootNodeModel!.owner	=	self
		FileTreeEvent.DidCreateRoot(root: _rootNodeModel!).broadcastWithSender(self)
	}
	private func _deinstallModelRoot() {
		FileTreeEvent.WillDeleteRoot(root: _rootNodeModel!).broadcastWithSender(self)
		assert(_rootNodeModel != nil)
		assert(_dataTree != nil)
		assert(_dataTree!.root != nil)
		_rootNodeModel!.owner	=	nil
		_rootNodeModel		=	nil
	}

//	/// Installs a new root node from database.
//	/// 
//	/// This method MUST be called in main thread.
//	private func _installRoot(node: FileNodeModel) {
//		Debug.assertMainThread()
//		assert(_root.value === nil)
//
//		node._path.value	=	WorkspaceItemPath.root
//		node._comment.value	=	_dataTree.root.comment
//		node.owner		=	self
//		_root.value		=	node
//
//		_onDidChange.value	=	()
//	}
//	/// This method MUST be called in main thread.
//	private func _deinstallRoot() {
//		Debug.assertMainThread()
//		assert(_root.value !== nil)
//
//		let	node		=	_root.value!
//		_root.value		=	nil
//		node.owner		=	nil
//		node._comment.value	=	nil
//		node._path.value	=	nil
//
//		_onDidChange.value	=	()
//	}

	///

	/// This method is transactional. Nothing will be changed on any error.
	private func _restoreSnapshotFromURL(u: NSURL) throws {
		Debug.assertMainThread()

		let	data	=	try Platform.thePlatform.fileSystem.contentOfFileAtURLAtomically(u)
		guard let s = NSString(data: data, encoding: NSUTF8StringEncoding) as String? else {
			throw	Error(code: FileTreeModel.Error.Code.CannotRestoreBecuaseCannotReadWorkspaceFileListAsUTF8String, message: "Could not read a valid UTF-8 string from file `\(u)`.")
		}
		let	tree	=	try WorkspaceItemTree(snapshot: s)

		// Status OK. Mutate it.
		_deinstallModelRoot()
		_dataTree	=	tree
		_installModelRoot()
	}
	private func _storeSnapshotToURL(u: NSURL) {
		Debug.assertMainThread()
		assert(_dataTree != nil)
		let	s	=	_dataTree!.snapshot()
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
		Debug.assertMainThread()
		assert(workspace.location.value != nil)
		return	workspace.location.value!.URLByAppendingPathComponent("Workspace.EditorFileList")
	}

	///

//	private func _moveNodeAtPath(from: (containerPath: WorkspaceItemPath, originationIndex: Int), to: (containerPath: WorkspaceItemPath, destinationIndex: Int)) throws {
//		Debug.assertMainThread()
//		guard (from.containerPath == to.containerPath && from.originationIndex == to.destinationIndex) == false else {
//			// Just treat it done.
//			return
//		}
//		guard let fromContainerNode = _dataTree!.root!.findNodeForPath(from.containerPath) else {
//			throw Error(code: FileTreeModel.Error.Code.CannotMoveDueToLackOfFromContainerNode, message: "There's no node at the `from.containerPath` `\(from)`.")
//		}
//		guard fromContainerNode.subnodes.count > from.originationIndex else {
//			throw Error(code: FileTreeModel.Error.Code.CannotMoveBecauseOriginationIndexIsOutOfRange, message: "Origination index `\(from.originationIndex)` is out of range in from node.")
//		}
//		guard let toContainerNode = _dataTree!.root!.findNodeForPath(to.containerPath) else {
//			throw Error(code: FileTreeModel.Error.Code.CannotMoveDueToLackOfToContainerNode, message: "There's no node at the `to.containerPath` `\(from)`.")
//		}
//		guard toContainerNode.subnodes.count >= to.destinationIndex else {
//			throw Error(code: FileTreeModel.Error.Code.CannotMoveBecauseDestinationIndexIsOutOfRange, message: "Destination index `\(to.destinationIndex)` is out of range in from node.")
//		}
//
//		let	movingNode		=	fromContainerNode.subnodes[from.originationIndex]
//		let	toDestinationNodePath	=	to.containerPath.pathByAppendingLastComponent(movingNode.name)
//		guard _dataTree!.root!.findNodeForPath(toDestinationNodePath) == nil else {
//			throw Error(code: FileTreeModel.Error.Code.CannotMoveDueToExistingNodeAtToPath, message: "There's already a node at the `to` path `\(to)`.")
//		}
//
//		fromContainerNode.subnodes.removeAtIndex(from.originationIndex)
//		toContainerNode.subnodes.insert(movingNode, atIndex: to.destinationIndex)
//	}

//	private func _insertNodeAtPath(path: WorkspaceItemPath) {
//		Debug.assertMainThread()
//		assert(_checkFileTreeAndWorkspaceItemTreeStructuralEquality())
//		assert(_findNodeForPath(path) == nil, "There's already a node at the path `\(path)`.")
//
//		let containerPath	=	path.pathByDeletingLastComponent()
//		assert(_tree.root.findNodeForPath(containerPath) != nil)
//
//		if let node = _findNodeForPath(containerPath) {
//			let item	=	WorkspaceItemNode(name: path.parts.last!, isGroup: false)
//			_tree.root.findNodeForPath(containerPath)!.subnodes.append(item)
//
//			let newnode		=	FileNodeModel()
//			newnode.owner		=	self
//			newnode.supernode	=	node
//			newnode._path.value	=	path
//			node._subnodes.append(newnode)
//
//			assert(_checkFileTreeAndWorkspaceItemTreeStructuralEquality())
//			return
//		}
//		else {
//			fatalError("There's no container node at path `\(containerPath)`. Cannot insert a new node at path `\(path)`.")
//		}
//	}
//	private func _deleteNodeAtPath(path: WorkspaceItemPath) {
//		Debug.assertMainThread()
//		assert(path != WorkspaceItemPath.root)
//
//		if let node = _findNodeForPath(path) {
//			if let supernode = node.supernode {
//				if let idx = supernode.subnodes.array.indexOfValueByReferentialIdentity(node) {
//					supernode._subnodes.delete(idx...idx)
//					let	item	=	_dataTree.root.findNodeForPath(path)!
//					item.supernode!.subnodes.remove(item)
//
//					assert(_checkFileTreeAndWorkspaceItemTreeStructuralEquality())
//					return
//				}
//			}
//		}
//		assert(false)
//	}


	///

//	private func _findNodeForPath(path: WorkspaceItemPath) -> FileNodeModel? {
//		Debug.assertMainThread()
//		return	_root.value?._findNodeForPath(path)
//	}

	///

	private func _checkFileTreeAndWorkspaceItemTreeStructuralEquality() -> Bool {
		Debug.assertMainThread()
		if let rootNodeModel = _rootNodeModel {
			return	_checkFileTreeAndWorkspaceItemTreeStructuralEqualityAtNode(rootNodeModel, path: WorkspaceItemPath.root)
		}
		else {
			return	_dataTree!.root!.count == 0
		}
	}
	private func _checkFileTreeAndWorkspaceItemTreeStructuralEqualityAtNode(node: FileNodeModel, path: WorkspaceItemPath) -> Bool {
		Debug.assertMainThread()
		guard _dataTree!.root!.searchNodeForPath(path) != nil else {
			assert(false)
			return	false
		}

		guard node.resolvePath() == path else {
			assert(false)
			return	false
		}

		///

		let subnodes	=	node.subnodes
		let subpaths	=	_dataTree!.root!.searchNodeForPath(path)!.subnodes.map({ $0.resolvePath() })

		guard subnodes.count == subpaths.count else {
			assert(false)
			return	false
		}

		for i in subnodes.wholeRange {
			let subnode	=	subnodes[i]
			let subpath	=	subpaths[i]

			guard _dataTree!.root!.searchNodeForPath(subpath.pathByDeletingLastComponent()) != nil else {
				assert(false)
				return	false
			}

			let	ok	=	_checkFileTreeAndWorkspaceItemTreeStructuralEqualityAtNode(subnode, path: subpath)

			guard ok else {
				assert(false)
				return	false
			}
		}

		return true
	}
}


//
//public protocol FileTreeModelDelegate {
//	func willInsertNodesAtPaths()
//	func didInsertNodesAtPaths()
//	func willUpdateNodesAtPaths()
//	func didUpdateNodesAtPaths()
//	func willDeleteNodesAtPaths()
//	func didDeleteNodesAtPaths()
//}
//

























































/// NO LAZY LOADING RIGHT NOW. UNIMPLEMENTED YET.
///
/// You must manually `loadSubnodes` subnodes before accesing `subnode` property.
/// Also you must manually call `unloadSubodes` when you don't use them anymore
/// to save memory.
///
public final class FileNodeModel: ModelSubnode<FileTreeModel> {

	public convenience init(name: String, isGroup: Bool) {
		self.init(dataNode: WorkspaceItemNode(name: name, isGroup: isGroup))
	}
	private init(dataNode: WorkspaceItemNode) {
		_dataNode	=	dataNode
		super.init()

		for dataSubnode in dataNode.subnodes {
			let	modelSubnode	=	FileNodeModel(dataNode: dataSubnode)
			modelSubnode.supernode	=	self
			// Assumes appropriate file-system node already exists.
			_subnodes.append(modelSubnode)
		}
	}
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
		for subnode in _subnodes {
			subnode.owner	=	owner
		}
	}
	override func willLeaveModelRoot() {
		for subnode in _subnodes {
			subnode.owner	=	nil
		}
		super.willLeaveModelRoot()
	}

	///

	public var name: String {
		get {
			return	_dataNode.name
		}
	}

	/// Because Swift does not support `throws` on stters yet...
	///
	/// If file-system node renaming fails, an error will be thrown and nothing will be
	/// changed on data model. (transactional) File-system state is always unknown.
	/// 
	/// `WillChangeName` and `DidChangeName` events will be sent if data model has been mutated
	/// regardless of file-system state.
	public func ADHOC_setName(newValue: String) throws {
		let	oldValue	=	_dataNode.name
		let	fromFileURL	=	_dataNode.resolvePath().absoluteFileURL(`for`: tree.workspace)
		let	toFileURL	=	fromFileURL.URLByDeletingLastPathComponent!.URLByAppendingPathComponent(newValue)
		do {
			try	Platform.thePlatform.fileSystem.moveFile(fromURL: fromFileURL, toURL: toFileURL)

			FileNodeModel.Event.WillChangeName(old: oldValue, new: newValue).broadcastWithSender(self)
			_dataNode.name		=	newValue
			FileNodeModel.Event.DidChangeName(old: oldValue, new: newValue).broadcastWithSender(self)
		}
		catch let error {
			// Rollback mutation on any error.
			throw	error
		}
	}

	public var comment: String? {
		get {
			return	_dataNode.comment
		}
		set {
			let	oldValue	=	_dataNode.comment

			FileNodeModel.Event.WillChangeComment(old: oldValue, new: newValue).broadcastWithSender(self)
			_dataNode.comment	=	newValue
			FileNodeModel.Event.DidChangeComment(old: oldValue, new: newValue).broadcastWithSender(self)
		}
	}

	public var subnodes: FileSubnodeModelList {
		get {
			return	FileSubnodeModelList(hostNode: self)
		}
	}
	public func resolvePath() -> WorkspaceItemPath {
		return	_dataNode.resolvePath()
	}

	public func search(path: WorkspaceItemPath) -> FileNodeModel? {
		if path.parts.count == 0 {
			return	self
		}
		for subnode in _subnodes {
			if path.parts[0] == subnode.name {
				if let discover = subnode.search(path.pathByDeletingLastComponent()) {
					return	discover
				}
			}
		}
		return	nil
	}

	///

	private let	_dataNode	:	WorkspaceItemNode
	private var	_subnodes	=	[FileNodeModel]()
	internal var	_isInstalled	=	false
}

public struct FileSubnodeModelList: SequenceType, Indexable {
	private init(hostNode: FileNodeModel) {
		self.hostNode	=	hostNode
	}

	///

	public var count: Int {
		get {
			return	hostNode._subnodes.count
		}
	}
	public var startIndex: Int {
		get {
			return	hostNode._subnodes.startIndex
		}
	}
	public var endIndex: Int {
		get {
			return	hostNode._subnodes.endIndex
		}
	}
	public func append(node: FileNodeModel) throws {
		try insert(node, at: count)
	}
	/// Operation succeeds regardless of underlying file-system node
	/// to be created or not.
	/// `DidInsert` notification will be sent triggered on error.
	public func insert(node: FileNodeModel, at index: Int) throws {
		// Mutation must be transactional. Which means rollback on error.
		// Anyway we don't count alien state like file-system. Transactional
		// mutation is limited to in-process memory state.

		precondition(node.subnodes.count == 0, "Currently, we don't support recursive insertion of file node. You can make only empty folder or file entry.")

		let	hostFileSystemNodeURL	=	hostNode.resolvePath().absoluteFileURL(`for`: hostNode.tree.workspace)
		let	destFileSystemNodeURL	=	hostFileSystemNodeURL.URLByAppendingPathComponent(node.name)
		if hostNode._dataNode.isGroup {
			try Platform.thePlatform.fileSystem.createDirectoryAtURL(destFileSystemNodeURL, recursively: true)
		}
		else {
			try Platform.thePlatform.fileSystem.createFileAtURL(destFileSystemNodeURL)
		}

		assert(hostNode._subnodes.indexOfValueByReferentialIdentity(node) == nil)
		try WorkspaceItemNode.validateName(node._dataNode.name, withSupernode: hostNode._dataNode)()

		hostNode._dataNode.subnodes.insert(node._dataNode, atIndex: index)
		hostNode._subnodes.insert(node, atIndex: index)

		assert(node.owner == nil, "Supplied node `\(node)` must be a detached node.")
		assert(node.supernode == nil, "Supplied node `\(node)` must be a detached node.")
		node.owner	=	hostNode.owner
		node.supernode	=	hostNode

		FileNodeModel.Event.DidInsertSubnode(subnode: node, index: index).broadcastWithSender(hostNode)
	}
	public func remove(node: FileNodeModel) throws {
		guard let idx = hostNode._subnodes.indexOfValueByReferentialIdentity(node) else {
			fatalError("Supplied node `\(node)` could not be found in this subnode list.")
		}
		try removeAtIndex(idx)
	}
	/// `WillDelete` notification will be sent triggered on error.
	public func removeAtIndex(index: Int) throws {
		// Mutation must be transactional. Which means rollback on error.
		// Anyway we don't count alien state like file-system. Transactional
		// mutation is limited to in-process memory state.

		let	destFileSystemNodeURL	=	hostNode._subnodes[index].resolvePath().absoluteFileURL(`for`: hostNode.tree.workspace)
		if hostNode._dataNode.isGroup {
			try Platform.thePlatform.fileSystem.deleteDirectoryAtURL(destFileSystemNodeURL, recursively: true)
		}
		else {
			try Platform.thePlatform.fileSystem.deleteFileAtURL(destFileSystemNodeURL)
		}

		hostNode._dataNode.subnodes.removeAtIndex(index)

		assert(hostNode._subnodes[index].owner === hostNode)
		FileNodeModel.Event.WillDeleteSubnode(subnode: hostNode._subnodes[index], index: index).broadcastWithSender(hostNode)

		let	removedNode	=	hostNode._subnodes.removeAtIndex(index)
		removedNode.supernode	=	nil
		removedNode.owner	=	nil
	}

	public func generate() -> Array<FileNodeModel>.Generator {
		return	hostNode._subnodes.generate()
	}
	public subscript(index: Int) -> FileNodeModel {
		get {
			return	hostNode._subnodes[index]
		}
	}

	///

	private unowned let	hostNode	:	FileNodeModel
}



















///// Can be executed on any thread.
//private func _rebuildFileNodeModelTree(modelTree: FileTreeModel, _ snapshotTree: WorkspaceItemTree) -> FileNodeModel {
//	return	_rebuildFileNodeModelSubtree(modelTree, snapshotTree, `for`: WorkspaceItemPath.root)
//}
///// Can be executed on any thread.
/////
///// - Parameters:
/////	- tree
/////		This object will not be accessed at all, and only its pointer will be used to each subnodes.
/////
//private func _rebuildFileNodeModelSubtree(modelTree: FileTreeModel, _ snapshotTree: WorkspaceItemTree, `for` path: WorkspaceItemPath) -> FileNodeModel {
//	let	node		=	FileNodeModel()
//	node._path.value	=	path
//	node._comment.value	=	snapshotTree.root.findNodeForPath(path)!.comment
//	node.owner		=	modelTree
//
//	let	subpaths	=	snapshotTree.root!.findNodeForPath(path)!.subnodes.map({ $0.resolvePath() })
//	var	subnodes	=	[FileNodeModel]()
//	subnodes.reserveCapacity(subpaths.count)
//	for subpath in subpaths {
//		let	subnode		=	_rebuildFileNodeModelSubtree(modelTree, snapshotTree, `for`: subpath)
//		subnode.supernode	=	node
//		subnodes.append(subnode)
//	}
//	node._subnodes.extend(subnodes)
//	return	node
//}






//internal func TEST_STUB_rebuildFileNodeModelTree(modelTree: FileTreeModel, _ snapshotTree: WorkspaceItemTree) -> FileNodeModel {
//	return	_rebuildFileNodeModelTree(modelTree, snapshotTree)
//}
//extension FileTreeModel {
//	internal func TEST_STUB_restoreSnapshotFromURL(u: NSURL) {
//		_restoreSnapshotFromURL(u) {}
//	}
//}














