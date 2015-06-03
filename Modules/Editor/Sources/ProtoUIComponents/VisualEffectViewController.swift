//
//  VisualEffectViewController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/11/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit

class VisualEffectViewController : NSViewController {
	
//	private	var	_localLayoutConstraints	=	[] as [NSLayoutConstraint]
	
	var	documentViewController:NSViewController? {
		willSet(v) {
			if let dc1 = documentViewController {
//				self.visualEffectView.layoutConstraints	=	[]
//				dc1.view.removeFromSuperview()
			}
			precondition(v?.view.translatesAutoresizingMaskIntoConstraints == false)
		}
		didSet {
			if let dc1 = documentViewController {
				self.visualEffectView.addSubview(dc1.view)
				assert(self.visualEffectView.layoutConstraints.count == 0)
				self.visualEffectView.layoutConstraints	=	[
					dc1.view..left == self.visualEffectView..left * 1 + 0,
					dc1.view..right == self.visualEffectView..right * 1 + 0,
					dc1.view..top == self.visualEffectView..top * 1 + 0,
					dc1.view..bottom == self.visualEffectView..bottom * 1 + 0,
				]
				
			}
		}
	}
	
	var	visualEffectView:NSVisualEffectView {
		get {
			return	self.view as! NSVisualEffectView
		}
		set(v) {
			self.view	=	v
		}
	}
	
	override var view:NSView {
		willSet(v) {
			precondition(v is NSVisualEffectView)
		}
	}
	
	override func loadView() {
		self.view	=	NSVisualEffectView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.visualEffectView.blendingMode	=	NSVisualEffectBlendingMode.BehindWindow
		self.visualEffectView.material		=	NSVisualEffectMaterial.AppearanceBased
		self.visualEffectView.state			=	NSVisualEffectState.Active
	}
	
//	override func viewDidLayout() {
//		super.viewDidLayout()
//		self.documentViewController?.view.frame	=	self.visualEffectView.bounds
//	}
}





