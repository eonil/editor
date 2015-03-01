//
//  WorkspaceRepository.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/21.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation











///	**Registered entries.**
///
///
///	DESIGN NOTES
///	------------
///	Workspace represents abstracted tree of nodes. These node stores minimal states that
///	are always valid regardless of environments. (such as file location)
///
///	For example, workspace node stores only relative meta "name", and does not store any 
///	full-path or URL. Even workspace root does not contain its location. Users are 
///	responsible to resolve actualy location of each node.
///	
///	"name" of a node is metadata. That means the name is a relative path to find the node
///	from the parent node.
///
///
///
///	USER GUIDE
///	----------
///	A workspace will always have a root node.
///	Root node cannot be removed. If file inode for the root node invalidated,
///	the project should be disappeared ASAP before performing any further operation.
///
///	Root node also have a name, but it's not very important.
///
///	This object does not handle any file-related operations. You need to handle them
///	yourself at another layer.
public class WorkspaceRepository {
	public weak var					delegate:WorkspaceRepositoryDelegate?		=	nil
	
	public private(set) lazy var	root:			WorkspaceNode						=	WorkspaceNode(repository: self, name: "" , kind: WorkspaceNodeKind.Folder)
//	public private(set) var			index:			[WorkspacePath:WorkspaceNode]		=	[:]
	
	///	:param:	name		Name of repository. Name of root node will also be set to this.
	public init(name:String) {
		root.name	=	name
	}
}

///	`~Will~` and `~Did~` will always be sent in pair and sequently and immediately.
///	If the events are not paired, it's a logic bug.
///	You can access proper old and new location at each events.
///
///	Rename and move are fundamentally same operation, but needs different handling of UI.
///	It has been split for convenience of UI handling.
public protocol WorkspaceRepositoryDelegate: class {
	func workspaceRepositoryWillCreateNode()
	func workspaceRepositoryDidCreateNode(node:WorkspaceNode)
	func workspaceRepositoryWillRenameNode(node:WorkspaceNode)
	func workspaceRepositoryDidRenameNode(node:WorkspaceNode)
	func workspaceRepositoryWillMoveNode(node:WorkspaceNode)
	func workspaceRepositoryDidMoveNode(node:WorkspaceNode)
	func workspaceRepositoryWillDeleteNode(node:WorkspaceNode)
	func workspaceRepositoryDidDeleteNode()
	
	func workspaceRepositoryDidOpenSubworkspaceAtNode(node:WorkspaceNode)
	func workspaceRepositoryWillCloseSubworkspaceAtNode(node:WorkspaceNode)
}









































///	MARK:
///	MARK:	WorkspaceNode







///	Project node build a tree structure linked bidirectionally.
///
///	This class has these assumptions.
///
///	-	Small number of child nodes.
///
///
///	Design Note
///	-----------
///	`name` of a node is not a part of node state. It is a metadata that represents
///	relation from parent node.
///	I tried to detach this metadata from node itself, but it only brings extra complexity
///	with no significant benefit. Just take care on this concept when coding.
///
///
///
///	Lifecycle Consideration
///	-----------------------
///	You cannot re-use once deleted node object. Prohibited by design.
///	Once you deleted (detached) a node from repository tree, just destroy it ASAP.
///	Performing any operation on detached node will cause program crash.
///
///
///
///	Subworkspaces
///	-------------
///	If a workspace-node is representing a subworkspace, then it can load the subworkspace into memory.
///	Anyway moving nodes 
///
public final class WorkspaceNode {
	public private(set) unowned var repository	:	WorkspaceRepository			///<	Set to `weak` to avoid cycle.
	public private(set) weak var	parent		:	WorkspaceNode?				///<	Set to `weak` to avoid cycle.
	public private(set) var			children	:	[WorkspaceNode]
	
	public private(set) var			name		:	String						///<	Metadata.
	public var						comment		:	String?
	
	public private(set) var			kind		:	WorkspaceNodeKind
	public private(set) var			flags		:	WorkspaceNodeFlags
	
	///	If a subworkspace for this node is loaded, it will be retained by this property.
	public private(set) var			subworkspace:	WorkspaceRepository?
	
	////
	
	private init(repository:WorkspaceRepository, name:String, kind:WorkspaceNodeKind) {
		self.repository	=	repository
		self.parent		=	nil
		self.children	=	[]

		self.name		=	name
		self.comment	=	nil
		self.kind		=	kind
		self.flags		=	WorkspaceNodeFlags()
	}
}

public extension WorkspaceNode {
	public func indexOfNodeForName(name:String) -> Int? {
		for i in 0..<children.count {
			let	n	=	children[i]
			if n.name == name {
				return	i
			}
		}
		return	nil
	}
	public func indexOfNode(node:WorkspaceNode) -> Int? {
		for i in 0..<children.count {
			let	n	=	children[i]
			if n === node {
				return	i
			}
		}
		return	nil
	}
	public func nodeForName(name:String) -> WorkspaceNode? {
		if let idx = indexOfNodeForName(name) {
			return	children[idx]
		}
		return	nil
	}
}

///	Fundamental Mutators.
public extension WorkspaceNode {
	public func createChildNodeAtIndex(index:Int, asKind:WorkspaceNodeKind, withName:String) -> WorkspaceNode {
		precondition(self.kind == WorkspaceNodeKind.Folder, "You can create subnode only in a `Folder` kind node.")
		precondition(self.nodeForName(withName) == nil, "The name already been taken by one of child node.")
		assert(index >= 0)
		assert(index <= self.children.count)
		assertAttached()
		
		repository.delegate?.workspaceRepositoryWillCreateNode()
		
		let	n	=	WorkspaceNode(repository: self.repository, name: withName, kind: asKind)
		n.parent	=	self
		children.insert(n, atIndex: index)
		
		repository.delegate?.workspaceRepositoryDidCreateNode(n)
		return	n
	}
	public func deleteChildNodeAtIndex(index:Int) {
		assertAttached()
		
		let	n		=	children[index]
		repository.delegate?.workspaceRepositoryWillDeleteNode(n)
		
		n.parent	=	nil
		children.removeAtIndex(index)
		
		repository.delegate?.workspaceRepositoryDidDeleteNode()
	}
	public func rename(name:String) {
		precondition(parent == nil || parent!.nodeForName(name) === self || parent!.nodeForName(name) === nil, "The name already been taken by a sibling. Bad name.")
		assertAttached()
		
		//	Cancels renaming if nothing's been changed.
		if self.name == name {
			return
		}
		
		repository.delegate?.workspaceRepositoryWillRenameNode(self)
		
		self.name	=	name
		
		repository.delegate?.workspaceRepositoryDidRenameNode(self)
	}

	///	Moves a node into a new location.
	///	Node object will be moved without recreating a new instance.
	///	If you're moving a child node into another parent node, it must specify
	///	non-existing name in the children of the parent node.
	///	If you're moving a child node within same parent node, using of same name
	///	is allowed because it will be removed first and to perform index 
	///	moving.
	public func moveChildNode(atOldIndex:Int, toNewParentNode:WorkspaceNode, atNewIndex:Int, withNewName:String) {
		precondition(self === toNewParentNode || toNewParentNode.nodeForName(withNewName) == nil, "The name already been take by a sibling in destination parent node.")
		assert(atNewIndex >= 0)
		assert(atNewIndex <= toNewParentNode.children.count)
		assertAttached()
		
		////
		
		let	n		=	children[atOldIndex]
		repository.delegate?.workspaceRepositoryWillMoveNode(n)
		
		n.parent	=	nil
		children.removeAtIndex(atOldIndex)
		
		////
		
		n.name		=	withNewName
		n.parent	=	toNewParentNode
		toNewParentNode.children.insert(n, atIndex: atNewIndex)
		let	newPath	=	n.path
		
		repository.delegate?.workspaceRepositoryDidMoveNode(n)
	}
}

///	Extension Mutators
public extension WorkspaceNode {
	public func createChildNodeAtLastAsKind(kind:WorkspaceNodeKind, withName:String) -> WorkspaceNode {
		return	createChildNodeAtIndex(children.count, asKind: kind, withName: withName)
	}
	public func deleteChildNodeForName(name:String) {
		assertAttached()
		
		if let idx = indexOfNodeForName(name) {
			deleteChildNodeAtIndex(idx)
		}
		fatalError("Cannot find a child node for the name.")
	}
	public func deleteAllChildNodes() {
		while children.count > 0 {
			self.deleteChildNodeAtIndex(children.count-1)
		}
	}
	public func delete() {
		precondition(isRoot == false, "Root node cannot be moved.")
		assertAttached()
	
		if let idx = parent!.indexOfNode(self) {
			parent!.deleteChildNodeAtIndex(idx)
			return
		}
		fatalError("This node cannot be found from parent's children list. This is a serious logic bug, and must be patched.")
	}
	public func moveChildNode(atOldIndex:Int, toNewParentNode:WorkspaceNode, atNewIndex:Int) {
		assertAttached()
		
		let	n	=	self.children[atOldIndex]
		self.moveChildNode(atOldIndex, toNewParentNode: toNewParentNode, atNewIndex: atNewIndex, withNewName: n.name)
	}
	public func move(#toParentNode:WorkspaceNode, atIndex:Int, asName:String) {
		precondition(isRoot == false, "Root node cannot be moved.")
		assertAttached()
		
		if let idx = parent!.indexOfNode(self) {
			parent!.moveChildNode(idx, toNewParentNode: toParentNode, atNewIndex: atIndex, withNewName: asName)
			return
		}
		fatalError("This node cannot be found from parent's children list. This is a serious logic bug, and must be patched.")
	}
}

public extension WorkspaceNode {
	public var isSubworkspace:Bool {
		get {
			//	TODO:	Implement this...
			return	false
		}
	}
	public func openSubworkspace() {
		precondition(self.isSubworkspace, "This node must be marked as a `subworkspace`.")
		
		subworkspace	=	WorkspaceRepository(name: self.name)
		
		repository.delegate?.workspaceRepositoryDidOpenSubworkspaceAtNode(self)
	}
	public func closeSubworkspace() {
		precondition(self.isSubworkspace, "This node must be marked as a `subworkspace`.")
		
		repository.delegate?.workspaceRepositoryWillCloseSubworkspaceAtNode(self)
		
		subworkspace	=	nil
	}
}

extension WorkspaceNode {
	var isRoot:Bool {
		get {
			return	repository.root === self
		}
	}
	var isAttached:Bool {
		get {
			if parent == nil {
				return	isRoot
			} else {
				return	parent!.isAttached
			}
		}
	}
	func assertNonRoot(@autoclosure message:()->String = "This node must be a root node of a repository to perform the operation.") {
		assert(isRoot, message())
	}
	func assertAttached(@autoclosure message:()->String = "This node must be attached to a root node of a repository to perform the operation.") {
		assert(isAttached, message())
	}
}

public extension WorkspaceNode {
	func setExpanded() {
		assert(self.kind == WorkspaceNodeKind.Folder)
		self.flags.isOpenFolder	=	true
	}
	func setCollapsed() {
		assert(self.kind == WorkspaceNodeKind.Folder)
		self.flags.isOpenFolder	=	false
	}
}







public enum WorkspaceNodeKind {
	case Folder
	case File
}

public struct WorkspaceNodeFlags {
//	///	This node does not speficy subtree nodes. Subtree must be resolve at runtime when needed.
//	///	Editor will monitor this node at file-system and will refresh GUI display automatically for any changes.
//	///	This node should have no children. Having any child node will be treated as a serious logic bug.
//	///	Strict programs should crash on lazy-subtree with any extra child, and fault-tolerent program
//	///	should erase any child node.
//	var	lazySubtree			=	false
//	
//	///	This node is a `Folder` node that represents a subproject.
//	///	Subworkspace also mube be `lazySubtree`.
//	///	A root node SHOULD NOT set this to `true`.
//	var	subworkspace:Bool
	
	///	Marks whether this node is open or not.
	var	isOpenFolder		=	false
}







































































///	MARK:
///	MARK:	WorkspacePath










public extension WorkspaceNode {
	///	Produces a (full) path to this node from repository root.
	///	A path is always full relative path from repository root.
	///	Name of root node will not be added.
	public var path:WorkspacePath {
		get {
			if isRoot {
				return	WorkspacePath(components: [])
			} else {
				return	parent!.path.childPathWithComponent(self.name)
			}
		}
	}
}
















































































//public struct WorkspaceNodeLink {
//	var	relation:WorkspaceNodeRelation
//	var	node:WorkspaceNode
//}
//
//public enum WorkspaceNodeRelation {
//	case Parent
//	case Child(name:String)
//}
//
//public extension WorkspaceNodeRelation {
//	var isParent:Bool {
//		get {
//			switch self {
//			case .Parent:			return	true
//			default:				return	false
//			}
//		}
//	}
//	var isChild:Bool {
//		get {
//			switch self {
//			case .Child(let _):		return	true
//			default:				return	false
//			}
//		}
//	}
//	var childName:String? {
//		get {
//			switch self {
//			case .Child(let n):		return	n
//			default:				return	nil
//			}
//		}
//	}
//}
//
/////	Represents mapping of child nodes using indexes and names.
/////	This is read-only collection.
/////
/////	Design Note
/////	-----------
/////	You need to call methods of private `links` directly to perform any mutations.
//public struct WorkspaceNodeList: CollectionType {
//	public var count:Int {
//		get {
//			return	links.count
//		}
//	}
//	public subscript(index:Int) -> WorkspaceNode {
//		get {
//			return	links[index].node
//		}
//	}
//	public func generate() -> GeneratorOf<WorkspaceNode> {
//		var	g	=	links.generate()
//		return	GeneratorOf {
//			if let n = g.next() {
//				return	n.node
//			}
//			return	nil
//		}
//	}
//	public var startIndex:Int {
//		get {
//			return	links.startIndex
//		}
//	}
//	public var endIndex:Int {
//		get {
//			return	links.endIndex
//		}
//	}
//	
//	////
//	
//	private var	links	=	[] as [WorkspaceNodeLink]
//}
//


























//public protocol WorkspaceNodeType {
//}
//
//public class WorkspaceFolderNode: WorkspaceNodeType {
//	private let _core	=	FolderCore()
//}
//public class WorkspaceFileNode: WorkspaceNodeType {
//	private let _core	=	FileCore()
//}









//private struct RepositoryCore {
//	var	nodes		=	[:] as [FullPath:NodeCore]
////	var	folderMap	=	[:] as [FullPath:FolderCore]
////	var	fileMap		=	[:] as [FullPath:FileCore]
//}
//
//private struct NodeCore {
//	var	owner:FullPath
//	var	kind:NodeKind
//	var	flags:NodeFlags
//
//	///	This also defines sort order of subnodes.
//	var	subnodes:[FullPath]
//}
//
//private enum NodeKind {
//	case Folder
//	case File
//}
//
//private struct NodeFlags {
//	///	This node does not speficy subtree nodes. Subtree must be resolve at runtime when needed.
//	///	Editor will monitor this node at file-system and will refresh GUI display automatically for any changes.
//	var	lazySubtree:Bool
//}
//
//private struct FolderCore {
//	var	ownerFolderFullPath:FullPath
//}
//
//private struct FileCore {
//	var	ownerFolderFullPath:FullPath
//}

