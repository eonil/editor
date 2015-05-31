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





//public protocol MultipaneViewControllerDelegate: class {
////	func multipaneViewController(MultipaneViewController, shouldSelectPaneAtIndex:Int)
////	func multipaneViewController(MultipaneViewController, didSelectPaneAtIndex:Int)
////	func multipaneViewController(MultipaneViewController, didHidePaneAtIndex:Int)
////	func multipaneViewController(MultipaneViewController, willShowPaneAtIndex:Int)
//}
public final class MultipaneViewController: NSViewController {
//	public weak var delegate:MultipaneViewControllerDelegate?
	
	public var pageSelectionIndex:Int? = nil {
		didSet {
			_currentPageViewController	=	pageSelectionIndex == nil ? nil : self.pages[pageSelectionIndex!].viewController
		}
	}
	public var pages:[Page] = [] {
		willSet {
			assert(pageSelectionIndex == nil, "You must set `pageSelectionIndex` to `nil` before removing selected page.")
			
			_selectorSegmentView.segmentCount	=	0
			_selectorSegmentView.sizeToFit()
			
			if self.pages.count == 0 {
				pageSelectionIndex	=	nil
			}
			for p in self.pages {
				assert(p.viewController.view.superview === self)
			}
		}
		didSet {
			for p in self.pages {
				assert(p.viewController.view.superview === nil)
				assert(p.viewController.view.translatesAutoresizingMaskIntoConstraints == false, "Page view MUST have `translatesAutoresizingMaskIntoConstraints` property set to `false`.")
			}
			
			_selectorSegmentView.segmentCount	=	pages.count
			for i in 0..<pages.count {
				let	p	=	pages[i]
				_selectorSegmentView.setLabel(p.labelText, forSegment: i)
			}
			_selectorSegmentView.sizeToFit()
		}
	}
	
	////
	
	public override func loadView() {
		super.view	=	NSView()
	}
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		_selectorSegmentView.controlSize	=	NSControlSize.SmallControlSize
		_selectorSegmentView.segmentStyle	=	NSSegmentStyle.Automatic
		_selectorSegmentView.font			=	NSFont.systemFontOfSize(NSFont.smallSystemFontSize())
		_selectorSegmentView.sizeToFit()
		let	h	=	_selectorSegmentView.frame.size.height
		
		_selectorStackView.edgeInsets		=	NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		_selectorStackView.setViews([_selectorSegmentView], inGravity: NSStackViewGravity.Center)
		
		_selectorSegmentView.translatesAutoresizingMaskIntoConstraints	=	false
		_selectorStackView.translatesAutoresizingMaskIntoConstraints	=	false
		_contentHostingView.translatesAutoresizingMaskIntoConstraints	=	false
		
		self.view.addSubview(_contentHostingView)
		self.view.addSubview(_selectorStackView)
		self.view.needsLayout	=	true
		
		self.view.addConstraintsWithLayoutAnchoring([
			_selectorStackView.centerXAnchor == self.view.centerXAnchor,
			_selectorStackView.topAnchor == self.view.topAnchor,
			
			_contentHostingView.leftAnchor == self.view.leftAnchor,
			_contentHostingView.rightAnchor == self.view.rightAnchor,
			_contentHostingView.topAnchor == _selectorStackView.bottomAnchor,
			_contentHostingView.bottomAnchor == self.view.bottomAnchor,
			])
		self.view.addConstraints([
			NSLayoutConstraint(item: _selectorSegmentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: h)
			])
		////
		
		_selectorSegmentView.sizeToFit()
		_subcomponentDelegate		=	SubcomponentDelegate(owner: self)
		_selectorSegmentView.target	=	_subcomponentDelegate
		_selectorSegmentView.action	=	"onPageSelectorValueChanged:"
	}
	
	////
	
	private let _selectorSegmentView	=	NSSegmentedControl()
	private let	_selectorStackView		=	NSStackView()
	private let _contentHostingView		=	NSView()
	
	private var	_subcomponentDelegate	=	nil as SubcomponentDelegate?
	private var	_selectionConstraints	=	nil as [NSLayoutConstraint]?
	
	
	
	private var _currentPageViewController:NSViewController? {
		willSet {
			if let vc = _currentPageViewController {
				_contentHostingView.removeConstraints(_selectionConstraints!)
				vc.view.removeFromSuperview()
				vc.removeFromParentViewController()
				_selectionConstraints	=	nil
			}
		}
		didSet {
			if let vc = _currentPageViewController {
				assert(vc.view.translatesAutoresizingMaskIntoConstraints == false, "Selected view MUST have `translatesAutoresizingMaskIntoConstraints` property set to `false`.")
				self.addChildViewController(vc)
				_contentHostingView.addSubview(vc.view)
				_selectionConstraints	=	_contentHostingView.addConstraintsWithLayoutAnchoring([
					vc.view.centerAnchor	==	_contentHostingView.centerAnchor,
					vc.view.sizeAnchor		==	_contentHostingView.sizeAnchor,
				])
			}
		}
	}
}









public extension MultipaneViewController {
	public struct Page {
//		public var	icon:NSImage
		public var	labelText:String
		public var	viewController:NSViewController
		
		public init(labelText:String, viewController:NSViewController) {
			self.labelText		=	labelText
			self.viewController	=	viewController
		}
	}
}










@objc
private final class SubcomponentDelegate: NSObject {
	unowned let owner:MultipaneViewController
	
	init(owner:MultipaneViewController) {
		self.owner	=	owner
	}
	
	@objc
	func onPageSelectorValueChanged(AnyObject?) {
		let	i	=	owner._selectorSegmentView.selectedSegment
		let	p	=	owner.pages[i]
		owner._currentPageViewController	=	p.viewController
	}
}






