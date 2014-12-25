//
//  TextEditingViewController.swift
//  Editor
//
//  Created by Hoon H. on 12/21/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit

class TextEditingViewController : TextScrollViewController {
	
	
	var	URLRepresentation:NSURL? {
		get {
			return	self.representedObject as NSURL?
		}
		set(v) {
			self.representedObject	=	v
		}
	}
	override var representedObject:AnyObject? {
		get {
			return	super.representedObject
		}
		set(v) {
			precondition(v == nil || v! is NSURL)
			
			//	Skip duplicated assignment.
			if v as NSURL? == super.representedObject as NSURL? {
				return
			}
			
			if let u1 = URLRepresentation {
				if _trySavingContentInPlace() {
				}
				_clearContent()
			}
			
			if let u1 = v as NSURL? {
				super.representedObject	=	v
				if _tryLoadingContentOfFileAtURL(u1) {
				} else {
					super.representedObject	=	nil
					return	//	Clear errorneous value.
				}
			}
		}
//		willSet(v) {
//			precondition(v == nil || v! is NSURL)
//			if let u1 = URLRepresentation {
//				precondition(u1.existingAsDataFile)	//	Do not set non-data-file to this editor.
//				_saveContentInPlace()
//				_clearContent()
//			}
//		}
//		didSet {
//			if let u1 = URLRepresentation {
//				_loadContentOfFileAtURL(u1)
//			}
//		}
	}
	
	
	
	
	
	func trySavingInPlace() -> Bool {
		return	_trySavingContentInPlace()
	}
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.textViewController.textView.font								=	Palette.current.codeFont
		self.textViewController.textView.continuousSpellCheckingEnabled		=	false
		self.textViewController.textView.automaticTextReplacementEnabled	=	false
		self.textViewController.textView.automaticQuoteSubstitutionEnabled	=	false
		self.textViewController.textView.allowsUndo							=	true
	}
	
	func highlightRangesOfIssues(ss:[Issue]) {
		var	rs1	=	[] as [NSRange]
		for s in ss {
			for i in s.range.start.line...s.range.end.line {
				let	r1	=	(textViewController.textView.string! as NSString).findNSRangeOfLineContentAtIndex(i)
				rs1.append(r1!)
			}
		}
		textViewController.textView.selectedRanges	=	rs1
		textViewController.textView.scrollRangeToVisible(rs1[0])
	}
	func navigateRangeOfIssue(s:Issue) {
		let	r1	=	textViewController.textView.string!.findNSRangeOfLineContentAtIndex(s.range.start.line)
		if let r2 = r1 {
			textViewController.textView.window!.makeFirstResponder(textViewController.textView)
			textViewController.textView.selectedRanges	=	[r1!]
			textViewController.textView.scrollRangeToVisible(r1!)
		} else {
		}
	}
}



	
	
	
	









///	MARK:

extension TextEditingViewController {
	
	///	I/O can fail at anytime.
	private func _tryLoadingContentOfFileAtURL(u:NSURL) -> Bool {
		assert(NSFileManager.defaultManager().fileExistsAtPath(u.path!))
		
		var	e1	=	nil as NSError?
		let	s1	=	NSString(contentsOfURL: u, encoding: NSUTF8StringEncoding, error: &e1)
		if let s2 = s1 {
			self.textViewController.textView.editable	=	true
			self.textViewController.textView.string		=	s2
			return	true
		} else {
			self.textViewController.textView.editable	=	false
			self.textViewController.textView.string		=	e1!.localizedDescription
			return	false
		}
	}
	
	///	I/O can fail at anytime.
	private func _trySavingContentInPlace() -> Bool {
		Debug.log(URLRepresentation)
		assert(URLRepresentation != nil)
		assert(NSFileManager.defaultManager().fileExistsAtPath(URLRepresentation!.path!))
		
		let	s1	=	self.textViewController.textView.string!
		var	e1	=	nil as NSError?
		let	ok1	=	s1.writeToURL(URLRepresentation!, atomically: true, encoding: NSUTF8StringEncoding, error: &e1)
		Debug.log("Text document saved.")
		
		if !ok1 {
			NSAlert(error: e1!).runModal()
		}
		
		return	ok1
	}
	private func _clearContent() {
		self.textViewController.textView.string		=	""
		self.textViewController.textView.editable	=	false
	}
}





























