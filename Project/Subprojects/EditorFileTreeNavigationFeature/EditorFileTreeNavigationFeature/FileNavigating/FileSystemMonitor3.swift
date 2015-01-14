//
//  FileSystemMonitor3.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/13.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import EonilDispatch
import EonilFileSystemEvents
import Precompilation






///	This starts monitoring automatically when created, and stops when deallocated.
///	This notifies all events immediately on the specified GCD queue.
final class FileSystemMonitor3 {
	///	We don't need to know what happens because whatever it happens it might not be exist at point of receive
	///	due to nature of asynchronous notification.
	init(monitoringRootURL:NSURL, callback:(NSURL)->()) {
		assert(NSThread.currentThread() == NSThread.mainThread())
		
		let	sm			=	SuspensionManager()
		sm.callback		=	callback
		
		self.queue		=	Queue(label: "FileSystemMonitor2/EventStreamQueue", attribute: Queue.Attribute.Serial)
		self.stream		=	EonilFileSystemEventStream(callback: { (events:[AnyObject]!) -> Void in
			async(Queue.main, {
				for e1 in events as [EonilFileSystemEvent] {
					let	isDir	=	(e1.flag & EonilFileSystemEventFlag.ItemIsDir) == EonilFileSystemEventFlag.ItemIsDir
					let	u1		=	NSURL(fileURLWithPath: e1.path, isDirectory: isDir)!
					
					sm.routeEvent(u1)
				}
			})
		}, pathsToWatch: [monitoringRootURL.path!], latency:1, watchRoot: false, queue: rawObjectOf(queue))
		
		self.susman		=	sm
	}
	
	var isPending:Bool {
		get {
			return	susman.isPending
		}
	}
	
	///	Suspends file-system monitoring event callback dispatch until you call `resume`.
	///	Any events occured during suspension will be queued and dispatched at resume.
	func suspendEventCallbackDispatch() {
		susman.suspendEventCallbackDispatch()
	}
	func resumeEventCallbackDispatch() {
		susman.resumeEventCallbackDispatch()
	}
	
	////
	
	private let	susman:SuspensionManager
	
	private let	queue:Queue
	private let	stream:EonilFileSystemEventStream
}














private final class SuspensionManager {
	init() {
	}
	
	func routeEvent(u:NSURL) {
		if is_pending {
			pending_events.append(u)
		} else {
			callback!(u)
		}
	}
	
	
	
	var isPending:Bool {
		get {
			return	is_pending
		}
	}
	
	///	Suspends file-system monitoring event callback dispatch until you call `resume`.
	///	Any events occured during suspension will be queued and dispatched at resume.
	func suspendEventCallbackDispatch() {
		precondition(is_pending == false)
		Debug.log("FS monitoring suspended")
		
		is_pending	=	true
	}
	func resumeEventCallbackDispatch() {
		precondition(is_pending == true)
		Debug.log("FS monitoring resumed")
		
		pending_events.map { [unowned self] u in
			self.callback!(u)
		}
		pending_events	=	[]
		is_pending		=	false
	}
	
	////
	
	private var pending_events	=	[] as [NSURL]
	private var	is_pending		=	false
	
	private var	callback:((NSURL)->())?
}




