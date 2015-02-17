//
//  ScrollViewController2.swift
//  Editor
//
//  Created by Hoon H. on 12/21/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import Cocoa

///	`translatesAutoresizingMaskIntoConstraints` set to `false` implicitly.
class ScrollViewController2: EditorCommonViewController {
	private var	_documentViewController:NSViewController?
	
	func instantiateDocumentViewController() -> NSViewController {
		return	NSViewController()
	}
	func instantiateScrollView() -> NSScrollView {
		return	NSScrollView()
	}
	
	@availability(*,unavailable)
	final override func instantiateView() -> NSView {
		return	instantiateScrollView()
	}
	
	var documentViewController:NSViewController {
		get {
			assert(_documentViewController !== nil)
			
			return	_documentViewController!
		}
	}
	
	final var scrollView:NSScrollView {
		get {
			assert(self.viewLoaded == true)
			return	super.view as! NSScrollView
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		scrollView.hasVerticalScroller		=	true
		scrollView.hasHorizontalScroller	=	true
		
		scrollView.translatesAutoresizingMaskIntoConstraints	=	false		///	This shall benefit everyone in the universe...
		
		////
		
		assert(self.viewLoaded == true)
		if _documentViewController == nil {
			_documentViewController	=	instantiateDocumentViewController()
			scrollView.documentView	=	_documentViewController!.view
			self.addChildViewController(_documentViewController!)
		}
	}
}









