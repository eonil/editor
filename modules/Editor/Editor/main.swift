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
//	autoreleasepool {
//		@objc
//		class CustomColorMap: NSObject {
//			class func selectedControlTextColor() -> NSColor {
//				return	NSColor.redColor()
//			}
//		}
//
//		let	name	=	Selector("selectedControlTextColor")
//		let	method1	=	class_getClassMethod(NSColor.self, name)
//		let	method2	=	class_getClassMethod(CustomColorMap.self, name)
////		let	impl1	=	method_getImplementation(method1)
////		let	impl2	=	method_getImplementation(method2)
//		method_exchangeImplementations(method1, method2)
////		let	_	=	class_replaceMethod(NSColor.self, name, impl2, method_getTypeEncoding(method1))
//	}

	let	applicationDelegate			=	AppDelegate()
	NSApplication.sharedApplication().delegate	=	applicationDelegate
	NSApplication.sharedApplication().run()
}