//
//  main.swift
//  Editor
//
//  Created by Hoon H. on 2015/11/07.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

autoreleasepool {
	let	applicationDelegate			=	AppDelegate()
	NSApplication.sharedApplication().delegate	=	applicationDelegate
	NSApplication.sharedApplication().run()
}