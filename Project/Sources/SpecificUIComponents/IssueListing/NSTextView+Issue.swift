//
//  NSTextView+Issue.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/17.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorToolComponents






extension NSTextView {
	func highlightCodeRange(range:CodeRange) {
		var	rs1	=	[] as [NSRange]
		for i in range.startPoint.lineIndex...range.endPoint.lineIndex {
			let	r1	=	(self.string! as NSString).findNSRangeOfLineContentAtIndex(i)
			rs1.append(r1!)
		}
		self.selectedRanges	=	rs1
		self.scrollRangeToVisible(rs1[0])
	}
	func navigateToCodeRange(range:CodeRange) {
		let	r1	=	self.string!.findNSRangeOfLineContentAtIndex(range.startPoint.lineIndex)
		if let r2 = r1 {
			self.window!.makeFirstResponder(self)
			self.selectedRanges	=	[r1!]
			self.scrollRangeToVisible(r1!)
		} else {
		}
	}
}

