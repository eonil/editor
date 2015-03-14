//
//  EmptyOutlineViewController.swift
//  Editor
//
//  Created by Hoon H. on 11/17/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit

class EmptyOutlineViewController : NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {

	required convenience init?(coder: NSCoder) {
		fatalError("No support for IB.")
	}
	override convenience init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		self.init()
	}
	
	var	outlineView:NSOutlineView {
		get {
			return	view as! NSOutlineView
		}
		set(v) {
			view	=	v
			
			self.outlineView.setDelegate(self)
			self.outlineView.setDataSource(self)
		}
	}
	override var view:NSView {
		willSet(v) {
			precondition(v is NSOutlineView)
		}
	}
	override func loadView() {
		super.view	=	NSOutlineView()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
