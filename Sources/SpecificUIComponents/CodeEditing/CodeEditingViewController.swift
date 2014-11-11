//
//  CodeEditingViewController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/11/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

class CodeEditingViewController : TextScrollViewController {
	
	
	var	pathRepresentation:String? {
		get {
			return	self.representedObject as String?
		}
		set(v) {
			self.representedObject	=	v
		}
	}
	override var representedObject:AnyObject? {
		willSet(v) {
			precondition(v == nil || v! is String)
		}
		didSet {
			if let p2 = pathRepresentation {
				_openFileAtPath(p2)
			} else {
				_closeFile()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.textViewController.textView.font	=	Palette.current.codeFont
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
	
	
	
	
	private func _openFileAtPath(path:String) {
		assert(NSFileManager.defaultManager().fileExistsAtPath(path))
		
		var	e1	=	nil as NSError?
		let	s1	=	NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: &e1)
		if let s2 = s1 {
			self.textViewController.textView.editable	=	true
			self.textViewController.textView.string		=	s2
		} else {
			self.textViewController.textView.editable	=	false
			self.textViewController.textView.string		=	e1!.localizedDescription
		}
	}
	private func _closeFile() {
		self.textViewController.textView.string	=	nil
	}
}













