//
//  FileNode4.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/13/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit
import Precompilation


///	A passive data structure to store local in-memory cache to
///	file-system structures. A view controller is responsible to
///	manipulate these classes. This data model exists only for 
///	view-display in `FileTreeViewController4`.
///
///	File system is a remote alien system, and there's no good
///	way to be fully synchronised with it. Then the only way to
///	deal with it is having a local cache. An explicit command
///	must be issued to be synchronised with source file-system.
///	Anyway remote file-system can be out-synced at anytime, then
///	always be prepared for cache out-sync.
///
///	Call `reload` explicitly to access root node.
///
///	Do not retain `FileNode4` from anywhere else. This tree uses
///	unique ownership semantics, and if you retain it anywhere else
///	it will leak memory or crash the app.
final class FileTreeRepository4 {
	private var	_allNodes				=	[:] as [NSURL:FileNode4]
	
	var	_rootlink:NSURL
	
	init(rootlink:NSURL) {
		self._rootlink	=	rootlink
	}
	
	var root:FileNode4? {
		get {
			return	_allNodes[_rootlink]
		}
	}
	
	///	Get a node for supplied URL.
	subscript(u:NSURL) -> FileNode4? {
		get {
			return	_allNodes[u]
		}
	}
	
	///	Get nodes for supplied URLs. Nodes will be places at same index of its key URL.
	///	This guarantees returning of exactly same number of nodes.
	///	If node for a URL is missing, `nil` will be placed at the same index.
	subscript(us:[NSURL]) -> [FileNode4?] {
		get {
			return	us.map({self[$0]})
		}
	}
	
	///	Reloads root node.
	///	This effectively reload every nodes in the repository.
	///	Root node object will be re-created, then any
	///	reference to existing node must be invalidated.
	///	If the root node does not exist anymore,
	///	it will be removed, and will be set to `nil`.
	func reload() {
		if root != nil {
			deleteNodeForURL(_rootlink)
		}
		assert(_allNodes.count == 0, "All nodes must also be removed as an effect of killing root.")
		createNodeForURL(_rootlink)
	}
	
	///	Supplied URL must be already stored.
	func deleteNodeForURL(u:NSURL) {
		assert(_allNodes[u] != nil)
		let	n1	=	_allNodes[u]!
		_allNodes.removeValueForKey(u)
		deleteNodesForURLs(n1.subnodes._sublinks)	//	Cleanup subnodes.
		
		Debug.log("FileNode4 count: \(_allNodes.count)")
	}
	///	Supplied URL must be an unstored child of a stored node.
	func createNodeForURL(u:NSURL) {
		assert(_allNodes[u] == nil)
		let	n1	=	FileNode4(repository: self, link: u)
		_allNodes[u]	=	n1
		
		Debug.log("FileNode4 count: \(_allNodes.count)")
	}
	
	///	Supplied URLs must be already stored.
	func deleteNodesForURLs(us:[NSURL]) {
		for u in us {
			deleteNodeForURL(u)
		}
	}
	///	Supplied URLs must be unstored children of stored nodes.
	func createNodesForURLs(us:[NSURL]) {
		for u in us {
			createNodeForURL(u)
		}
	}
	
	////
	
	///	Keeps node instance and replaces its link.
	///
	///	TODO:
	///	This function doesn't seem to be a good design. Though
	///	I cannot figure out where, but I smell some bad stuff...
	///	Please review this eventually.
	func relocateNodeToURL(from:NSURL, to:NSURL) {
		println(to.absoluteString)
		precondition(from != to, "You cannot relocate to same location.")
		precondition(self[to] === nil, "You cannot move this node to an existing URL in repository.")
		precondition(self.root !== nil, "You cannot move into a root-less repository.")
		precondition(to.absoluteString!.hasPrefix(self.root!.link.absoluteString!), "You cannot move out of this repository.")
		assert(_allNodes[from] !== nil, "Supplied `from` URL cannot be found in this repository.")
		
		let	targetNode		=	_allNodes[from]!
		
		////
		
		func relocateSubnodesOfTargetNode() {
			let	subtargetURLs	=	targetNode.subnodes.links
			for u in subtargetURLs {
				let	s	=	u.absoluteString!
				let	s1	=	s.substringFromIndex(from.absoluteString!.endIndex)
				let	s2	=	to.absoluteString!.stringByAppendingString(s1)
				let	u1	=	NSURL(string: s2)!		//	I am not sure on this.
				relocateNodeToURL(u, to: u1)
			}
		}
		relocateSubnodesOfTargetNode()
		
		////
		
		func relocateTargetNode() {
			_allNodes.removeValueForKey(from)
			_allNodes[to]					=	targetNode
			targetNode._link				=	to
			targetNode.subnodes._superlink	=	to
		
			////
			
			let	parentFromURL	=	from.URLByDeletingLastPathComponent!
			let	parentNode		=	_allNodes[parentFromURL]
			
			var	siblingsURLs	=	parentNode!.subnodes._sublinks
			let	siblingsURLs2	=	siblingsURLs.map { (u:NSURL)->NSURL in
				return	u == from ? to : u
			}
			parentNode!.subnodes._sublinks	=	siblingsURLs2
		}
		relocateTargetNode()
	}
}

















///	A data object for a `NSOutlineView`.
///	`NSOutlineView` performas pointer based instance object comparison to decide whether to 
///	reuse existing visual node or not. So you need to provide same node object to make it as expected.
///	This is the only reason that we need this design.
///
///	Also the outline-view does not retain the node object. These node object will be retained by the 
///	repository object.
final class FileNode4 {
	unowned let	repository:FileTreeRepository4
	let			subnodes:FileSubnodeList4		///<	Holds live strong references to `FileNode4` instances for rendering in `NSOutlineView`.
	let			icon:NSImage					///<	Local cached icon file. This is required because we can't rely on just-in-time file-system query.
	
	var link:NSURL {
		get {
			return	_link
		}
		set(v) {
			repository.relocateNodeToURL(_link, to: v)
		}
	}
	var supernode:FileNode4? {
		get {
			if repository.root === self {
				return	nil
			} else {
				return	repository[link.URLByDeletingLastPathComponent!]!
			}
		}
	}
	
	////
	
	private init(repository:FileTreeRepository4, link:NSURL) {
		precondition(link.fileURL)
		precondition(link.absoluteURL == link)
		assert(link.absoluteString == link.absoluteString)
		
		self.repository		=	repository
		self._link			=	link
		self.subnodes		=	FileSubnodeList4(repository: repository, superlink: link)
		self.icon			=	NSWorkspace.sharedWorkspace().iconForFile(link.path!)
	}
	
	private var	_link:NSURL				///<	Always an absolute file URL.
}











///	A list-type interface to access subnodes.
///	Fully controlled by it's owner node.
///	Ordering is stable. Pops deleted nodes and inserts new nodes at last.
final class FileSubnodeList4 : SequenceType {
	private unowned let	_repository:FileTreeRepository4
	private var			_superlink:NSURL
	private var			_sublinks:[NSURL]
	private init(repository:FileTreeRepository4, superlink:NSURL) {
		self._repository	=	repository
		self._superlink		=	superlink
		self._sublinks		=	[]
	}
	
	///	Manages URLs of subnodes.
	var	links:[NSURL] {
		get {
			return	_sublinks
		}
		set(v) {
			func checkup(superlink:NSURL, sublinks:[NSURL]) -> Bool {
				for u in sublinks {
					assert(u.URLByDeletingLastPathComponent == superlink)
					return	u.URLByDeletingLastPathComponent == superlink
				}
				return	true
			}
			assert(checkup(_superlink, v))
			
			////
			
			func simplest() {
				_repository.deleteNodesForURLs(_sublinks)
				_sublinks	=	v
				_repository.createNodesForURLs(_sublinks)
			}
			
			///	Keeps existing nodes as much as possible for better UX.
			func optimised() {
				let	diffs	=	resolveDifferences(_sublinks, v)
				
				_repository.deleteNodesForURLs(diffs.outgoings)
				_repository.createNodesForURLs(diffs.incomings)
				
				_sublinks	=	diffs.stays + diffs.incomings
			}

			////
			
//			simplest()
			optimised()
		}
	}
	var count:Int {
		get {
			return	_sublinks.count
		}
	}
	var host:FileNode4 {
		get {
			return	_repository[_superlink]!
		}
	}
	subscript(index:Int) -> FileNode4 {
		get {
			return	_repository[_sublinks[index]]!
		}
	}
	func generate() -> GeneratorOf<FileNode4> {
		var	g1	=	_sublinks.generate()
		return	GeneratorOf({ () -> FileNode4? in
			let	k1	=	g1.next()
			return	k1 == nil ? nil : self._repository[k1!]!
		})
	}
}










































