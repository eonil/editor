//
//  TextViewController.swift
//  RFC Formaliser
//
//  Created by Hoon H. on 10/27/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import Cocoa

class TextViewController: NSViewController {
	var textView:NSTextView {
		get {
			return	view as NSTextView
		}
	}
	
	override var view:NSView {
		willSet {
			fatalError("You cannot replace `view` of this object.")
		}
	}
	
	override init() {
		super.init()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	override func loadView() {
		super.view	=	instantiateTextView()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		textView.autoresizingMask		=	NSAutoresizingMaskOptions.ViewWidthSizable
		textView.minSize				=	NSSize(width: 0, height: 0)
		textView.maxSize				=	NSSize(width: CGFloat.max, height: CGFloat.max)
		
		textView.verticallyResizable	=	true
		textView.horizontallyResizable	=	true
		
		textView.textContainer!.widthTracksTextView	=	false
		textView.textContainer!.containerSize		=	CGSize(width: CGFloat.max, height: CGFloat.max)
	}
}
extension TextViewController {
	///	Provides text-view instance for current controller.
	func instantiateTextView() -> NSTextView {
		let	v				=	NSTextView()
		v.backgroundColor	=	NSColor.textBackgroundColor()
		v.textColor			=	NSColor.textColor()
		return	v
	}
}





