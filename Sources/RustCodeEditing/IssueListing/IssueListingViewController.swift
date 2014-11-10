//
//  IssueListingViewController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/10/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit









class IssueListingViewController : TableViewController {
	var	issues:[Issue] = [] {
		didSet {
			self.tableView.reloadData()
		}
	}
	
	let	userIsWantingToHighlightIssues	=	Notifier<[Issue]>()
	let	userIsWantingToNavigateToIssue	=	Notifier<Issue>()
	
	func userDidDoubleClick(sender:AnyObject?) {
		let	idx1	=	tableView.clickedRow
		let	s1		=	issues[idx1]
		
		userIsWantingToNavigateToIssue.signal(s1)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.rowSizeStyle	=	NSTableViewRowSizeStyle.Small
		tableView.addTableColumn <<< NSTableColumn(identifier: NAME, title: "Name", width: 40)
//		tableView.addTableColumn <<< NSTableColumn(identifier: RANGE, title: "Range")
		tableView.addTableColumn <<< NSTableColumn(identifier: CLASS, title: "Class", width: 40)
		tableView.addTableColumn <<< NSTableColumn(identifier: DESC, title: "Description")
		
		tableView.target		=	self
		tableView.doubleAction	=	"userDidDoubleClick:"
	}
	
	func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		return	issues.count
	}
//	func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
//		let	m1	=	issues[row]
//		
//		switch tableColumn!.identifier {
//		case NAME:		return	m1.path
//		case RANGE:		return	"?"
//		case CLASS:		return	m1.type.rawValue
//		case DESC:		return	m1.description
//		default:		fatalError("Unknown column identifier.")
//		}
//	}
	func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return	16
	}
	func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let	tv1	=	NSTextField()
//		let	iv1	=	NSImageView()
		let	cv1	=	NSTableCellView()
		cv1.textField	=	tv1
//		cv1.imageView	=	iv1
		cv1.addSubview(tv1)
//		cv1.addSubview(iv1)
		
		let	m1	=	issues[row]
		cv1.textField!.stringValue		=	tableColumn!.stringValueFrom(m1)
		cv1.textField!.bordered			=	false
		cv1.textField!.backgroundColor	=	NSColor.clearColor()
		cv1.textField!.editable			=	false
		(cv1.textField!.cell() as NSCell).lineBreakMode	=	NSLineBreakMode.ByTruncatingHead
		return	cv1
	}

	func tableViewSelectionDidChange(notification: NSNotification) {
		let	ss1		=	tableView.selectedRowIndexes.allIndexes.map({self.issues[$0]})
		userIsWantingToHighlightIssues.signal(ss1)
	}
}






private extension NSTableColumn {
	func stringValueFrom(s:Issue) -> String {
		switch self.identifier {
		case NAME:		return	s.path
		case RANGE:		return	s.range.description
		case CLASS:		return	s.type.rawValue
		case DESC:		return	s.text
		default:		unreachableCodeError()
		}
	}
}



private let	NAME	=	"NAME"
private let	RANGE	=	"RANGE"
private let	CLASS	=	"CLASS"
private let	DESC	=	"DESC"

