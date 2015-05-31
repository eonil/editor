//
//  AppDelegate.swift
//  WorkbenchForIconPreview
//
//  Created by Hoon H. on 2015/02/21.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import EditorUIComponents







@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


	func applicationDidFinishLaunching(aNotification: NSNotification) {		
//		let	ch	=	UnicodeScalar(0xf06a)
//		let	f	=	NSFont(name: "FontAwesome", size: 128)!
//		let	m	=	IconUtility.vectorIconForCharacter(ch, font: f)
		
		let	mv	=	NSImageView()
		
		mv.image					=	IconPalette.FontAwesome.WebApplicationIcons.exclamationCircle.image
		mv.wantsLayer				=	true
		mv.layer!.backgroundColor	=	NSColor.brownColor().CGColor
		window.contentView			=	mv
	}
}









