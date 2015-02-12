//
//  ShelfViewTests.swift
//  EditorUIComponents
//
//  Created by Hoon H. on 2015/02/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import EditorUIComponents
import XCTest

class ShelfViewTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testEmptyShelf() {
		let	e	=	expectationWithDescription("Empty Shelf")
		let	v	=	ShelfView()
		let	w	=	makeTestFrameWindowForView(v)
		
		runSteppingsInMainThread([
			{
				v.sizeToFit()
			},
			{
				println(v.frame)
				XCTAssert(v.frame.size == CGSize.zeroSize)
			},
			{
				e.fulfill()
			},
			])
		waitForExpectationsWithTimeout(1, handler: nil)
	}
	
	func testSingleSubview() {
		let	e	=	expectationWithDescription("Single Subview")
		let	v	=	ShelfView()
		let	w	=	makeTestFrameWindowForView(v)
		
		let	v1		=	NSButton()
		v1.image	=	NSImage(named: NSImageNameUser)
		println(v1.intrinsicContentSize)
		XCTAssert(v1.intrinsicContentSize != CGSize.zeroSize)
		v.addSubview(v1)
		
		
		runSteppingsInMainThread([
			{
				v.sizeToFit()
			},
			{
				println(v.frame)
				XCTAssert(v.frame.size != CGSize.zeroSize)
				XCTAssert(v.frame.size == v1.intrinsicContentSize)
			},
			{
				e.fulfill()
			},
			])
		waitForExpectationsWithTimeout(1, handler: nil)
	}
	
	func testMultipleSubview() {
		let	e	=	expectationWithDescription("Multiple Subview")
		let	v	=	ShelfView()
		let	w	=	makeTestFrameWindowForView(v)
		
		let	v1		=	NSButton()
		let	v2		=	NSButton()
		let	v3		=	NSButton()
		v1.image	=	NSImage(named: NSImageNameUser)
		v2.image	=	NSImage(named: NSImageNameUser)
		v3.image	=	NSImage(named: NSImageNameUser)
		XCTAssert(v1.intrinsicContentSize != CGSize.zeroSize)
		XCTAssert(v2.intrinsicContentSize != CGSize.zeroSize)
		XCTAssert(v3.intrinsicContentSize != CGSize.zeroSize)
		v.addSubview(v1)
		v.addSubview(v2)
		v.addSubview(v3)
		
		runSteppingsInMainThread([
			{
				v.sizeToFit()
			},
			{
				let	w	=	v1.intrinsicContentSize.width + v2.intrinsicContentSize.width + v3.intrinsicContentSize.width
				let	h	=	v1.intrinsicContentSize.height
				XCTAssert(v.frame.size == CGSize(width: w, height: h))
			},
			{
				e.fulfill()
			},
			])
		waitForExpectationsWithTimeout(1, handler: nil)
	}
}












private func makeTestFrameWindowForView(view:NSView) -> NSWindow {
	let	w	=	NSWindow()
	w.setFrame(CGRect(x: 0, y: 0, width: 100, height: 100), display: true)
	w.orderFront(nil)
	
	let	v1	=	NSView()
	w.contentView	=	v1
	v1.addSubview(view)
	
	return	w
}
