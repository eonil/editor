////
////  FileNode2.swift
////  RustCodeEditor
////
////  Created by Hoon H. on 11/12/14.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//
//
/////	Soley owned file tree node.
/////	Fully URL based.
//final class FileNode2 {
//
//	///	Notifies any error occured while processing this tree.
//	///	All notifications will be routed to root node.
//	///	After the error occurs, any processing will stop, but 
//	///	processed operations will stay as is. 
//	///	As a result, there's no way to recover from error, and 
//	///	you must dispose the whole tree after an error occured.
//	let	notifyAnyError		=	Notifier<NSError>()
//	
//	///	Usually direct supernode is passed for changes of its 
//	///	subnode.
//	let	notifyInvalidationOfNode	=	Notifier<FileNode2>()
//	
//	
//	
//	let	supernode:FileNode2?
//	let	absoluteURL:NSURL
//
//	lazy var	subnodes:FileNodeSet	=	FileNodeSet(host: self)
//	
//	
//
//	
//	
//	private var _subnodes:[FileNode2]?
//	private var	_validity	=	false
//	
//	private	var	_cacheReady	=	false
//	
//	private var	_accessor:NSFileCoordinator?
//	private	var	_tracker:FileEventTracker?
//	
//	
//	
//	
//	
//	///	Makes a root node.
//	convenience init(absoluteURL:NSURL) {
//		precondition(absoluteURL.fileURL, "Only file path URL is supported.")
//		precondition(absoluteURL.absoluteURL == absoluteURL, "You must provide an absolute URL.")
//		
//		self.init(supernode: nil, absoluteURL: absoluteURL)
//	}
//	private init(supernode:FileNode2?, absoluteURL:NSURL) {
//		assert(supernode == nil || (absoluteURL.URLByDeletingLastPathComponent == supernode!.absoluteURL), "Supplied URL doesn't seem to be a direct subnode of the supernode.")
//		assert(absoluteURL.absoluteURL == absoluteURL, "You must provide an absolute URL.")
//
//		self.supernode		=	supernode
//		self.absoluteURL	=	absoluteURL
//		self.subnodes		=	FileNodeSet(host: self)
//		
//		_validity	=	true
//		_tracker	=	FileEventTracker(host: self)
//		
//		let	p1	=	FileEventTracker(host: self)
//		//	This routine exists to guarantee synchronised file access.
//		//	See Cocoa manual for details.
//		dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
//			var	e1	=	nil as NSError?
//			let	c1	=	NSFileCoordinator(filePresenter: nil)
//			c1.coordinateReadingItemAtURL(absoluteURL, options: NSFileCoordinatorReadingOptions.allZeros, error: &e1, byAccessor: { (u1:NSURL!) -> Void in
//				NSFileCoordinator.addFilePresenter(p1)
//			})
//			dispatch_async(dispatch_get_main_queue(), { () -> Void in
//				if let e2 = e1 {
//					self.notifyAnyError.signal(e2)
//				} else {
//					self._tracker	=	p1
//				}
//			})
//		})
//	}
//	
//	private func _prepareCache() {
//		if _cacheReady == false {
//			_rebuildCache()
//			subnodes._prepareCache()
//		}
//	}
//	private func _invalidateCache() {
//		if _cacheReady == true {
//			subnodes._invalidateCache()
//			_invalidateCache()
//		}
//	}
//	private func _rebuildCache() {
//		assert(_cacheReady == false)
//		_cacheReady	=	true
//	}
//	private func _demolishCache() {
//		assert(_cacheReady == true)
//		_cacheReady	=	false
//	}
//}
//
/////	Stably sorted, but the algorithm is opaque.
//final class FileNodeSet : SequenceType {
//	private unowned let	_host:FileNode2
//	private var			_cacheItems	=	[] as [FileNode2]
//	private	var			_cacheReady	=	false
//	
//	init(host:FileNode2) {
//		_host	=	host
//	}
//	var count:Int {
//		get {
//			_prepareCache()
//			return	_cacheItems.count
//		}
//	}
//	subscript(index:Int) -> FileNode2 {
//		get {
//			_prepareCache()
//			return	_cacheItems[index]
//		}
//	}
//	func generate() -> GeneratorOf<FileNode2> {
//		_prepareCache()
//		return	GeneratorOf(_cacheItems.generate())
//	}
//	
//	private func _tuneCacheByAddingOneAtURL(absoluteURL:NSURL) {
//		if _cacheReady {
//			let	n1	=	FileNode2(supernode: _host, absoluteURL: absoluteURL)
//			_cacheItems.append(n1)
//		}
//	}
//	private func _tuneCacheByRemovingOne(n:FileNode2) {
//		if _cacheReady {
//			_cacheItems	=	_cacheItems.filter({$0 !== n})
//		}
//	}
//	private func _prepareCache() {
//		if _cacheReady == false {
//			_rebuildCache()
//		}
//	}
//	private func _invalidateCache() {
//		if _cacheReady == true {
//			_invalidateCache()
//		}
//	}
//	private func _rebuildCache() {
//		assert(_cacheReady == false)
//		assert(_cacheItems.count == 0)
//		if NSFileManager.defaultManager().fileExistsAtPathAsDirectoryFile(_host.absolutePath) {
//			let	u1	=	_host.absoluteURL
//			let	it1	=	NSFileManager.defaultManager().enumeratorAtURL(u1, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles | NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants, errorHandler: { (url:NSURL!, error:NSError!) -> Bool in
//				return	false
//			})
//			let	it2	=	it1!
//			while let o1 = it2.nextObject() as? NSURL {
//				var	e1	=	nil as NSError?
//				let	n1	=	FileNode2(supernode: _host, absoluteURL: o1)
//				_cacheItems.append(n1)
//			}
//		}
//		_cacheReady	=	true
//	}
//	private func _demolishCache() {
//		assert(_cacheReady == true)
//		_cacheReady	=	false
//		_cacheItems.removeAll(keepCapacity: false)
//	}
//}
//
//
//
//
//
//
//extension FileNode2 {
//	
//	var	displayName:String {
//		get {
//			return	NSFileManager.defaultManager().displayNameAtPath(absolutePath)
//		}
//	}
//	var	absolutePath:String {
//		get {
//			return	absoluteURL.path!
//		}
//	}
//	var	existing:Bool {
//		get {
//			return	NSFileManager.defaultManager().fileExistsAtPath(absolutePath)
//		}
//	}
//	
//	var	data:NSData? {
//		get {
//			if NSFileManager.defaultManager().fileExistsAtPathAsDataFile(absolutePath) {
//				return	NSData(contentsOfFile: absolutePath)
//			}
//			return	nil
//		}
//	}
//	
//	var	root:FileNode2 {
//		get {
//			return	supernode == nil ? self : supernode!.root
//		}
//	}
//	var	directory:Bool {
//		get {
//			var	f1	=	false as ObjCBool
//			return	NSFileManager.defaultManager().fileExistsAtPath(self.absolutePath, isDirectory: &f1) && f1.boolValue
//		}
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
/////	Provides cooperative file locking with other processes.
/////	I hope the world to be full of good...
//private final class FileEventTracker : NSObject, NSFilePresenter {
//	unowned let	host:FileNode2
//	
//	init(host:FileNode2) {
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
//			return	NSOperationQueue.mainQueue()
//		}
//	}
//	
//	////	MARK:	About Self
//	
//	private func savePresentedItemChangesWithCompletionHandler(completionHandler: (NSError!) -> Void) {
//		//	Nothing to save.
//		completionHandler(nil)
//	}
//	private func accommodatePresentedItemDeletionWithCompletionHandler(completionHandler: (NSError!) -> Void) {
//		host.supernode?._invalidateCache()
//		completionHandler(nil)
//	}
//	private func presentedItemDidMoveToURL(newURL: NSURL) {
//		host.supernode?._invalidateCache()
//	}
//	private func presentedItemDidChange() {
//		host.supernode?._invalidateCache()
//	}
//	
//	////	MARK:	About Subitems
//	
//	private func accommodatePresentedSubitemDeletionAtURL(url: NSURL, completionHandler: (NSError!) -> Void) {
//		host._invalidateCache()
//		completionHandler(nil)
//	}
//	private func presentedSubitemDidAppearAtURL(url: NSURL) {
//		host._invalidateCache()
//	}
//	private func presentedSubitemAtURL(oldURL: NSURL, didMoveToURL newURL: NSURL) {
//		host._invalidateCache()
//	}
//	private func presentedSubitemDidChangeAtURL(url: NSURL) {
//		host._invalidateCache()
//	}
//	
//	////	MARK:	Versioning
//	
//	private func presentedItemDidGainVersion(version: NSFileVersion) {
//		host.supernode?._invalidateCache()
//	}
//	private func presentedItemDidLoseVersion(version: NSFileVersion) {
//		host.supernode?._invalidateCache()
//	}
//	private func presentedItemDidResolveConflictVersion(version: NSFileVersion) {
//		host.supernode?._invalidateCache()
//	}
//	private func presentedSubitemAtURL(url: NSURL, didGainVersion version: NSFileVersion) {
//		host.supernode?._invalidateCache()
//	}
//	private func presentedSubitemAtURL(url: NSURL, didLoseVersion version: NSFileVersion) {
//		host.supernode?._invalidateCache()
//	}
//	private func presentedSubitemAtURL(url: NSURL, didResolveConflictVersion version: NSFileVersion) {
//		host.supernode?._invalidateCache()
//	}
//	
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
//private func defaultGlobalFilePresentationEventQueue() -> NSOperationQueue {
//	struct Slot {
//		static let	theSlot	=	Slot()
//		let	value:NSOperationQueue
//		init() {
//			let	q1	=	NSOperationQueue()
//			q1.maxConcurrentOperationCount	=	1
//			value	=	q1
//		}
//	}
//	return	Slot.theSlot.value
//}
//
//private func mainThreadFileCoordinator() -> NSFileCoordinator {
//	struct Slot {
//		static let	value	=	NSFileCoordinator()
//	}
//	return	Slot.value
//}
//
//
//
//
