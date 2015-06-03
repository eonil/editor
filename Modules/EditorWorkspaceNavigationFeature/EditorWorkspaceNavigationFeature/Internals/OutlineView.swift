////
////  OutlineView.swift
////  EditorWorkspaceNavigationFeature
////
////  Created by Hoon H. on 2015/02/23.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//
//
//
//protocol OutlineViewEventDelegate: class {
//	func mouseDown(theEvent:NSEvent)
//	func mouseDragged(theEvent:NSEvent)
//	func mouseUp(theEvent:NSEvent)
//}
//
//
//
/////	You must set `eventDelegate` to non `nil` value.
//final class OutlineView: NSOutlineView {
//	weak var eventDelegate:OutlineViewEventDelegate?
//	
////	override func acceptsFirstMouse(theEvent: NSEvent) -> Bool {
////		return	true
////	}
////	
////	override func mouseDown(theEvent: NSEvent) {
////		super.mouseDown(theEvent)
////		self.eventDelegate!.mouseDown(theEvent)
////	}
////	override func mouseDragged(theEvent: NSEvent) {
////		super.mouseDragged(theEvent)
////		self.eventDelegate!.mouseDragged(theEvent)
////	}
////	override func mouseUp(theEvent: NSEvent) {
////		super.mouseUp(theEvent)
////		self.eventDelegate!.mouseUp(theEvent)
////	}
//}
//
//
//
//
