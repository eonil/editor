//
//  AttributedStringTableCellView.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/02/03.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit






///	This class creates text-field and image-view itself.
///	You should not add or set them.
class AttributedStringTableCellView: NSTableCellView {
	override init() {
		super.init()
	}
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		_configureSubviews()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		_configureSubviews()
	}
	
	@availability(*,unavailable)
	final override var textField:NSTextField? {
		get {
			return	super.textField
		}
		set(v) {
			if v == nil {
				super.textField	=	v		//	This can be called by dealloc.
			} else {
				fatalError("You cannot change text-field object.")
			}
		}
	}
	
	var	attributedString:NSAttributedString? {
		get {
			return	self.objectValue as! NSAttributedString?
		}
		set(v) {
			self.objectValue	=	v
		}
	}
	
	@objc
	override var objectValue:AnyObject? {
		get {
			return	super.objectValue
		}
		set(v) {
			precondition(v == nil || v! is NSAttributedString)
			super.objectValue	=	v
			
			if let n = v as? NSAttributedString {
				_originText			=	n
//				_highlightText		=	Text(n).setTextColor(NSColor.selectedTextColor()).attributedString
				_highlightText		=	Text(n).setTextColor(NSColor.labelColor()).attributedString
			} else {
				_originText			=	NSAttributedString()
				_highlightText		=	NSAttributedString()
			}
		}
	}
	
	@objc
	override var backgroundStyle:NSBackgroundStyle {
		didSet {
			switch backgroundStyle {
			case .Dark:
				super.textField!.attributedStringValue	=	_highlightText
				
			case .Light:
				super.textField!.attributedStringValue	=	_originText
				
			default:
				fatalError("Unsupported constant `\(backgroundStyle.rawValue)`.")
			}
		}
	}
	
	////
	
	private var	_originText		=	NSAttributedString()
	private var	_highlightText	=	NSAttributedString()
	
	private func _configureSubviews() {
		let	tv	=	NSTextField()
		let	mv	=	NSImageView()
		
		addSubview(tv)
		addSubview(mv)
		
		super.textField	=	tv
		super.imageView	=	mv
		
		////
		
		tv.editable					=	false
		tv.bordered					=	false
		tv.bezeled					=	false
		tv.drawsBackground			=	false
		tv.backgroundColor			=	NSColor.clearColor()
		tv.translatesAutoresizingMaskIntoConstraints	=	false
		
		self.addConstraints([
			NSLayoutConstraint(item: tv, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: tv, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: tv, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: tv, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0),
			])
		
	}
}










extension AttributedStringTableCellView {
}













