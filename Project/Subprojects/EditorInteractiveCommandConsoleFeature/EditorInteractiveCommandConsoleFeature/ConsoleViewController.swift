//
//  ConsoleViewController.swift
//  EditorInteractiveCommandConsoleFeature
//
//  Created by Hoon H. on 2015/01/17.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import PseudoTeletypewriter
import EonilDispatch

public class ConsoleViewController: NSViewController {
	
	public var textView:NSTextView {
		get {
			return	view as NSTextView
		}
	}
	
	public override func loadView() {
		super.view	=	NSTextView()
		
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	func run(path:String, arguments:[String], environment:[String]) {
		precondition(pty == nil)
		
		pty	=	PseudoTeletypewriter(path: path, arguments: arguments, environment: environment)
		
		self.pty.masterFileHandle.readabilityHandler	=	{ [weak self] (f:NSFileHandle!)->() in
			
			let	d	=	f.availableData
			let	s	=	NSString(data: d, encoding: NSUTF8StringEncoding)!
			async(Queue.main) { [weak self] in
				self?.textView.insertText(s)
				()
			}
			
			()
		}
	}
	func halt() {
		precondition(pty != nil)
		
		let	r	=	kill(pty!.childProcessID, SIGKILL)
		precondition(r == 0)
		
		let	d	=	pty.masterFileHandle.readDataToEndOfFile()
		let	s	=	NSString(data: d, encoding: NSUTF8StringEncoding)!
		textView.insertText(s)
		pty.masterFileHandle.readabilityHandler	=	nil
	}
	
	private var	pty		=	nil as PseudoTeletypewriter!
}

//private class PTYController {
//	init(pty:PseudoTeletypewriter) {
//	}
//	deinit {
//		
//	}
//	private let	pty: PseudoTeletypewriter
//}


