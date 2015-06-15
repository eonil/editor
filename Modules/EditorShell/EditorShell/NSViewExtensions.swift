////
////  NSViewExtensions.swift
////  EditorShell
////
////  Created by Hoon H. on 2015/06/13.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//
////extension NSView {
////	convenience init<T>(_: T.Type) {
////		self.init()
////	}
////}
//
//protocol SimpleCustomViewHandler {
//	func install()
//	func deinstall()
//	func layout()
//}
//
//final class SimpleCustomView: NSView {
//	init<T: SimpleCustomViewHandler>(_ handler: T) {
//		_handler	=	handler
//		super.init(frame: NSRect.zeroRect)
//	}
//	@availability(*,unavailable)
//	required init?(coder: NSCoder) {
//	    fatalError("init(coder:) has not been implemented")
//	}
//	
//	override func viewDidMoveToWindow() {
//		super.viewDidMoveToWindow()
//		if window != nil {
//			_install()
//		}
//	}
//	override func viewWillMoveToWindow(newWindow: NSWindow?) {
//		super.viewWillMoveToWindow(newWindow)
//		if window != nil {
//			_deinstall()
//		}
//	}
//	override func resizeSubviewsWithOldSize(oldSize: NSSize) {
//		super.resizeSubviewsWithOldSize(oldSize)
//		_layout()
//	}
//	
//	///
//	
//	private let	_handler	:	SimpleCustomViewHandler
//	private var	_installed	=	false
//	
//	private func _install() {
//		_handler.install()
//		_installed	=	true
//	}
//	private func _deinstall() {
//		_handler.deinstall()
//		_installed	=	false
//	}
//	
//	private func _layout() {
//		_handler.layout()
//	}
//}
//
