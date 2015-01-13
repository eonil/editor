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

///	This starts monitoring automatically when created, and stops when deallocated.
///	This notifies all events immediately on the specified GCD queue.
final class FileSystemMonitor3 {
	///	We don't need to know what happens because whatever it happens it might not be exist at point of receive
	///	due to nature of asynchronous notification.
	init(monitoringRootURL:NSURL, callback:(NSURL)->()) {
		assert(NSThread.currentThread() == NSThread.mainThread())
		
		queue	=	Queue(label: "FileSystemMonitor2/EventStreamQueue", attribute: Queue.Attribute.Serial)
		stream	=	EonilFileSystemEventStream(callback: { (events:[AnyObject]!) -> Void in
			async(Queue.main, {
				for e1 in events as [EonilFileSystemEvent] {
					let	isDir	=	(e1.flag & EonilFileSystemEventFlag.ItemIsDir) == EonilFileSystemEventFlag.ItemIsDir
					let	u1		=	NSURL(fileURLWithPath: e1.path, isDirectory: isDir)!
					callback(u1)
				}
			})
			}, pathsToWatch: [monitoringRootURL.path!], latency:1, watchRoot: false, queue: rawObjectOf(queue))
	}

	private let	queue:Queue
	private let	stream:EonilFileSystemEventStream
	
}

