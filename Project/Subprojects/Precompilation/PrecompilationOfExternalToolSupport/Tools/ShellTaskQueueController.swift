////
////  ShellTaskQueueController.swift
////  Precompilation
////
////  Created by Hoon H. on 2015/01/18.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
//
//public protocol ShellTaskQueueControllerDelegate: class {
//	func shellTaskQueueControllerDidFinishProcess()
//}
//public final class ShellTaskQueueController {
//	public init() {
//		
//	}
//	public func queue(#command:String, arguments:[String]) {
//		let	m	=	Item(command: command, arguments: arguments)
//		_items.append(m)
//	}
//	public func cancelAll() {
//		
//	}
//	public var execution:ShellTaskExecutionControllerDelegate
//	
//	////
//	
//	private struct Item {
//		var	command:String
//		var	arguments:[String]
//	}
//	
//	private var	_items	=	[] as [Item]
//	private let	_exec	=	ShellTaskExecutionController()
//}