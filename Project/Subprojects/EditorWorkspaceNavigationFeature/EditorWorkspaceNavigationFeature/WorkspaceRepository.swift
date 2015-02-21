//
//  WorkspaceRepository.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/21.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation











///	Registered entries.
///	
///	A project will always have a root node.
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

///	`WillMove` and `DidMovw` will always be sent in pair and sequently and immediately.
///	If the events are not paired, it's a logic bug.
///	You can access proper old and new location at each events.
public protocol WorkspaceRepositoryDelegate: class {	
	func workspaceRepositoryDidCreateNode(node:WorkspaceNode)
	func workspaceRepositoryWillMoveNode(node:WorkspaceNode)
	func workspaceRepositoryDidMoveNode(node:WorkspaceNode)
	func workspaceRepositoryWillDeleteNode(node:WorkspaceNode)
	
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
///
///	Subworkspaces
///	-------------
///
///	If a workspace-node is representing a subworkspace, then it can load the subworkspace into memory.
///	Anyway moving nodes 
///
public final class WorkspaceNode {
	public private(set) unowned var repository:		WorkspaceRepository			///<	Set to `weak` to avoid cycle.
	public private(set) weak var	parent:			WorkspaceNode?				///<	Set to `weak` to avoid cycle.
	public private(set) var			children:		[WorkspaceNode]
	
	public private(set) var			name:			String
	public var						comment:		String?
	
	public private(set) var			kind:			WorkspaceNodeKind
	public private(set) var			flags:			WorkspaceNodeFlags
	
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
		self.flags		=	WorkspaceNodeFlags(lazySubtree: false)
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
		let	idx	=	indexOfNodeForName(name)
		return	idx == nil ? nil : children[idx!]
	}
}

public extension WorkspaceNode {
	public func createChildNodeForName(name:String, kind:WorkspaceNodeKind) -> WorkspaceNode {
		precondition(self.kind == WorkspaceNodeKind.Folder, "You can create subnode only in a `Folder` kind node.")
		precondition(parent == nil || parent!.nodeForName(name) == nil, "The name already been take by a sibling. Bad name.")
		
		let	n	=	WorkspaceNode(repository: self.repository, name: name, kind: kind)
		n.parent	=	self
		children.append(n)
		
		repository.delegate?.workspaceRepositoryDidCreateNode(n)
		return	n
	}
	public func deleteChildNodeAtIndex(index:Int) {
		let	n		=	children[index]
		repository.delegate?.workspaceRepositoryWillDeleteNode(n)
		
		n.parent	=	nil
		children.removeAtIndex(index)
	}
	public func deleteChildNodeForName(name:String) {
		if let idx = indexOfNodeForName(name) {
			deleteChildNodeAtIndex(idx)
		}
		fatalError("Cannot find a child node for the name.")
	}
	
	public func rename(name:String) {
		precondition(parent == nil || parent!.nodeForName(name) == nil, "The name already been take by a sibling. Bad name.")
		
		self.name	=	name
	}

	///	Moves a node into a new location.
	///	Node object will be moved without recreating a new instance.
	public func moveChildNode(atOldIndex:Int, toNewParentNode:WorkspaceNode, atNewIndex:Int, asNewName:String) {
		precondition(toNewParentNode.nodeForName(asNewName) == nil, "The name already been take by a sibling in the parent node. Bad name.")
		
		////
		
		let	n		=	children[atOldIndex]
		repository.delegate?.workspaceRepositoryWillMoveNode(n)
		
		n.parent	=	nil
		children.removeAtIndex(atOldIndex)
		
		////
		
		n.name		=	asNewName
		n.parent	=	toNewParentNode
		toNewParentNode.children.insert(n, atIndex: atNewIndex)
		let	newPath	=	n.path
		
		repository.delegate?.workspaceRepositoryDidMoveNode(n)
	}
	public func moveChildNode(atOldIndex:Int, toNewParentNode:WorkspaceNode, atNewIndex:Int) {
		let	n	=	self.children[atOldIndex]
		self.moveChildNode(atOldIndex, toNewParentNode: toNewParentNode, atNewIndex: atNewIndex, asNewName: n.name)
	}
}

public extension WorkspaceNode {
	public func delete() {
		precondition(parent != nil, "Root node cannot be moved.")
	
		if let idx = parent!.indexOfNode(self) {
			parent!.deleteChildNodeAtIndex(idx)
			return
		}
		fatalError("This node cannot be found from parent's children list. This is a serious logic bug, and must be patched.")
	}
	public func move(#toParentNode:WorkspaceNode, atIndex:Int, asName:String) {
		precondition(parent != nil, "Root node cannot be moved.")
		
		if let idx = parent!.indexOfNode(self) {
			parent!.moveChildNode(idx, toNewParentNode: toParentNode, atNewIndex: atIndex, asNewName: asName)
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

public enum WorkspaceNodeKind {
	case Folder
	case File
}

public struct WorkspaceNodeFlags {
	///	This node does not speficy subtree nodes. Subtree must be resolve at runtime when needed.
	///	Editor will monitor this node at file-system and will refresh GUI display automatically for any changes.
	///	This node should have no children. Having any child node will be treated as a serious logic bug.
	///	Strict programs should crash on lazy-subtree with any extra child, and fault-tolerent program
	///	should erase any child node.
	var	lazySubtree:Bool
	
//	///	This node is a `Folder` node that represents a subproject.
//	///	Subworkspace also mube be `lazySubtree`.
//	///	A root node SHOULD NOT set this to `true`.
//	var	subworkspace:Bool
}

















































///	MARK:
///	MARK:	WorkspacePath










public extension WorkspaceNode {
	public var path:WorkspacePath {
		get {
			if let p = parent {
				return	p.path.childPathWithComponent(self.name)
			} else {
				return	WorkspacePath(components: [self.name])
			}
		}
	}
}

///	Represents full-path from repository root.
///
///	For example, assume that we have a repository at `/sample1/repo2`
///	with these files.
///
///		/sample1
///			/repo2
///				/folder3
///					/file4
///					/file5
///				/file6
///	
///	You will get these entries in the repository.
///
///		/folder3/file4
///		/folder3/file5
///		/file6
///
public struct WorkspacePath {
	///	Represents path expression.
	///	This will be built with `path` part only with string that starting with `/`.
	///	For example, `file5` will be stored like this.
	///	
	///		eews://folder3/file5
	///
	var components:[String]
}







extension WorkspacePath: Equatable, Hashable {
	public var hashValue:Int {
		get {
			switch components.count {
			case 0:		return	0
			case 1:		return	components[0].hashValue
			default:	return	components[components.count-1].hashValue + components[components.count-2].hashValue
			}
		}
	}
	
	public var isRoot:Bool {
		get {
			return	components.count == 0
		}
	}
	
	///	Calling this when current object's `isRoot == true` will crash the program.
	public var parentPath:WorkspacePath {
		get {
			precondition(isRoot == false, "Current path is root. Parent cannot be defined.")
			return	WorkspacePath(components: Array(components[components.startIndex..<components.endIndex.predecessor()]))
		}
	}
	public func childPathWithComponent(component:String) -> WorkspacePath {
		return	WorkspacePath(components: self.components + [component])
	}
}

public extension WorkspacePath {
	public var URL:NSURL {
		get {
			var u	=	NSURL(scheme: PATH_URL_SCHEME, host: nil, path: "/")!
			for c in components {
				u	=	u.URLByAppendingPathComponent(c)
			}
			return	u
		}
	}
}

public func == (left:WorkspacePath, right:WorkspacePath) -> Bool {
	///	TODO: Optimise this. Paths are very likely to share suffix components, so compare from back to front.
	return	left.components == right.components
}





private let NODE_URL_SCHEME	=	"eonil.editor.workspace.node"
private let PATH_URL_SCHEME	=	"eonil.editor.workspace.path"
















































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

