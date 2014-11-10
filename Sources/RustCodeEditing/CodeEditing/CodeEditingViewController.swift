//
//  CodeEditingViewController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/11/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

class CodeEditingViewController : TextScrollViewController {
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
}
