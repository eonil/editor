//
//  EditorCommonViewController.swift
//  Editor
//
//  Created by Hoon H. on 12/23/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit



///
///	View is read-only. You cannot change it.
///	View will be created automatically at initialisation using `instantiate~` family methods.
///
@availability(*,deprecated=0)
class EditorCommonViewController: NSViewController {
	
	func instantiateView() -> NSView {
		return	NSView()
	}
	
	override var view:NSView {
		get {
			ensureViewReadiness()
			return	super.view
		}
		set(v) {
			fatalError("You cannot set `view` directly. Instead, override `instantiateView` method to customise view class.")
		}
	}
	
	///	You cannot call this methid directly.
	///	Override `instantiateView` method instead of.
	@availability(*,unavailable)
	override func loadView() {
		fatalError()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	
	private func ensureViewReadiness() {
		if viewLoaded == false {
			super.view	=	instantiateView()
			self.view.needsLayout	=	true
			self.view.layoutSubtreeIfNeeded()
			self.viewDidLoad()	//	Does not being called automatically. Need to call manually.
		}
		assert(viewLoaded)
	}
	
	
	
	override init() {
		super.init()
		ensureViewReadiness()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		ensureViewReadiness()
	}
//	@availability(*,unavailable)
	override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		ensureViewReadiness()
	}
}








