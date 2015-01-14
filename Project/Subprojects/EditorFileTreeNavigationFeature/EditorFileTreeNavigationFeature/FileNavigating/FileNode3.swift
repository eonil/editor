////
////  FileNode3.swift
////  RustCodeEditor
////
////  Created by Hoon H. on 11/12/14.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//
//
/////////////////////////////////////////////////////////////////////////////
/////	Abandoned because there's no good way to get synchronous notification
/////	from file system.
/////////////////////////////////////////////////////////////////////////////
//
//
//
/////	Provides a fully reactive file tree that follows changes in
/////	underlying file system. Start with `rootLocationURL`.
//final class FileTreeRepository3 {
//	
//	///	When you set this property, this object will start asynchronous
//	///	file system query procedure. Actual file node informations will
//	///	not be available immediately, and be arrived when it's ready.
//	///	To monitor those readiness, use `notifyFileNodeDidAdd` and its 
//	///	family.
//	///
//	///	If specified root file has been removed from underlying file 
//	///	system, this property will be set to `nil`. This event will also
//	///	be notified by passing root `FileInfoNode3` object.
//	///
//	///	On any error, `notifyError` will be signaled, and any information
//	///	fetching will stop, but already fetched nodes will stay as is.
//	///	(no rollback)
//	var rootLocationURL:NSURL? {
//		willSet(v) {
//			if v != nil {
//				_rootNode	=	nil
//			}
//		}
//		didSet {
//			if let v2 = rootLocationURL {
//				_rootNode	=	FileNode3(tree: self, supernode: nil, absoluteURL: v2)
//			}
//		}
//	}
//	
//	var	rootNode:FileNode3? {
//		get {
//			return	_rootNode
//		}
//	}
//	
//	let	notifyError					=	Notifier<NSError>()
//	let	notifyAddingNodes			=	Notifier<[FileNode3]>()
//	
//	///	The information of the node has ALREADY been invalidated, and 
//	///	it must be removed. This is provided to reflect those changes
//	///	to UI presentation. Any access to any feature of the node object 
//	///	will produce an error, so will crash the app. The only thing you
//	///	can access it its reference. So remove related informations by
//	///	node object reference.
//	let	notifyRemovingNodes			=	Notifier<[FileNode3]>()
//	
//	
////	private let	_fileCoordinator	=	NSFileCoordinator()
//	private let	_fileOperationQueue	=	NSOperationQueue()
//	private var	_rootNode			=	nil as FileNode3?
//	
//	init() {
//		_fileOperationQueue.maxConcurrentOperationCount	=	1
//		_fileOperationQueue.qualityOfService			=	NSQualityOfService.UserInteractive
//	}
//	
//	private func _invalidateRootNode() {
//		rootLocationURL	=	nil
//	}
//	
//	private func _routeError(e:NSError) {
//		notifyError.signal(e)
//	}
//	private func _routeAddingOfNodes(ns:[FileNode3]) {
//		notifyAddingNodes.signal(ns)
//	}
//	private func _routeRemovingOfNodes(ns:[FileNode3]) {
//		notifyRemovingNodes.signal(ns)
//	}
//}
//
//
//
//
//final class FileNode3 {
//	unowned let	tree:FileTreeRepository3
//	let			supernode:FileNode3?
//	let			absoluteURL:NSURL
//	
//	private	lazy var	_subnodes:FileSubnodeSet3	=	FileSubnodeSet3(host: self)
//	private lazy var	_tracker:FileEventTracker	=	FileEventTracker(host: self)
//	private lazy var	_accessor:NSFileCoordinator	=	NSFileCoordinator(filePresenter: self._tracker)
//	
//	private init(tree:FileTreeRepository3, supernode:FileNode3?, absoluteURL:NSURL) {
//		self.tree			=	tree
//		self.supernode		=	supernode
//		self.absoluteURL	=	absoluteURL
//
////		dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
////			var	e1	=	nil as NSError?
////			self.tree._fileCoordinator.coordinateReadingItemAtURL(absoluteURL, options: NSFileCoordinatorReadingOptions.allZeros, error: &e1) { (u1:NSURL!) -> Void in
////				NSFileCoordinator.addFilePresenter(self._tracker)
////			}
////		})
//		
//		tree._fileOperationQueue.addOperationWithBlock { () -> Void in
//			var	e1	=	nil as NSError?
//			self._accessor.coordinateReadingItemAtURL(absoluteURL, options: NSFileCoordinatorReadingOptions.allZeros, error: &e1) { (u1:NSURL!) -> Void in
//				NSFileCoordinator.addFilePresenter(self._tracker)
//			}
//		}
//	}
//	deinit {
//		NSFileCoordinator.removeFilePresenter(_tracker)
//	}
//	
//	private func _invalidateSelf() {
//		if let n2 = supernode {
//			n2.subnodes._notifyFileEntryDidChangeAtURL(absoluteURL)
//		} else {
//			assert(tree.rootNode === self)
//			tree._invalidateRootNode()
//			tree.rootLocationURL	=	absoluteURL
//		}
//	}
//}
//
//extension FileNode3 {
//	var	subnodes:FileSubnodeSet3 {
//		get {
//			return	_subnodes
//		}
//	}
//	var displayName:String {
//		get {
//			return	NSFileManager.defaultManager().displayNameAtPath(absoluteURL.path!)
//		}
//	}
//	var existing:Bool {
//		get {
//			return	NSFileManager.defaultManager().fileExistsAtPath(absoluteURL.path!)
//		}
//	}
//	var directory:Bool {
//		get {
//			var	f1	=	false as ObjCBool
//			return	NSFileManager.defaultManager().fileExistsAtPath(absoluteURL.path!, isDirectory: &f1) && f1.boolValue
//		}
//	}
//}
//
//
//
//
//
//
/////	Subnode set fetches subnodes lazily.
/////	At first, it has nothing, and fetches items incrementally.
/////	On each fetching, related notification will be sent to tree.
/////	This class is hardly coupled with `FileNode3` class, and
/////	file-system tracking will also be supported.
//final class FileSubnodeSet3 : SequenceType {
//	private unowned let	_host:FileNode3
//	private var			_cache:LocalCache
//	
//	private init(host:FileNode3) {
//		self._host	=	host
//		self._cache	=	LocalCache()
//		
//		_reloadAllItemsAsync()
//	}
//	deinit {
//	}
//	
//	var count:Int {
//		get {
//			return	_cache.items.count
//		}
//	}
//	subscript(index:Int) -> FileNode3 {
//		get {
//			return	_cache.items[index]
//		}
//	}
//	func generate() -> IndexingGenerator<Array<FileNode3>> {
//		return	_cache.items.generate()
//	}
//
//	////
//	
//	private struct LocalCache {
//		var	items	=	[] as [FileNode3]
//	}
//
//	private func _reloadAllItemsAsync() {
//		_host.tree._fileOperationQueue.addOperationWithBlock { () -> Void in
//			var	us2	=	[] as [NSURL]
//			var	e1	=	nil as NSError?
//			self._host._accessor.coordinateReadingItemAtURL(self._host.absoluteURL, options: NSFileCoordinatorReadingOptions.allZeros, error: &e1) { (u1:NSURL!) -> Void in
//				us2	=	_subnodeAbsoluteURLsOfURL(u1)
//			}
//			_dispatchAsyncMain({ () -> () in
//				if let e2 = e1 {
//					self._host.tree._routeError(e2)
//				} else {
//					self._host.tree._routeRemovingOfNodes(self._cache.items)
//					self._cache.items	=	us2.map({FileNode3(tree: self._host.tree, supernode: self._host, absoluteURL: $0)})
//					self._host.tree._routeAddingOfNodes(self._cache.items)
//				}
//			})
//		}
//	}
//	
//	private func _addItemDirectly(u:NSURL) {
//		assert(u.absoluteURL == u)
//		assert(u.fileURL)
//		
//		let	n1	=	FileNode3(tree: _host.tree, supernode: _host, absoluteURL: u)
//		_cache.items.append(n1)
//		self._host.tree._routeAddingOfNodes([n1])
//	}
//	
//	private func _removeItemDirectly(u:NSURL) {
//		assert(u.absoluteURL == u)
//		assert(u.fileURL)
//		
//		let	ns1	=	_cache.items.filter({$0.absoluteURL == u})
//		let	ns2	=	_cache.items.filter({$0.absoluteURL != u})
//		assert(ns1.count == 1)
//		assert(ns2.count + 1 == _cache.items.count)
//		_host.tree._routeRemovingOfNodes(ns1)
//		_cache.items	=	ns2
//	}
//	
//	private func _notifyFileEntryDidChangeAtURL(u:NSURL) {
//		let	ns1		=	_cache.items.filter({$0.absoluteURL == u})
//		assert(ns1.count <= 1)
//		let	has1	=	ns1.count == 1
//		let	exists1	=	NSFileManager.defaultManager().fileExistsAtPath(u.path!)
//		
//		switch (has1, exists1) {
//		case (true, true):			return					//	No change.
//		case (true, false):			_removeItemDirectly(u)	//	Deleted.
//		case (false, true):			_addItemDirectly(u)		//	Added.
//		case (false, false):		return					//	WTF?
//		default:					return					//	Arrr..
//		}
//	}
//	
////	private func _invalidateSubnodeItemForURL(u:NSURL) {
////		let	ns1	=	_cache.items.filter({$0.absoluteURL == u})
////		assert(ns1.count <= 1)
////		for n1 in ns1 {
////			_removeItemDirectly(u)
////		}
////		if NSFileManager.defaultManager().fileExistsAtPath(u.path!) {
////			_addItemDirectly(u)
////		}
////	}
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
/////	Provides cooperative file locking with other processes.
/////	I hope the world to be full of good...
//private final class FileEventTracker : NSObject, NSFilePresenter {
//	unowned let	host:FileNode3
//	
//	init(host:FileNode3) {
//		self.host	=	host
//		super.init()
//	}
//	deinit {
//	}
//	
//	////	MARK:	Core
//	
//	var presentedItemURL:NSURL? {
//		get {
//			return	host.absoluteURL
//		}
//	}
//	var presentedItemOperationQueue:NSOperationQueue {
//		get {
//			return	host.tree._fileOperationQueue
//		}
//	}
//	
//	////	MARK:	About Self
//	
//	func savePresentedItemChangesWithCompletionHandler(completionHandler: (NSError!) -> Void) {
////		println("savePresentedItemChangesWithCompletionHandler(\(completionHandler)), host = \(host.displayName)")
////		//	Nothing to save.
//		self.host.tree._fileOperationQueue.addOperationWithBlock { () -> Void in
//			completionHandler(nil)
//		}
//	}
//	func accommodatePresentedItemDeletionWithCompletionHandler(completionHandler: (NSError!) -> Void) {
////		println("accommodatePresentedItemDeletionWithCompletionHandler(\(completionHandler)), host = \(host.displayName)")
////		_dispatchAsyncMain { () -> () in
////			self.host._invalidateSelf()
//			self.host.tree._fileOperationQueue.addOperationWithBlock { () -> Void in
//				completionHandler(nil)
//			}
////		}
//	}
//	func presentedItemDidMoveToURL(newURL: NSURL) {
////		println("presentedItemDidMoveToURL(\(newURL)), host = \(host.displayName)")
//	}
//	func presentedItemDidChange() {
////		println("presentedItemDidChange(), host = \(host.displayName)")
////		self.host._invalidateSelf()
//		
//	}
//	
//	////	MARK:	About Subitems
//	
//	func accommodatePresentedSubitemDeletionAtURL(url: NSURL, completionHandler: (NSError!) -> Void) {
////		println("accommodatePresentedSubitemDeletionAtURL(\(url), \(completionHandler)), host = \(host.displayName)")
////		_dispatchAsyncMain { () -> () in
////			self.host.subnodes._removeItemDirectly(url)
//			self.host.tree._fileOperationQueue.addOperationWithBlock { () -> Void in
//				completionHandler(nil)
//			}
//	}
//	func presentedSubitemDidAppearAtURL(url: NSURL) {
////		println("presentedSubitemDidAppearAtURL(\(url)), host = \(host.displayName)")
////		_dispatchAsyncMain { () -> () in
////			self.host.subnodes._addItemDirectly(url)
////		}
//	}
//	func presentedSubitemAtURL(oldURL: NSURL, didMoveToURL newURL: NSURL) {
////		println("presentedSubitemAtURL(\(oldURL), didMoveToURL: \(newURL)), host = \(host.displayName)")
////		
//	}
//	func presentedSubitemDidChangeAtURL(url: NSURL) {
//		println("presentedSubitemDidChangeAtURL(\(url)), host = \(host.displayName)")
//		_dispatchAsyncMain { () -> () in
//			self.host.subnodes._notifyFileEntryDidChangeAtURL(url)
////			self.host.subnodes._invalidateSubnodeItemForURL(url)
//		}
//	}
//	
//	////	MARK:	Versioning
//	
//	func presentedItemDidGainVersion(version: NSFileVersion) {
//		println("presentedItemDidGainVersion(\(version))")
//		
//	}
//	func presentedItemDidLoseVersion(version: NSFileVersion) {
//		println("presentedItemDidLoseVersion(\(version))")
//		
//	}
//	func presentedItemDidResolveConflictVersion(version: NSFileVersion) {
//		println("presentedItemDidResolveConflictVersion(\(version))")
//		
//	}
//	func presentedSubitemAtURL(url: NSURL, didGainVersion version: NSFileVersion) {
//		println("presentedSubitemAtURL(\(url), didGainVersion: \(version))")
//		
//	}
//	func presentedSubitemAtURL(url: NSURL, didLoseVersion version: NSFileVersion) {
//		println("presentedSubitemAtURL(\(url), didLoseVersion: \(version))")
//		
//	}
//	func presentedSubitemAtURL(url: NSURL, didResolveConflictVersion version: NSFileVersion) {
//		println("presentedSubitemAtURL(\(url), didResolveConflictVersion: \(version))")
//		
//	}
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//private func _dispatchAsyncMain(f:()->()) {
//	dispatch_async(dispatch_get_main_queue(), f)
//}
//
//private func _subnodeAbsoluteURLsOfURL(absoluteURL:NSURL) -> [NSURL] {
//	var	us1	=	[] as [NSURL]
//	if NSFileManager.defaultManager().fileExistsAtPathAsDirectoryFile(absoluteURL.path!) {
//		let	u1	=	absoluteURL
//		let	it1	=	NSFileManager.defaultManager().enumeratorAtURL(u1, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles | NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants, errorHandler: { (url:NSURL!, error:NSError!) -> Bool in
//			fatalError("Unhandled file I/O error!")	//	TODO:
//			return	false
//		})
//		let	it2	=	it1!
//		while let o1 = it2.nextObject() as? NSURL {
//			us1.append(o1)
//		}
//	}
//	return	us1
//}
//
//
//
//
