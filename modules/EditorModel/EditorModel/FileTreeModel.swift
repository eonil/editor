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
	}
	override func willLeaveModelRoot() {
		_deinstall()
		super.willLeaveModelRoot()
	}









	///

	/// Can be `nil` for any errors.
	public var tree: WorkspaceItemTree? {
		get {
			return	_dataTree
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

	/// A new file node will be created regardless of file-system operation failure.
	/// Anyway, such failure will throw an error at the end of process.
	/// Name will be chosen automatically.
	public func newFileInNode(parentNode: WorkspaceItemNode, atIndex: Int) throws {
		defer {
			Event.DidChangeTreeTopology.dualcastAsNotificationWithSender(self)
		}
		for i in 0..<100 {
			let	name	=	"file\(i).rs"
			do {
				try WorkspaceItemNode.validateName(name, withSupernode: parentNode)()
				let	node	=	WorkspaceItemNode(name: name, isGroup: false)
				parentNode.subnodes.insert(node, atIndex: atIndex)
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
	public func newFolderInNode(parentNode: WorkspaceItemNode, atIndex: Int) throws {
		defer {
			Event.DidChangeTreeTopology.dualcastAsNotificationWithSender(self)
		}
		for i in 0..<100 {
			let	name	=	"folder\(i)"
			do {
				try WorkspaceItemNode.validateName(name, withSupernode: parentNode)()
				let	node	=	WorkspaceItemNode(name: name, isGroup: true)
				parentNode.subnodes.insert(node, atIndex: atIndex)
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
	public func copyFilesAtPaths(paths: [String], intoParentNode: WorkspaceItemNode, atIndex: Int) throws {
		markUnimplemented()
	}

	/// Node movement will always be done regardless of file-system operation failure.
	/// Anyway, such failure will throw an error at the end of process.
	public func moveNodes(originalNodes: [WorkspaceItemNode], intoParentNode: WorkspaceItemNode, atIndex: Int) throws {
		markUnimplemented()
	}

	public func renameNode(node: WorkspaceItemNode, toName: String) throws {
		guard toName != node.name else {
			return	
		}
		defer {
			Event.DidChangeNodeAttribute.dualcastAsNotificationWithSender(self)
		}

		let	u1	=	node.resolvePath().absoluteFileURL(`for`: workspace)
		node.name	=	toName
		let	u2	=	node.resolvePath().absoluteFileURL(`for`: workspace)

		try Platform.thePlatform.fileSystem.moveFile(fromURL: u1, toURL: u2)
	}

	/// All file nodes will be deleted regardless of file-system operation failure.
	/// Anyway, such failure will throw an error at the end of process.
	/// This method automatically handles nested nodes, so you don't need to deduplicate
	/// nested nodes.
	public func deleteNodes(nodes: [WorkspaceItemNode]) throws {
		defer {
			Event.DidChangeTreeTopology.dualcastAsNotificationWithSender(self)
		}



		// Collect file URLs.
		var	discoveredFileURLs	=	Set<NSURL>()
		for n in nodes {
			let	u	=	n.resolvePath().absoluteFileURL(`for`: workspace)
			discoveredFileURLs.insert(u)
		}

		// Process in-memory states.
		for n in nodes {
//			guard n.owner != nil else {
//				// Already removed from tree. No need to do it.
//				// And removing it again very likely to trigger some assertions.
//				continue
//			}
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
		assert(_dataTree != nil)
		assert(_dataTree!.root != nil)
		FileTreeModel.Event.DidChangeTreeTopology.dualcastAsNotificationWithSender(self)
	}
	private func _deinstallModelRoot() {
		assert(_dataTree != nil)
		assert(_dataTree!.root != nil)
		FileTreeModel.Event.DidChangeTreeTopology.dualcastAsNotificationWithSender(self)
	}






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














