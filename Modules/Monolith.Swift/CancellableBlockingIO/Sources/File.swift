//
//  File.swift
//  EonilCancellableBlockingIO
//
//  Created by Hoon H. on 11/7/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

public class File {
	public struct Options {
		var	readable:Bool
		var	writable:Bool
		
		private func _openFlags() -> Int32 {
			var	f1	=	0 as Int32
				f1	|=	readable ? O_RDONLY : 0
				f1	|=	writable ? O_WRONLY : 0
			
			if readable && writable {
				f1	=	O_RDWR
			}
			
			return	f1
		}
	}
	
	public final class Random {
	}
	
	public final class Stream {
		
		private let	_raw:dispatch_io_t
		
		init?(path:String, options:Options) {
			let	s2	=	path as NSString
			
			///	Error if there's a file exists at the path.
			_raw	=	dispatch_io_create_with_path(DISPATCH_IO_STREAM, s2.UTF8String, options._openFlags(), 0, Dispatch.defaultGlobalBackgroundQueue()) { (error:Int32) -> Void in
				//	Cleanup.
			}
		}
		deinit {
//			dispatch_io_close(_raw, 0)
			cancel()
		}
		
//		var available:Bool {
//			get {
//				
//			}
//		}
		
		func cancel() {
			dispatch_io_close(_raw, DISPATCH_IO_STOP)
		}
		
		func read(range:Range<Int64>) -> NSData? {
			var	tran1	=	Transfer<NSData?>()
			
			let	offset	=	off_t(range.startIndex)
			let	length	=	UInt(range.endIndex - range.startIndex)
			let	queue	=	Dispatch.defaultGlobalBackgroundQueue()
			dispatch_io_read(_raw, offset, length, queue) { (done:Bool, data:dispatch_data_t!, error:Int32) -> Void in
				if !done || error != 0 {
					tran1.signal(nil)
				} else {
					let	d2	=	data as NSData?
					tran1.signal(d2)
				}
			}
			
			return	tran1.wait()
		}
		
//		func write(data:NSData) {
//			
//		}
	}
}