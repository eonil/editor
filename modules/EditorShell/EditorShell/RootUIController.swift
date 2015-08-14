////
////  RootUIController.swift
////  EditorShell
////
////  Created by Hoon H. on 2015/08/14.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//
//final class RootUIController {
//	init() {
//
//	}
//	deinit {
//
//	}
//
//	///
//
//	private let	_window			=	NSWindow()
//	private let	_windowController	:	NSWindowController
//
//	private let	_div			=	DivisionUIController()
//}
//
//
//
//
//
//private func _getInitialFrameForScreen(screen: NSScreen) -> CGRect {
//	let	sz	=	_getMinSize()
//	let	f	=	CGRect(origin: screen.frame.midPoint, size: CGSize.zeroSize)
//	let	insets	=	NSEdgeInsets(top: -sz.height/2, left: -sz.width/2, bottom: -sz.height/2, right: -sz.width/2)
//	let	f2	=	insets.insetRect(f)
//	return	f2
//}
//private func _getMinSize() -> CGSize {
//	return	CGSize(width: 400, height: 300)
//}