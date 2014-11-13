////
////  FileSystemMonitor.swift
////  Editor
////
////  Created by Hoon H. on 11/13/14.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//import EonilDispatch
//
/////	Monitors hierarhical portion of file-system.
//final class FileSystemMonitor {
//	
//	let	notifyEventOnWatchForURL	=	Notifier<NSURL>()
//	
//	private var	_queue		=	Queue(label: "VNODEWatching", attribute: Queue.Attribute.Serial)
//	private var	_watchings	=	[:] as [NSURL:Watching]
//	
//	init(_ root:NSURL) {
//		addWatchForURL(root)
//	}
//	deinit {
//	}
//	
//	func addWatchForURL(u:NSURL) {
//		_watchings[u]	=	Watching(host: self, location: u)
//	}
//	func removeWatchForURL(u:NSURL) {
//		_watchings.removeValueForKey(u)
//	}
//	func notifyEventOnLocation(u:NSURL, flag:VNodeFlags) {
//		async(Queue.main) {
//			self.notifyEventOnWatchForURL.signal(u)
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
//private final class Watching {
//	unowned let	host:FileSystemMonitor
//	let			location:NSURL
//	
//	private let	_fd:FileDescriptor
//	private	let	_chs:[ForFlag]
//
//	init(host:FileSystemMonitor, location:NSURL) {
//		self.host		=	host
//		self.location	=	location
//		
//		////
//		
////		let	flag	=	VNodeFlags.Attrib | VNodeFlags.Delete | VNodeFlags.Extend | VNodeFlags.Link | VNodeFlags.Rename | VNodeFlags.Revoke | VNodeFlags.Write
//		
//		let route	=	{ [unowned host] (flag:VNodeFlags)->() in
//			host.notifyEventOnLocation(location, flag: flag)
//		}
//		
//		_fd		=	FileDescriptor(path: location.path!)
//		_chs	=	[
//			watch(location, host._queue, _fd, VNodeFlags.Write, route),
//			watch(location, host._queue, _fd, VNodeFlags.Delete, route),
//		]
//		for ch1 in _chs {
//			ch1.source.resume()
//		}
//		Debug.logOnMainQueueAsynchronously("Watching on `\(location.displayName)` started.")
//	}
//	deinit {
//		for ch1 in _chs {
//			ch1.source.cancel()
//		}
//		Debug.logOnMainQueueAsynchronously("Watching on `\(location.displayName)` stopped.")
//	}
//	
//	struct ForFlag {
//		let	flag:VNodeFlags
//		let	source:VNodeSource
//	}
//}
//
//
//private func watch(location:NSURL, queue:Queue, file:FileDescriptor, flag:VNodeFlags, event:(flag:VNodeFlags)->()) -> Watching.ForFlag {
//	let	s1	=	VNodeSource(file: file, flag: flag, queue: queue)
//	s1.eventHandler		=	{
//		Debug.logOnMainQueueAsynchronously("Watching on `\(location.displayName)` notified an event of `\(flag)`.")
//		event(flag: flag)
//	}
//	s1.cancelHandler	=	{
//		Debug.logOnMainQueueAsynchronously("Watching on `\(location.displayName)` cancelled for `\(flag)`.")
//	}
//	return	Watching.ForFlag(flag: flag, source: s1)
//}
//
//
//
