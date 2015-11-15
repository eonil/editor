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
public class FileTreeModel: ModelSubnode<WorkspaceModel>, BroadcastingModelType {

	struct Error: ErrorType {
		enum Code {
			case BadName
			case CannotRestoreBecuaseCannotReadWorkspaceFileListAsUTF8String
		}
		
		var code	:	Code
		var message	:	String
	}








	///

	override init() {
		super.init()
	}
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







	///

	public let event	=	EventMulticast<Event>()








	///

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
		_install()
		_assertFileTreeIntegrity(self)
	}
	override func willLeaveModelRoot() {
		_assertFileTreeIntegrity(self)
		_deinstall()
		super.willLeaveModelRoot()
	}









	///

	/// Can be `nil` for any errors.
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













	///

	/// A new file node will be created regardless of file-system operation failure.
	/// Anyway, such failure will throw an error at the end of process.
	/// Name will be chosen automatically.
	public func newFileInNode(parentNode: FileNodeModel, atIndex: Int) throws {
		defer {
			_assertFileTreeIntegrity(self)
			Event.DidChangeTreeTopology.dualcastAsNotificationWithSender(self)
		}
		for i in 0..<100 {
			let	name	=	"file\(i).rs"
			do {
				try WorkspaceItemNode.validateName(name, withSupernode: parentNode._dataNode)()
				let	node	=	FileNodeModel(name: name, isGroup: false)
				parentNode.subnodes.insert(node, at: atIndex)
				let	u	=	node.resolvePath().absoluteFileURL(`for`: workspace)
				let	_	=	try? Platform.thePlatform.fileSystem.createFileAtURL(u)
				return
			}
			catch {
				continue
			}
		}
		throw	Error(code: FileTreeModel.Error.Code.BadName, message: "Can't select a name for new file.")
	}

	/// A new file node will be created regardless of file-system operation failure.
	/// Anyway, such failure will throw an error at the end of process.
	/// Name will be chosen automatically.
	public func newFolderInNode(parentNode: FileNodeModel, atIndex: Int) throws {
		defer {
			Event.DidChangeTreeTopology.dualcastAsNotificationWithSender(self)
			_assertFileTreeIntegrity(self)
		}
		for i in 0..<100 {
			let	name	=	"folder\(i)"
			do {
				try WorkspaceItemNode.validateName(name, withSupernode: parentNode._dataNode)()
				let	node	=	FileNodeModel(name: name, isGroup: true)
				parentNode.subnodes.insert(node, at: atIndex)
				let	u	=	node.resolvePath().absoluteFileURL(`for`: workspace)
				let	_	=	try? Platform.thePlatform.fileSystem.createDirectoryAtURL(u, recursively: true)
				return
			}
			catch {
				continue
			}
		}
		throw	Error(code: FileTreeModel.Error.Code.BadName, message: "Can't select a name for new file.")
	}

	/// File nodes for all paths will be created regardless of file-system operation
	/// failure.
	/// Anyway, such failure will throw an error at the end of process.
	public func copyFilesAtPaths(paths: [String], intoParentNode: FileNodeModel, atIndex: Int) throws {
		markUnimplemented()
	}

	/// Node movement will always be done regardless of file-system operation failure.
	/// Anyway, such failure will throw an error at the end of process.
	public func moveNodes(originalNodes: [FileNodeModel], intoParentNode: FileNodeModel, atIndex: Int) throws {
		markUnimplemented()
	}

	/// All file nodes will be deleted regardless of file-system operation failure.
	/// Anyway, such failure will throw an error at the end of process.
	/// This method automatically handles nested nodes, so you don't need to deduplicate
	/// nested nodes.
	public func deleteNodes(nodes: [FileNodeModel]) throws {
		defer {
			Event.DidChangeTreeTopology.dualcastAsNotificationWithSender(self)
			_assertFileTreeIntegrity(self)
		}



		// Collect file URLs.
		var	discoveredFileURLs	=	Set<NSURL>()
		for n in nodes {
			let	u	=	n.resolvePath().absoluteFileURL(`for`: workspace)
			discoveredFileURLs.insert(u)
		}

		// Process in-memory states.
		for n in nodes {
			guard n.owner != nil else {
				// Already removed from tree. No need to do it.
				// And removing it again very likely to trigger some assertions.
				continue
			}
			assert(n.supernode != nil)
			n.supernode!.subnodes.remove(n)
		}

		// Process remote file-system.
		func isOrderedBefore(a: NSURL, b: NSURL) -> Bool {
			// Expects lexicographical sort.
			// Or length based sort at least.
			return	a.absoluteString < b.absoluteString
		}

		print(discoveredFileURLs)
		for u in discoveredFileURLs.sort(isOrderedBefore).reverse() {
			// TODO: Polish this.
			try Platform.thePlatform.fileSystem.trashFileSystemNodesAtURL(u)
		}
	}










	///

	private var	_dataTree	:	WorkspaceItemTree?
	private var	_rootNodeModel	:	FileNodeModel?
	private var	_isInstalled	=	false
	private let	_onDidChange	=	MutableValueStorage<()>(())

	///

	private func _install() {
		Debug.assertMainThread()
		assert(_isInstalled == false)
		_isInstalled		=	true
	}
	private func _deinstall() {
		Debug.assertMainThread()
//		if _rootNodeModel != nil {
//			_deinstallModelRoot()
//		}
		assert(_isInstalled == true)
		_isInstalled		=	false
	}

	private func _installModelRoot() {
		assert(_rootNodeModel == nil)
		assert(_dataTree != nil)
		assert(_dataTree!.root != nil)
		_rootNodeModel		=	FileNodeModel(dataNode: _dataTree!.root!)
		_rootNodeModel!.owner	=	self
		FileTreeModel.Event.DidCreateRoot(root: _rootNodeModel!).dualcastAsNotificationWithSender(self)
	}
	private func _deinstallModelRoot() {
		FileTreeModel.Event.WillDeleteRoot(root: _rootNodeModel!).dualcastAsNotificationWithSender(self)
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
		if _rootNodeModel != nil {
			_deinstallModelRoot()
		}
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
		assert(workspace.location != nil)
		return	workspace.location!.URLByAppendingPathComponent("Workspace.EditorFileList")
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

























































/// Represents a file node in file tree.
///
/// This is essentially just a workspace item node with performing
/// expected file-system operations.
/// Though this `throws` on any file-system operation failure, 
/// file-system state will become undefined state after failture.
/// Also, as file-system is a remote system, it's impossible to
/// synchronize file-system operations. Always prepare for failure.
///
public final class FileNodeModel: ModelSubnode<FileTreeModel>, BroadcastingModelType {

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

	public let event = EventMulticast<Event>()

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
			assert(subnode.owner === nil)
			subnode.owner	=	owner
		}
	}
	override func willLeaveModelRoot() {
		for subnode in _subnodes {
			assert(subnode.owner !== nil)
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
	public var isGroup: Bool {
		get {
			return	_dataNode.isGroup
		}
	}


	/// Because Swift does not support `throws` on setters yet...
	///
	/// If file-system node renaming fails, an error will be thrown and nothing will be
	/// changed on data model. (transactional) File-system state is always unknown.
	/// 
	/// `WillChangeName` and `DidChangeName` events will be sent if data model has been mutated
	/// regardless of file-system state.
	public func ADHOC_setName(newValue: String) throws {
//		let	oldValue	=	_dataNode.name
		let	fromFileURL	=	_dataNode.resolvePath().absoluteFileURL(`for`: tree.workspace)
		let	toFileURL	=	fromFileURL.URLByDeletingLastPathComponent!.URLByAppendingPathComponent(newValue)
		do {
			try	Platform.thePlatform.fileSystem.moveFile(fromURL: fromFileURL, toURL: toFileURL)

//			FileNodeModel.Event.WillChangeName(old: oldValue, new: newValue).dualcastAsNotificationWithSender(self)
			_dataNode.name		=	newValue
//			FileNodeModel.Event.DidChangeName(old: oldValue, new: newValue).dualcastAsNotificationWithSender(self)
			FileTreeModel.Event.DidChangeNodeAttribute.dualcastAsNotificationWithSender(tree)
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
//			let	oldValue	=	_dataNode.comment

//			FileNodeModel.Event.WillChangeComment(old: oldValue, new: newValue).dualcastAsNotificationWithSender(self)
			_dataNode.comment	=	newValue
//			FileNodeModel.Event.DidChangeComment(old: oldValue, new: newValue).dualcastAsNotificationWithSender(self)
			FileTreeModel.Event.DidChangeNodeAttribute.dualcastAsNotificationWithSender(tree)
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






	///

	internal func append(node: FileNodeModel) {
		insert(node, at: count)
	}

	/// `DidInsert` notification will be sent triggered on error.
	/// Invalid name will crash the program.
	internal func insert(node: FileNodeModel, at index: Int) {
		precondition(node.subnodes.count == 0, "Currently, we don't support recursive insertion of file node. You can make only empty folder or file entry.")

		assert(hostNode._subnodes.indexOfValueByReferentialIdentity(node) == nil)
		try! WorkspaceItemNode.validateName(node._dataNode.name, withSupernode: hostNode._dataNode)()

		hostNode._dataNode.subnodes.insert(node._dataNode, atIndex: index)
		hostNode._subnodes.insert(node, atIndex: index)

		assert(node.owner == nil, "Supplied node `\(node)` must be a detached node.")
		assert(node.supernode == nil, "Supplied node `\(node)` must be a detached node.")
		node.owner	=	hostNode.owner
		node.supernode	=	hostNode

//		FileNodeModel.Event.DidInsertSubnode(subnode: node, index: index).dualcastAsNotificationWithSender(hostNode)
		FileTreeModel.Event.DidChangeTreeTopology.dualcastAsNotificationWithSender(hostNode.tree)
	}
	internal func remove(node: FileNodeModel) {
		guard let idx = hostNode._subnodes.indexOfValueByReferentialIdentity(node) else {
			fatalError("Supplied node `\(node)` could not be found in this subnode list.")
		}
		removeAtIndex(idx)
	}

	/// `WillDelete` notification will be sent triggered on error.
	internal func removeAtIndex(index: Int) {
		hostNode._dataNode.subnodes.removeAtIndex(index)

		assert(hostNode._subnodes[index].supernode === hostNode)
		assert(hostNode._subnodes[index].owner === hostNode.owner)
//		FileNodeModel.Event.WillDeleteSubnode(subnode: hostNode._subnodes[index], index: index).dualcastAsNotificationWithSender(hostNode)

		let	removedNode	=	hostNode._subnodes.removeAtIndex(index)
		removedNode.supernode	=	nil
		removedNode.owner	=	nil

		FileTreeModel.Event.DidChangeTreeTopology.dualcastAsNotificationWithSender(hostNode.tree)
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


























private func _assertFileTreeIntegrity(tree: FileTreeModel) {
	if let root = tree.root {
		_assertFileNodeIntegrity(root)
	}
}
private func _assertFileNodeIntegrity(node: FileNodeModel) {
	assert(node.owner != nil)
	for sn in node.subnodes {
		_assertFileNodeIntegrity(sn)
	}
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














