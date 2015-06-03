//
//  MainWindowController.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/20.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import SignalGraph

class MainWindowController {
	
	let	window	=	NSWindow()
	let	list	=	SingleColumnListViewController<Int, TestTextField1>()
	let	storage	=	EditableArrayStorage<Int>([])
	
	init() {
		window.styleMask	|=	NSResizableWindowMask
					|	NSClosableWindowMask
		window.setFrame(CGRect(x: 100, y: 100, width: 400, height: 300), display: true)
		window.makeKeyAndOrderFront(self)
		window.contentView	=	list.view

		storage.emitter.register(list.sensor)
		
		let	a	=	Array(0..<1024)
		storage.extend(a)
	}
}

class TestTextField1: NSTextField, DataPresentable {
	typealias	Data	=	Int
	
	var data: Int? {
		didSet {
			if let data = data {
				self.stringValue	=	"\(data)"
			} else {
				self.stringValue	=	""
			}
		}
	}
}

