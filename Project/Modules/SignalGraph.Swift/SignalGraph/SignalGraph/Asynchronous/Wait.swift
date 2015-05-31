//
//  Wait.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/09.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

///	Template registry namespace for asynchronous operations.
public struct Wait {
	public struct File {
		public static let	readAll		=	Spawn<String, NSData?>(readAllCore)
		public static let	writeAll	=	Spawn<(String,NSData), ()>(writeAllCore)
	}
	public struct HTTP {
		public static let	get			=	Spawn<NSURL, NSData?>() { signal, callback in () }
			
		struct Download {
			typealias	In	=	NSURL
			enum Out {
				case Error
				case Cancel
				case Done(locationOfFile: String)
			}
			static let	run	=	Spawn<In,Out>(Download.process)
			
			private static func process(signal: In, callback: Out->()) {
				
			}
		}
	}
}







private func readAllCore(signal: String, callback: NSData? -> ()) {
	dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
		let	data	=	NSData(contentsOfFile: signal)!
		dispatch_async(dispatch_get_main_queue()) {
			callback(data)
		}
	}
}
private func writeAllCore(signal: (path: String, data: NSData), callback: ()->()) {
	dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
		signal.data.writeToFile(signal.path, atomically: true)
		dispatch_async(dispatch_get_main_queue()) {
			callback()
		}
	}
}