//
//  ViewController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/11/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit



@objc
public protocol DefaultInitialisable {
	init()
}

@objc
public class GenericViewController<V:NSView,D:NSCopying where V:DefaultInitialisable> : GeneralisableViewController {

	public override init() {
		super.init()
		self._hooks	=	GenericHooks(owner: self)
	}
	public override init?(coder: NSCoder) {
		super.init(coder: coder)
		self._hooks	=	GenericHooks(owner: self)
	}
	public override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self._hooks	=	GenericHooks(owner: self)
	}

	
	public var specificView:V {
		get {
			return	super.view as V
		}
		set(v) {
			super.view	=	v
		}
	}
	
	public var specificRepresentation:D? {
		get {
			return	super.representedObject as D?
		}
		set(v) {
			super.representedObject	=	v as NSCopying?
		}
	}
	
	
	
	public override func loadView() {
		super.view	=	V()
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		precondition(self.view is V)
	}
}







final private class GenericHooks<V:NSView,D:NSCopying where V:DefaultInitialisable> : Hooks {
	unowned let	owner:GenericViewController<V,D>
	init(owner:GenericViewController<V,D>) {
		self.owner	=	owner
	}
	private override func onViewWillSet(v: NSView) {
		precondition(v is V)
	}
	private override func onSettingRepresentedObject(o: AnyObject?) {
		precondition(o is D?)
	}
}
private class Hooks {
	func onViewWillSet(NSView) {
	}
	func onSettingRepresentedObject(o:AnyObject?) {
	}
}













public class GeneralisableViewController : NSViewController {
	private var	_hooks	=	nil as Hooks?
	
	public override var view:NSView {
		get {
			return	super.view
		}
		set(v) {
			_hooks?.onViewWillSet(v)
			super.view	=	v
		}
	}
	public override var representedObject:AnyObject? {
		get {
			return	super.representedObject
		}
		set(v) {
			_hooks?.onSettingRepresentedObject(v)
			super.representedObject	=	v
		}
	}
	
}




