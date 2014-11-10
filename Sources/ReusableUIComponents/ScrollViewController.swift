//
//  ScrollViewController.swift
//  RFC Formaliser
//
//  Created by Hoon H. on 10/27/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import Cocoa

class ScrollViewController: NSViewController {
	
	override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	final var documentViewController:NSViewController? = nil {
		willSet {
			if let dc1 = documentViewController {
				scrollView.documentView	=	nil
				self.removeChildViewController(dc1)
			}
		}
		didSet {
			if let dc1 = documentViewController {
				scrollView.documentView	=	dc1.view
				self.addChildViewController(dc1)
			}
		}
	}
	
	final var scrollView:NSScrollView {
		get {
			return	super.view as NSScrollView
		}
		set(v) {
			super.view	=	v
		}
	}
	
	override var view:NSView {
		willSet {
			fatalError("You cannot replace view of this object.")
		}
	}
	
	override init() {
		super.init()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func loadView() {
//		super.loadView()
		super.view							=	NSScrollView()
		
		scrollView.hasVerticalScroller		=	true
		scrollView.hasHorizontalScroller	=	true
		
	}
}