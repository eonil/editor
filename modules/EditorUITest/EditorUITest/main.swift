//
//  AppDelegate.swift
//  EditorUITest
//
//  Created by Hoon H. on 2015/11/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Cocoa


class AppDelegate: NSObject, NSApplicationDelegate {

	let	tester		=	Tester()

	func applicationDidFinishLaunching(aNotification: NSNotification) {
	}

	func applicationWillTerminate(aNotification: NSNotification) {
	}


}



public class DummyViewController: NSViewController {

	public override func loadView() {
		view		=	NSView()
	}

	public var backgroundColor: NSColor? {
		get {
			assert(view.layer != nil)
			if let color = view.layer?.backgroundColor {
				return	NSColor(CGColor: color)
			}
			return	nil
		}
		set {
			assert(view.layer != nil)
			view.layer?.backgroundColor	=	newValue?.CGColor
		}
	}
}








class Tester {

	let	window	=	NSWindow()
	let	splitVC	=	NSSplitViewController()
	let	vc1	=	DummyViewController()
	let	vc2	=	DummyViewController()

	init() {
		let	a	=	NSAppearance(named: NSAppearanceNameVibrantDark)
		NSAppearance.setCurrentAppearance(a)

		window.styleMask	|=	NSResizableWindowMask | NSClosableWindowMask
		window.orderFront(self)
		window.makeMainWindow()
		window.becomeKeyWindow()
		window.appearance	=	a
		window.setFrame(CGRect(x: 100, y: 100, width: 400, height: 400), display: false)



		splitVC.view.wantsLayer		=	true
		window.contentViewController	=	splitVC
		splitVC.splitViewItems		=	[
			NSSplitViewItem(sidebarWithViewController: vc1),
			NSSplitViewItem(viewController: vc2),
		]





		do {
			let	button	=	ScopeButton()
			button.frame	=	CGRect(x: 100, y: 100, width: 100, height: 100)
			button.title	=	"Sample Button"
			vc1.view.addSubview(button)
		}




//		func getP() -> NSParagraphStyle {
//			let	p	=	NSMutableParagraphStyle()
//			p.alignment	=	NSTextAlignment.Center
//			return	p
//		}
//
//
//	let	button	=	NSButton()
//		button.frame				=	CGRect(x: 100, y: 100, width: 200, height: 100)
//		button.attributedTitle			=	NSAttributedString(string: "AAA", attributes: [
//			NSForegroundColorAttributeName	:	NSColor.redColor(),
//			NSParagraphStyleAttributeName	:	getP(),
//			])
//		button.attributedAlternateTitle		=	NSAttributedString(string: "AAA", attributes: [
//			NSForegroundColorAttributeName	:	NSColor.blueColor(),
//			NSParagraphStyleAttributeName	:	getP(),
//			])
//		button.setButtonType(.PushOnPushOffButton)
//		button.font				=	NSFont.systemFontOfSize(NSFont.systemFontSizeForControlSize(.SmallControlSize))
//		button.alignment			=	NSTextAlignment.Center
//		button.showsBorderOnlyWhileMouseInside	=	true
//		button.highlight(true)
//		button.bezelStyle	=	.RecessedBezelStyle
////		button.setButtonType(.OnOffButton)
////		button.showsBorderOnlyWhileMouseInside	=	true
//////		button.highlight(true)
////		button.bezelStyle	=	.RoundedBezelStyle
//		window.contentView!.addSubview(button)
	}
}









let	app	=	NSApplication.sharedApplication()
let	del	=	AppDelegate()
app.delegate	=	del
app.run()