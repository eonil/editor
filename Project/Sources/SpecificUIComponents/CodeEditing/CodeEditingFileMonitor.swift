////
////  CodeEditingFileMonitor.swift
////  Editor
////
////  Created by Hoon H. on 2015/01/17.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import EonilFileSystemEvents
//
//class CodeEditingFileMonitor {
//	weak var delegate:CodeEditingFileMonitorDelegate?
//	init(target:NSURL) {
//		assert(target.fileURL)
//		
//		self._targetURL	=	target
//
//		let	p	=	target.path!
//		_stream	=	EonilFileSystemEventStream(callback: { [weak self] (events:[AnyObject]!) -> Void in
//			
//		}, pathsToWatch: [p], latency: 0, watchRoot: true, queue: queue.main)
//	}
//	deinit {
//		_source.cancel()
//	}
//	
//	private let	_targetURL:NSURL
//	private let	_stream:EonilFileSystemEventStream
//}
//
//protocol CodeEditingFileMonitorDelegate: class {
//	func codeEditingFileMonitorDidSenseTargetFileMovementToURL(NSURL)
//	func codeEditingFileMonitorDidSenseTargetFileDeleteToURL(NSURL)
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
//func buildMessage(filepath:String) -> String {
//	return	"The file for the document that was at \(filepath) has disappeared. The document has previously unsaved changes. Do you want to re-save the document or close it?"
//}
//
