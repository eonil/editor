//
//  FileNode4.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/13/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

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
///	always be prepared to fail when you depending on this cache.
///
///	Call `reload` explicitly to access root node.
///
///	Do not retain `FileNode4` from anywhere else. This tree uses
///	unique ownership semantics, and if you retain it anywhere else
///	it will leak memory or crash the app.
final class FileTreeRepository4 {
	private var	_allNodes	=	[:] as [NSURL:FileNode4]
	
	var	_rootlink:NSURL
	
	init(rootlink:NSURL) {
		self._rootlink	=	rootlink
	}
	
	var root:FileNode4? {
		get {
			return	_allNodes[_rootlink]
		}
	}
	subscript(u:NSURL) -> FileNode4? {
		get {
			return	_allNodes[u]
		}
	}
	
	///	Reloads root node.
	///	This effectively reload everything.
	///	Root node object will be re-created, then any
	///	reference to existing node must be invalidated.
	///	If the root node does not exist anymore,
	///	it will be removed, and will be set to `nil`.
	func reload() {
//		if root != nil && root!.existing {
//			root!.reloadSubnodes()
//			return
//		}
//		
		if root != nil {
			_deleteNodeForURL(_rootlink)
		}
		assert(_allNodes.count == 0, "All nodes must be also removed as an effect of killing root.")
		_createNodeForURL(_rootlink)
	}
	
	private func _deleteNodeForURL(u:NSURL) {
		assert(_allNodes[u] != nil)
		let	n1	=	_allNodes[u]!
		_allNodes.removeValueForKey(u)
		_deleteNodesForURLs(n1.subnodes._sublinks)	//	Cleanup subnodes.
	}
	private func _createNodeForURL(u:NSURL) {
		assert(_allNodes[u] == nil)
		let	n1	=	FileNode4(repository: self, link: u)
		_allNodes[u]	=	n1
	}
	private func _deleteNodesForURLs(us:[NSURL]) {
		for u in us {
			_deleteNodeForURL(u)
		}
	}
	private func _createNodesForURLs(us:[NSURL]) {
		for u in us {
			_createNodeForURL(u)
		}
	}
}


///	A view for a `NSOutlineView`.
///	This only exists because the view needs strongly alive class instances.
final class FileNode4 {
	unowned let	repository:FileTreeRepository4
	let			link:NSURL						///<	Always an absolute file URL.
	let			subnodes:FileSubnodeList4		///<	Holds live strong references for `NSOutlineView`.
	
	private init(repository:FileTreeRepository4, link:NSURL) {
		precondition(link.fileURL)
		precondition(link.absoluteURL == link)
		
		self.repository		=	repository
		self.link			=	link
		self.subnodes		=	FileSubnodeList4(repository: repository, superlink: link)
	}
	var existing:Bool {
		get {
			return	NSFileManager.defaultManager().fileExistsAtPath(link.path!)
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
	
	///	Synchronise subnodes with the file system.
	///	This will try to reuse existing subnodes as many as possible.
	///	(keeps existing one unless it has been deleted)
	func reloadSubnodes() {
		
		resetSubnodes()
		subnodes._sublinks	=	_subnodeAbsoluteURLsOfURL(link)
		repository._createNodesForURLs(subnodes._sublinks)
	}
	
	///	Removes all cached subnodes.
	///	It will remain as empty until you order `reloadSubnodes` explicitly.
	func resetSubnodes() {
		repository._deleteNodesForURLs(subnodes._sublinks)
		subnodes._sublinks	=	[]
	}
}

///	A list-type interface to access subnodes.
///	Fully controlled by it's owner node.
///	Ordering is stable. Pops deleted index and inserts new nodes at last.
final class FileSubnodeList4 : SequenceType {
	private unowned let	_repository:FileTreeRepository4
	private let			_superlink:NSURL
	private var			_sublinks:[NSURL]
	private init(repository:FileTreeRepository4, superlink:NSURL) {
		self._repository	=	repository
		self._superlink		=	superlink
		self._sublinks		=	[]
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

















extension FileNode4 {
	var displayName:String {
		get {
			return	NSFileManager.defaultManager().displayNameAtPath(link.path!)
		}
	}
	var directory:Bool {
		get {
			var	f1	=	false as ObjCBool
			return	NSFileManager.defaultManager().fileExistsAtPath(link.path!, isDirectory: &f1) && f1.boolValue
		}
	}
}


































private func _subnodeAbsoluteURLsOfURL(absoluteURL:NSURL) -> [NSURL] {
	var	us1	=	[] as [NSURL]
	if NSFileManager.defaultManager().fileExistsAtPathAsDirectoryFile(absoluteURL.path!) {
		let	u1	=	absoluteURL
		let	it1	=	NSFileManager.defaultManager().enumeratorAtURL(u1, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles | NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants, errorHandler: { (url:NSURL!, error:NSError!) -> Bool in
			fatalError("Unhandled file I/O error!")	//	TODO:
			return	false
		})
		let	it2	=	it1!
		while let o1 = it2.nextObject() as? NSURL {
			us1.append(o1)
		}
	}
	return	us1
}




