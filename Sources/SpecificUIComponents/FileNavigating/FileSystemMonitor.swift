//
//  FileSystemMonitor.swift
//  Editor
//
//  Created by Hoon H. on 11/13/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import EonilDispatch

///	Monitors hierarhical portion of file-system.
final class FileSystemMonitor {
	
	let	notifyEventOnWatchForURL	=	Notifier<NSURL>()
	
	private var	_watchings	=	[:] as [NSURL:Watching]
	
	init(_ root:NSURL) {
		addWatchForURL(root)
	}
	deinit {
	}
	
	func addWatchForURL(u:NSURL) {
		_watchings[u]	=	Watching(host: self, location: u)
	}
	func removeWatchForURL(u:NSURL) {
		_watchings.removeValueForKey(u)
	}
	func notifyEventOnLocation(u:NSURL, flag:VNodeFlags) {
		async(Queue.main) {
			self.notifyEventOnWatchForURL.signal(u)
		}
		
//		let	exists		=	NSFileManager.defaultManager().fileExistsAtPath(u.path!)
//		let	isdir		=	NSFileManager.defaultManager().fileExistsAtPathAsDirectoryFile(u.path!)
//
//		if let u2 = _watchings[u] {
//			if !exists {
//				notifyRemovingEntryAtURL.signal(u)
//				_watchings[u]	=	nil
//			}
//		} else {
//			if exists {
//				_watchings[u]	=	Watching(host: self, location: u)
//				notifyAddingEntryAtURL.signal(u)
//			}
//		}
	}
}









private final class Watching {
	unowned let	host:FileSystemMonitor
	let			location:NSURL
	
	private let	_fd:FileDescriptor
	private let	_src:VNodeSource

	init(host:FileSystemMonitor, location:NSURL) {
		self.host		=	host
		self.location	=	location
		
		////
		
		let	flag	=	VNodeFlags.Attrib | VNodeFlags.Delete | VNodeFlags.Extend | VNodeFlags.Link | VNodeFlags.Rename | VNodeFlags.Revoke | VNodeFlags.Write
		let	event	=	{ ()->() in
			Debug.log("Watching on `\(location.displayName)` notified an event of `\(flag.rawValue)`.")
			host.notifyEventOnLocation(location, flag: flag)
		}
		let	cancel	=	{ ()->() in
			Debug.log("Watching on `\(location.displayName)` cancelled.")
		}
		_fd			=	FileDescriptor(path: location.path!)
		_src		=	watch(_fd, flag, event, cancel)
		_src.resume()
		Debug.log("Watching on `\(location.displayName)` started.")
	}
	deinit {
		_src.cancel()
		Debug.log("Watching on `\(location.displayName)` stopped.")
	}
}


private func watch(fd:FileDescriptor, f:VNodeFlags, event:()->(), cancel:()->()) -> VNodeSource {
	let	q1	=	Queue.global(Queue.Priority.Background)
	let	s1	=	VNodeSource(file: fd, flag: f, queue: q1)
	s1.eventHandler		=	event
	s1.cancelHandler	=	cancel
	return	s1
}





private extension NSURL {
	var displayName:String {
		get {
			return	NSFileManager.defaultManager().displayNameAtPath(path!)
		}
	}
}


