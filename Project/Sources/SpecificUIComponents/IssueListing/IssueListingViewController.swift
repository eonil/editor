//
//  IssueListingViewController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/10/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit
import Precompilation
import PrecompilationOfExternalToolSupport




typealias	Issue	=	RustCompilerIssue

protocol IssueListingViewControllerDelegate: class {
	func issueListingViewControllerUserWantsToHighlightIssue(Issue)
	func issueListingViewControllerUserWantsToNavigateToIssue(Issue)
}
class IssueListingViewController : TableViewController {
	weak var delegate: IssueListingViewControllerDelegate?
	
	var	issues:[Issue] = [] {
		didSet {
			Debug.assertMainThread()
			
			self.tableView.reloadData()
		}
	}
	
	func appendIssues(additions:[Issue]) {
		let	s		=	self.issues.endIndex
		self.issues.extend(additions)
		let	e		=	self.issues.endIndex
		
		let	idxs	=	NSIndexSet(s..<e)
		idxs.enumerateIndexesUsingBlock { (idx:Int, _:UnsafeMutablePointer<ObjCBool>) -> Void in
			println(idx)
		}
		println(idxs)
		
		self.tableView.beginUpdates()
//		self.tableView.insertRowsAtIndexes(idxs, withAnimation: NSTableViewAnimationOptions.allZeros)
		self.tableView.reloadData()
		self.tableView.endUpdates()
	}
	func removeAllIssues() {
		let	idxs	=	NSIndexSet(0..<issues.count)
		
		self.tableView.beginUpdates()
		self.tableView.removeRowsAtIndexes(idxs, withAnimation: NSTableViewAnimationOptions.allZeros)
		self.tableView.endUpdates()
	}
	
	func userDidDoubleClick(sender:AnyObject?) {
		let	idx1	=	tableView.clickedRow
		let	s1		=	issues[idx1]
		
		delegate!.issueListingViewControllerUserWantsToNavigateToIssue(s1)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.headerView				=	nil
		tableView.rowSizeStyle				=	NSTableViewRowSizeStyle.Small
		tableView.selectionHighlightStyle	=	NSTableViewSelectionHighlightStyle.SourceList
		
		tableView.addTableColumn <<< NSTableColumn(identifier: NAME, title: "Name", width: 40)
//		tableView.addTableColumn <<< NSTableColumn(identifier: RANGE, title: "Range")
		tableView.addTableColumn <<< NSTableColumn(identifier: SEVERITY, title: "Severity", width: 60)
		tableView.addTableColumn <<< NSTableColumn(identifier: DESC, title: "Description")
		
		tableView.target			=	self
		tableView.doubleAction		=	"userDidDoubleClick:"
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
		let	r	=	tableView.selectedRow
		if r != -1 {
			let	s	=	self.issues[r]
			delegate!.issueListingViewControllerUserWantsToHighlightIssue(s)
		}
	}
}






private extension NSTableColumn {
	func stringValueFrom(s:Issue) -> String {
		switch self.identifier {
		case NAME:		return	s.location
		case RANGE:		return	s.range.description
		case SEVERITY:	return	s.severity.rawValue
		case DESC:		return	s.message
		default:		unreachableCodeError()
		}
	}
}



private let	NAME		=	"NAME"
private let	RANGE		=	"RANGE"
private let	SEVERITY	=	"SEVERITY"
private let	DESC		=	"DESC"

