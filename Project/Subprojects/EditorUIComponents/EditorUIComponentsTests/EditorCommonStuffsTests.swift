//
//  EditorCommonStuffsTests.swift
//  EditorUIComponents
//
//  Created by Hoon H. on 2015/02/21.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import XCTest
import EditorUIComponents

class EditorCommonStuffsTests: XCTestCase {
	func testWindowController3() {
		class WC1: EditorCommonWindowController3 {
			var	windowDidLoadCallCount	=	0
			var	windowExistenceCount	=	0
			private override func windowDidLoad() {
				super.windowDidLoad()
				self.windowDidLoadCallCount++
				self.windowExistenceCount	+=	(self.window == nil ? 0 : 1)
			}
		}
		
		let	wc	=	WC1()
		XCTAssert(wc.windowDidLoadCallCount == 1)
		XCTAssert(wc.windowExistenceCount == 1)
	}
}