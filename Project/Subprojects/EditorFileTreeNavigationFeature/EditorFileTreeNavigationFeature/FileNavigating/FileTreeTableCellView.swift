//
//  FileTreeTableCellView.swift
//  EditorFileTreeNavigationFeature
//
//  Created by Hoon H. on 2015/01/14.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit


@objc
final class FileTableCellView: NSTableCellView, NSTextFieldDelegate {
	weak var editingDelegate:FileTableCellEditingDelegate?
	
	convenience init() {
		self.init(frame: CGRect.zeroRect)
	}
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		configure()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
//	@objc
//	override var acceptsFirstResponder:Bool {
//		get {
//			return	false
//		}
//	}
//	override func becomeFirstResponder() -> Bool {
//		///	This must be designated manually if this object accepts first-responder.
//		self.window!.makeFirstResponder(self.textField!)
//		return	super.becomeFirstResponder()
//	}
//	override func resignFirstResponder() -> Bool {
//		return	super.resignFirstResponder()
//	}
	
	////
	
	private func configure() {
		let	tv1	=	FileTableCellTextField()
		let	iv1	=	NSImageView()
		self.textField	=	tv1
		self.imageView	=	iv1
		self.addSubview(tv1)
		self.addSubview(iv1)
		
		tv1.owner		=	self
		tv1.delegate	=	self
	}

	var fileNodeValue:FileNode4? {
		get {
			return	self.objectValue as! FileNode4!
		}
		set(v) {
			self.objectValue	=	v
		}
	}
	
	override var objectValue:AnyObject? {
		get {
			return	super.objectValue
		}
		set(v) {
			super.objectValue	=	v
			self.textField!.objectValue	=	self.fileNodeValue?.link.lastPathComponent
		}
	}
}

///	This cancels editing when ESC key pressed.
///	Cancellation will be notified to delegate, but you cannot cancel the cancellation itself.
@objc
class FileTableCellTextField: NSTextField {
	private weak var owner:FileTableCellView!
	
	@objc
	override var acceptsFirstResponder:Bool {
		get {
			return	true
		}
	}
	@objc
	override func becomeFirstResponder() -> Bool {
		self.backgroundColor	=	NSColor.textBackgroundColor()
		owner.editingDelegate?.fileTableCellDidBecomeFirstResponder()
		return	super.becomeFirstResponder()
	}
	@objc
	override func resignFirstResponder() -> Bool {
		self.backgroundColor	=	NSColor.clearColor()
		owner.editingDelegate?.fileTableCellDidResignFirstResponder()
		return	super.resignFirstResponder()
	}
	
//	override func controlTextDidBeginEditing(obj: NSNotification) {
//		
//	}
//	override func controlTextDidEndEditing(obj: NSNotification) {
//		
//	}
	
	@objc
	override func cancelOperation(sender: AnyObject?) {
		owner.self.editingDelegate?.fileTableCellDidCancelEditing()
		
		//	Restore display state.
		self.objectValue	=	owner.fileNodeValue?.link.lastPathComponent
	}

	
}

protocol FileTableCellEditingDelegate: class {
	func fileTableCellDidBecomeFirstResponder()
	func fileTableCellDidResignFirstResponder()
	func fileTableCellDidCancelEditing()
}

