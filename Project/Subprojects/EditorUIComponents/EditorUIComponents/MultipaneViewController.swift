//
//  MultipaneView.swift
//  Editor
//
//  Created by Hoon H. on 2015/02/04.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit.NSView
import AppKitExtras





protocol MultipaneViewControllerDelegate: class {
	func multipaneViewController(MultipaneViewController, shouldSelectPaneAtIndex:Int)
	func multipaneViewController(MultipaneViewController, didSelectPaneAtIndex:Int)
	func multipaneViewController(MultipaneViewController, willHidePaneAtIndex:Int)
	func multipaneViewController(MultipaneViewController, didShowPaneAtIndex:Int)
}
final class MultipaneViewController: NSViewController {
	weak var delegate:MultipaneViewControllerDelegate?
	
	var	pages:[Page] = [] {
		willSet {
			for p in self.pages {
				assert(p.contentView.superview === self)
				p.contentView.removeFromSuperview()
			}
		}
		didSet {
			for p in self.pages {
				assert(p.contentView.superview === nil)
				self.view.addSubview(p.contentView)
			}
		}
	}
	
	////
	
	override func loadView() {
		super.view	=	NSView()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let	HEIGHT	=	40 as CGFloat
	
		self.view.addConstraintsWithLayoutAnchoring([
			_selectorShelfView.leftAnchor == self.view.leftAnchor,
			_selectorShelfView.rightAnchor == self.view.rightAnchor,
			_selectorShelfView.topAnchor == self.view.topAnchor,
			_selectorShelfView.bottomAnchor == self.view.bottomAnchor + CGSize(width: 0, height: HEIGHT),
			_contentHostingView.leftAnchor == self.view.leftAnchor,
			_contentHostingView.rightAnchor == self.view.rightAnchor,
			_contentHostingView.topAnchor == _selectorShelfView.bottomAnchor,
			_contentHostingView.bottomAnchor == self.view.bottomAnchor,
			])
		
	}
	override func viewWillLayout() {
		super.viewWillLayout()
	}
	
	////
	
	private let _selectorShelfView	=	ShelfView()
	private let _contentHostingView	=	NSView()
}
extension MultipaneViewController {
	struct Page {
		var	icon:NSImage
		var	label:String
		var	contentView:NSView
	}
}






