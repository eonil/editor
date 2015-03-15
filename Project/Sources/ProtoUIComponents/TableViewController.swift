//
//  TableViewController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/10/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit

class TableViewController : NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	
	@availability(*,unavailable)
	required init?(coder: NSCoder) {
//		super.init(coder: coder)
		fatalError("IB is unsupported.")
	}
	
	@availability(*,unavailable)
	override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		fatalError("IB is unsupported.")
//		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	var tableView:NSTableView {
		get {
			return	super.view as! NSTableView
		}
		set(v) {
			super.view	=	v
		}
	}
	
	override var view:NSView {
		willSet(v) {
			precondition(v is NSTableView)
		}
	}
	
	override func loadView() {
		super.view	=	NSTableView()
		tableView.setDataSource(self)
		tableView.setDelegate(self)
	}
	
}



