////
////  CommandLineTool.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/08/15.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
/////	One-time use only command-line tool.
/////
//class CommandLineTool {
//
//
//	init() {
//		_task	=	NSTask()
//
//		_task.terminationHandler	=	{ [weak self] task in
//			dispatch_async(dispatch_get_main_queue()) {
//				self?._handleTermination()
//			}
//		}
//	}
//	deinit {
//		assert(_isTerminated == true)
//	}
//
//	/// - Parameters:
//	/// 	- executablePath:	
//	///		An absolute path to an executable to execute.
//	///
//	func run(executablePath: String, arguments: [String]) {
//		_task.launchPath	=	executablePath
//		_task.arguments		=	arguments
//		_task.launch()
//	}
//
//	///	Sends `SIGTERM`.
//	///
//	///	This tries gracegul stopping by sending `SIGINT` signal.
//	///
//	func stop() {
//		_task.terminate()
//	}
//
//	///	Sends `SIGKILL`.
//	///
//	///	This just forces killing of the process regardless of current state.
//	///
//	func halt() {
//
//	}
//
//	///
//
//	private let	_task		:	NSTask
//	private var	_isTerminated	=	false
//	private var	_outputLog	=	""
//
//	private func _handleTermination() {
//		_isTerminated	=	true
//	}
//
//	private func _appendOutput(output: String) {
//		_outputLog.extend(output)
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
