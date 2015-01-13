//
//  FileSystemMonitor2.swift
//  Editor
//
//  Created by Hoon H. on 11/14/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import EonilDispatch
import EonilFileSystemEvents

final class FileSystemMonitor2 {
	
	let	notifyEventForURL	=	Notifier<NSURL>()		///	We don't need to know what happen because whatever it happen, it might not be exist at now due to nature of asynchronous notification.
	
	let	queue:Queue
	let	stream:EonilFileSystemEventStream
	
	init(rootLocationToMonitor:NSURL) {
		assert(NSThread.currentThread() == NSThread.mainThread())
		
		unowned let	notify	=	notifyEventForURL
		queue	=	Queue(label: "FileSystemMonitor2/EventStreamQueue", attribute: Queue.Attribute.Serial)
		stream	=	EonilFileSystemEventStream(callback: { (events:[AnyObject]!) -> Void in
			async(Queue.main, { 
				for e1 in events as [EonilFileSystemEvent] {
					let	u1	=	NSURL(fileURLWithPath: e1.path)!.absoluteURL!
					notify.signal(u1)
				}
			})
		}, pathsToWatch: [rootLocationToMonitor.path!], latency:1, watchRoot: false, queue: rawObjectOf(queue))
	}
}

