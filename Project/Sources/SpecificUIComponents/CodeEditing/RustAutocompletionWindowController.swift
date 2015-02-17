//
//  RustAutocompletionWindowController.swift
//  Editor
//
//  Created by Hoon H. on 12/21/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorToolComponents

struct RustAutocompletion {
	class WindowController: EditorCommonWindowController2, CodeTextViewAutocompletionController {
		func presentForSelectionOfTextView(textView:NSTextView) {
			assert(textView.window !== nil)
			assert(self.window !== nil)

			func leftTopRect() -> CGRect {
				let	m	=	textView.layoutManager!
				let	r1	=	m.glyphIndexForCharacterAtIndex(textView.selectedRange().location)
				let	r2	=	m.boundingRectForGlyphRange(NSRange(location: r1, length: 0), inTextContainer: textView.textContainer!)
				let	p3	=	textView.textContainerOrigin
//				let	s4	=	view.textContainerInset
				return	CGRect(x: r2.minX + p3.x, y: r2.maxY + p3.y, width: 0, height: 0)
			}
			
			let	r1	=	leftTopRect()
			let	r2	=	textView.convertRect(r1, toView: nil)		//	To window of the view.
			let	r3	=	textView.window!.convertRectToScreen(r2)
			window!.setFrame(CGRect(x: r3.origin.x, y: r3.origin.y - 100, width: 300, height: 100), display: true)
			window!.makeKeyAndOrderFront(self)
			
			////
			
			let	ms	=	RacerExecutionController().resolve("std::vec::")
			candidateScrollViewController.candidateTableDocumentViewController.candidateItems	=	ms
		}
		func dismiss() {
			window!.orderOut(self)
		}
		func navigateUp() {
			let	tv1	=	candidateScrollViewController.candidateTableDocumentViewController.tableView
			let	i1	=	tv1.selectedRow
			if i1 > 0 {
				let	i2	=	i1 - 1
				tv1.selectRowIndexes(NSIndexSet(index: i2), byExtendingSelection: false)
				tv1.scrollRowToVisible(i2)
			}
		}
		func navigateDown() {
			let	tv1	=	candidateScrollViewController.candidateTableDocumentViewController.tableView
			let	i1	=	tv1.selectedRow
			if i1 < tv1.numberOfRows - 1 {
				let	i2	=	i1 + 1
				tv1.selectRowIndexes(NSIndexSet(index: i2), byExtendingSelection: false)
				tv1.scrollRowToVisible(i2)
			}
		}
		
		var candidateScrollViewController:CandidateScrollViewController {
			get {
				return	contentViewController as! CandidateScrollViewController
			}
		}
		
		override func instantiateContentViewController() -> NSViewController {
			return	RustAutocompletion.CandidateScrollViewController()
		}
		override func instantiateWindow() -> NSWindow {
			let	w1	=	Window()
			
			w1.backgroundColor				=	NSColor.clearColor()
			w1.opaque						=	false
			w1.styleMask					=	NSBorderlessWindowMask
	//		w1.becomesKeyOnlyIfNeeded		=	true
//			w1.floatingPanel				=	true
//			w1.worksWhenModal				=	false
	//		w1.movable						=	true
	//		w1.movableByWindowBackground	=	true
			return	w1
		}
		
		override func windowDidLoad() {
			super.windowDidLoad()
			self.window!.invalidateShadow()
		}
		
		override func complete(sender: AnyObject?) {
			dismiss()
		}
	}

	
	class Window: NSWindow {
		override var canBecomeKeyWindow:Bool {
			get {
				return	false
			}
		}
		override var acceptsFirstResponder:Bool {
			get {
				return	true
			}
		}
	}
	
	
	
	
	class CandidateScrollViewController: ScrollViewController2 {
		var candidateTableDocumentViewController:CandidateTableViewController {
			get {
				return	super.documentViewController as! CandidateTableViewController
			}
		}
		override func instantiateDocumentViewController() -> NSViewController {
			return	CandidateTableViewController()
		}
		override func viewDidLoad() {
			super.viewDidLoad()
			scrollView.wantsLayer				=	true
			scrollView.layer!.backgroundColor	=	NSColor.redColor().CGColor
			scrollView.layer!.cornerRadius		=	5
		}
	}
	
	
	class CandidateTableViewController: TableViewController {
		
		var candidateItems:[RacerExecutionController.Match] = [] {
			didSet {
				tableView.reloadData()
			}
		}
		
//		@availability(*,unavailable)
//		override var representedObject:AnyObject? {
//			didSet {
//			}
//		}
		
		override func viewDidLoad() {
			super.viewDidLoad()
			
			let	c1	=	NSTableColumn(identifier: "NAME", title: "Name", width: 100)
			let	c2	=	NSTableColumn(identifier: "TYPE", title: "Type", width: 100)
			tableView.addTableColumn(c1)
			tableView.addTableColumn(c2)
			tableView.columnAutoresizingStyle	=	NSTableViewColumnAutoresizingStyle.FirstColumnOnlyAutoresizingStyle
			tableView.headerView	=	nil
		}
		
		func numberOfRowsInTableView(tableView: NSTableView) -> Int {
			return	candidateItems.count
		}
		func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
			switch tableColumn!.identifier {
			case "NAME":	return	candidateItems[row].matchString
			case "TYPE":	return	candidateItems[row].mtype
			default:		fatalError()
			}
		}
	}
}


















