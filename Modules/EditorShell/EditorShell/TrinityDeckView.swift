//
//  TrinityDeckView.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/06/13.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

///	Splits view area into three panes.
///	You can put views to each panes.
///
///	This view supports only three panes to splify design and implementation.
///	You need to make your own view class if you need more than three panes.
///
///
///
///	Definitions
///	-----------
///
///	-	All panes are closed at first.
///	-	A pane can be closed by user-interaction or program command.
///	-	A pane can be open only by program command.
///
class TrinityDeckView: NSView {
	enum DividerOrientation {
		case Horizontal
		case Vertical
	}
	struct Configuration {
		struct Pane {
			var	minimumLength	:	CGFloat			//<	Must be larger than 0.
//			var	minimumLength	:	CGFloat			//<	Must be larger than 0. Also must be equal or smaller than `maximumLength`.
//			var	maximumLength	:	CGFloat			//<	Must be larger than 0. Also must be equal or large than `minimumLength`.
			
			var	onOpen		:	()->()
			var	onClose		:	()->()
		}
		
		var	dividerOrientation	:	DividerOrientation
		var	firstPane		:	Pane
		var	middlePane		:	Pane
		var	lastPane		:	Pane
	}
	
	///
	
	weak var delegate: TrinityDeckViewDelegate?
	
	///
	
	///	Re-setting configuration may trigger re-creation of whole view subtree.
	///	So that can be very expensive. Do this only when you need to.
	var configuration: Configuration? {
		willSet(v) {
			assert(v?.firstPane.minimumLength > 0.0)
			assert(v?.middlePane.minimumLength > 0.0)
			assert(v?.lastPane.minimumLength > 0.0)
//			assert(v?.firstPane.minimumLength <= v?.firstPane.maximumLength)
//			assert(v?.middlePane.minimumLength <= v?.middlePane.maximumLength)
//			assert(v?.lastPane.minimumLength <= v?.lastPane.maximumLength)
			if _installed {
				_disconnect()
				_deinstall()
				_install()
				_connect()
			}
		}
	}
	
	func isFirstPaneOpen() -> Bool {
		return	_splitView.isSubviewCollapsed(_firstPaneView) == false
	}
	func isLastPaneOpen() -> Bool {
		return	_splitView.isSubviewCollapsed(_lastPaneView) == false
	}
	
	func openFirstPane() {
		_openFirstPane()
	}
	func openLastPane() {
		_openLastPane()
	}
	
	func closeFirstPane() {
		_closeFirstPane()
	}
	func closeLastPane() {
		_closeLastPane()
	}
	
	///
	
	override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()
		if window != nil {
			_install()
			_connect()
		}
	}
	override func viewWillMoveToWindow(newWindow: NSWindow?) {
		super.viewWillMoveToWindow(newWindow)
		if window != nil {
			_disconnect()
			_deinstall()
		}
	}
	override func didAddSubview(subview: NSView) {
		super.didAddSubview(subview)
	}
	override func willRemoveSubview(subview: NSView) {
		super.willRemoveSubview(subview)
	}
	override func resizeSubviewsWithOldSize(oldSize: NSSize) {
		super.resizeSubviewsWithOldSize(oldSize)
		_layout()
	}
	
	///
	
	private let	_splitView	=	NSSplitView()
	private let	_splitAgent	=	_OBJCSplitViewAgent()
	
	private let	_firstPaneView	=	NSView()
	private let	_middlePaneView	=	NSView()
	private let	_lastPaneView	=	NSView()
	
	private var	_installed	=	false
	private var	_firstPaneLen	:	CGFloat?
	private var	_lastPaneLen	:	CGFloat?
	
	private func _install() {
		_assertConfigurationExistence()
		addSubview(_splitView)
		_splitView.vertical		=	configuration!.dividerOrientation == .Vertical
		_splitView.dividerStyle		=	NSSplitViewDividerStyle.Thin
		for v in _allPaneViews() {
			assert(v.superview === nil)
			v.wantsLayer			=	true
			v.layer!.backgroundColor	=	NSColor(hue: (CGFloat(random()) / CGFloat(RAND_MAX)), saturation: 0.5, brightness: 0.5, alpha: 1).CGColor
			_splitView.translatesAutoresizingMaskIntoConstraints	=	false
			_splitView.addSubview(v)
		}
		
		_firstPaneLen	=	configuration!.firstPane.minimumLength
		_lastPaneLen	=	configuration!.lastPane.minimumLength
		
		_layout()
		_installed	=	true
	}
	private func _deinstall() {
		_assertConfigurationExistence()
		for v in _allPaneViews() {
			if v.superview != nil {
				assert(v.superview === _splitView)
				v.removeFromSuperview()
			}
		}
		
		_firstPaneLen	=	nil
		_lastPaneLen	=	nil
		
		_installed	=	false
	}
	
	private func _connect() {
		_splitAgent.owner	=	self
		_splitView.delegate	=	_splitAgent
	}
	private func _disconnect() {
		_splitView.delegate	=	_splitAgent
		_splitAgent.owner	=	nil
	}
	
	private func _layout() {
		_splitView.frame	=	bounds
//		_splitView.setPosition(configuration!.firstPane.minimumLength, ofDividerAtIndex: 0)
//		_splitView.setPosition(configuration!.lastPane.minimumLength, ofDividerAtIndex: 1)
	}
	
	private func _allPaneViews() -> [NSView] {
		return	[_firstPaneView, _middlePaneView, _lastPaneView]
	}
	private func _allMinimumLengths() -> [CGFloat] {
		return	[configuration!.firstPane.minimumLength, configuration!.middlePane.minimumLength, configuration!.lastPane.minimumLength]
	}
	
	private func _assertConfigurationExistence() {
		assert(configuration != nil, "You MUST set a proper value to `configuration` property BEFORE this view to be added to an `NSWindow`.")
	}
	
	private func _notifyDividerMovementByUserInteraction() {
		if isFirstPaneOpen() && _firstPaneView.frame.lengthForSplitAxis(_splitView) > 0 {
			_firstPaneLen	=	_firstPaneView.frame.lengthForSplitAxis(_splitView)
		}
		if isLastPaneOpen() && _lastPaneView.frame.lengthForSplitAxis(_splitView) > 0 {
			_lastPaneLen	=	_lastPaneView.frame.lengthForSplitAxis(_splitView)
		}
		delegate?.trinityDeckViewOnUserDidDividerInteraction()
	}
	
	private func _openFirstPane() {
		assert(isFirstPaneOpen() == false)
		let	p	=	_splitView.bounds.minForSplitAxis(_splitView) + _firstPaneLen!
		_splitView.setPosition(p, ofDividerAtIndex: 0)
		configuration!.firstPane.onOpen()
	}
	private func _openLastPane() {
		assert(isLastPaneOpen() == false)
		let	p	=	_splitView.bounds.maxForSplitAxis(_splitView) - _lastPaneLen!
		_splitView.setPosition(p, ofDividerAtIndex: 1)
		configuration!.lastPane.onOpen()
	}
	private func _closeFirstPane() {
		assert(isFirstPaneOpen() == true)
		let	p	=	_splitView.bounds.minForSplitAxis(_splitView)
		_splitView.setPosition(p, ofDividerAtIndex: 0)
	}
	private func _closeLastPane() {
		assert(isLastPaneOpen() == true)
		let	p	=	_splitView.bounds.maxForSplitAxis(_splitView)
		_splitView.setPosition(p, ofDividerAtIndex: 1)
	}
}



@objc
private class _OBJCSplitViewAgent: NSObject, NSSplitViewDelegate {
	weak var owner: TrinityDeckView?
	
	@objc
	private func splitView(splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
		let	pidx	=	dividerIndex
		if pidx < owner!._allPaneViews().count {
			let	view	=	owner!._allPaneViews()[pidx]
			if splitView.isSubviewCollapsed(view) {
				return	proposedMinimumPosition
			}
			let	len	=	owner!._allMinimumLengths()[pidx]
			let	pos	=	view.frame.minForSplitAxis(splitView) + len
			return	pos
		} else {
			return	proposedMinimumPosition
		}
		
		//		switch dividerIndex {
		//		case 0:		return	owner!._firstPaneView.frame.minForSplitAxis(splitView) + owner!.configuration!.firstPaneMinimumLength
		//		case 1:		return	owner!._middlePaneView.frame.minForSplitAxis(splitView) + owner!.configuration!.middlePaneMinimumLength
		//		default:	return	proposedMinimumPosition
		//		}
	}
	
	@objc
	private func splitView(splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
		let	pidx	=	dividerIndex + 1
		if   pidx < owner!._allPaneViews().count {
			let	view	=	owner!._allPaneViews()[pidx]
			if splitView.isSubviewCollapsed(view) {
				return	proposedMaximumPosition
			}
			let	len	=	owner!._allMinimumLengths()[pidx]
			let	pos	=	view.frame.maxForSplitAxis(splitView) - len
			return	pos
		} else {
			return	proposedMaximumPosition
		}
		
		//		switch dividerIndex {
		//		case 0:		return	owner!._middlePaneView.frame.maxForSplitAxis(splitView) - owner!.configuration!.middlePaneMinimumLength
		//		case 1:		return	owner!._lastPaneView.frame.maxForSplitAxis(splitView) - owner!.configuration!.lastPaneMinimumLength
		//		default:	return	proposedMaximumPosition
		//		}ss
	}
	
	@objc
	private func splitView(splitView: NSSplitView, shouldHideDividerAtIndex dividerIndex: Int) -> Bool {
		return	true
	}
	
	@objc
	private func splitView(splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
		return	subview != owner!._middlePaneView
	}
	
	@objc
	private func splitView(splitView: NSSplitView, shouldCollapseSubview subview: NSView, forDoubleClickOnDividerAtIndex dividerIndex: Int) -> Bool {
		//	Take care that the split view will ask for BOTH of view around the divider
		//	whether to collapse themselves.
		return	subview !== owner!._middlePaneView
	}
	
	@objc
	private func splitViewDidResizeSubviews(notification: NSNotification) {
		owner!._notifyDividerMovementByUserInteraction()
	}
}

protocol TrinityDeckViewDelegate: class {
	func trinityDeckViewOnUserDidDividerInteraction()
}











private extension CGRect {
	func lengthForSplitAxis(splitView: NSSplitView) -> CGFloat {
		return	splitView.vertical ? width : height
	}
	func minForSplitAxis(splitView: NSSplitView) -> CGFloat {
		return	splitView.vertical ? minX : minY
	}
	func maxForSplitAxis(splitView: NSSplitView) -> CGFloat {
		return	splitView.vertical ? maxX : maxY
	}
}


