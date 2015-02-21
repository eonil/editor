////
////  TableScrollViewController.swift
////  RustCodeEditor
////
////  Created by Hoon H. on 11/10/14.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//class TableScrollViewController : ScrollViewController1 {
//	var tableView:NSTableView {
//		get {
//			return	super.view as NSTableView
//		}
//		set(v) {
//			scrollView
//			tableView
//			super.view	=	v
//		}
//	}
//
//	override var view:NSView {
//		willSet(v) {
//			precondition(v is NSTableView)
//		}
//	}
//	
//	override func loadView() {
//		super.view	=	NSTableView()
//		
//	}
//
//}