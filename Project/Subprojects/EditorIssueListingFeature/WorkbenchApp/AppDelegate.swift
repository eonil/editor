//
//  AppDelegate.swift
//  WorkbenchApp
//
//  Created by Hoon H. on 2015/01/18.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import EditorToolComponents
import EditorIssueListingFeature



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
	
	let	sv	=	NSScrollView()
	let	vc	=	IssueListingViewController()
	
	var	t	=	nil as NSTimer?
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		self.window!.appearance	=	NSAppearance(named: NSAppearanceNameVibrantDark)
		
		sv.hasHorizontalScroller	=	true
		sv.hasVerticalScroller		=	true
		
		window.contentView	=	sv
		sv.documentView		=	vc.view
		
		vc.push(makeTestDataset())
		
		t	=	NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "test1:", userInfo: nil, repeats: true)
	}
	
	@objc
	func test1(AnyObject?) {
		dispatch_async(dispatch_get_main_queue()) {
			self.vc.push(makeTestDataset())
			println("pushed")
		}
	}
}




func makeTestDataset() -> [Issue] {
	var	ss	=	[] as [Issue]
	for i in 0..<2 {
		let	t	=	NSDate().description
		let	u	=	NSURL(string: "sample://file/")!.URLByAppendingPathComponent(t)
		let	o	=	IssueOrigin(URL: u, range: CodeRange(startPoint: CodePoint(lineNumber: 1, columnNumber: 2), endPoint: CodePoint(lineNumber: 3, columnNumber: 4)))
		for j in 0..<2 {
			let	m	=	"\(i) x \(j)"
			let	s	=	Issue(origination: o, severity: randomServerity(), message: t)
			ss.append(s)
		}
	}
	return	ss
}

private func randomServerity() -> Issue.Severity {
	switch rand() % 3 {
	case 0:		return	Issue.Severity.Error
	case 1:		return	Issue.Severity.Information
	case 2:		return	Issue.Severity.Warning
	default:	fatalError()
	}
}



