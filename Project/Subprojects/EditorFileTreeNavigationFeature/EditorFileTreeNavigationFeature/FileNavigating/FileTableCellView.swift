//
//  FileTableCellView.swift
//  EditorFileTreeNavigationFeature
//
//  Created by Hoon H. on 2015/01/14.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

@objc
class FileTableCellView: NSTableCellView {
	@objc
	override var acceptsFirstResponder:Bool {
		get {
			return	true
		}
	}
	@objc
	override func becomeFirstResponder() -> Bool {
		return	true
	}
}

///	This cancels editing when ESC key pressed.
///	Cancellation will be notified to delegate, but you cannot cancel the cancellation itself.
@objc
class FileTableCellTextField: NSTextField {
	weak var editingDelegate:FileTableCellTextFieldEditingDelegate?
	
	@objc
	override var acceptsFirstResponder:Bool {
		get {
			return	true
		}
	}
	@objc
	override func becomeFirstResponder() -> Bool {
		self.backgroundColor	=	NSColor.textBackgroundColor()
		editingDelegate?.fileTableCellTextFieldDidBecomeFirstResponder()
		return	true
	}
	@objc
	override func resignFirstResponder() -> Bool {
		self.backgroundColor	=	NSColor.clearColor()
		editingDelegate?.fileTableCellTextFieldDidResignFirstResponder()
		return	true
	}
	
	@objc
	override func cancelOperation(sender: AnyObject?) {
		self.editingDelegate?.fileTableCellTextFieldDidCancelEditing()
		self.window!.makeFirstResponder(nil)
	}
}

protocol FileTableCellTextFieldEditingDelegate: class {
	func fileTableCellTextFieldDidBecomeFirstResponder()
	func fileTableCellTextFieldDidResignFirstResponder()
	func fileTableCellTextFieldDidCancelEditing()
}

