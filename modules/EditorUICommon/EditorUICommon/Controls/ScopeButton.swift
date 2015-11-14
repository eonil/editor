//
//  ScopeButton.swift
//  EditorUICommon
//
//  Created by Hoon H. on 2015/11/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit





public class ScopeButton: CommonView {





	public var title: String? {
		didSet {
			_applyStateChanges()
		}
	}
	public var titleFont: NSFont = NSFont.systemFontOfSize(NSFont.systemFontSize()) {
		didSet {
			_applyStateChanges()
		}
	}
	/// Default is `false`.
	public var selected: Bool {
		get {
			return	_state.selected
		}
		set {
			_state.selected	=	newValue
			_applyStateChanges()
		}
	}

	public var onClick: (()->())?
	public var onShouldChangeSelectionStateByUserClick: (()->Bool)?











	///

	public override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()
		if window != nil {
			_install()
			_applyStateChanges()
		}
	}
	public override func viewWillMoveToWindow(newWindow: NSWindow?) {
		if window != nil {
			_deinstall()
		}
		super.viewWillMoveToWindow(newWindow)
	}
	public override func resizeSubviewsWithOldSize(oldSize: NSSize) {
		super.resizeSubviewsWithOldSize(oldSize)
		_applyStateChanges()
	}
	public override func sizeThatFits(size: CGSize) -> CGSize {
		guard let title = title else {
			return	size
		}
		let	f	=	_measureRectOfText(title, _textAttributes(NSColor.clearColor()))
		let	f1	=	(-_PADDING).insetRect(f)
		return	f1.size.ceil
	}
	public override func drawRect(dirtyRect: NSRect) {
		_draw()
	}


	public override func mouseEntered(theEvent: NSEvent) {
		super.mouseEntered(theEvent)
		_state.mouseHovering	=	true
		_applyStateChanges()
	}
	public override func mouseExited(theEvent: NSEvent) {
		super.mouseExited(theEvent)
		_state.mouseHovering	=	false
		_applyStateChanges()
	}
	public override func mouseDown(theEvent: NSEvent) {
		super.mouseDown(theEvent)
		_state.mouseGrabbing	=	true
		_applyStateChanges()
	}
	public override func mouseUp(theEvent: NSEvent) {
		super.mouseUp(theEvent)
		_state.mouseGrabbing	=	false
		if _state.mouseHovering {
			guard (onShouldChangeSelectionStateByUserClick?() ?? true) == true else {
				return
			}
			selected	=	selected == false
			onClick?()
		}
		_applyStateChanges()
	}














	///

	private struct _State {
		var selected		=	false
		var mouseHovering	=	false
		var mouseGrabbing	=	false
	}

	private var _state	=	_State()
	private var _visibleTA	:	NSTrackingArea?

	private func _install() {
		needsDisplay	=	true
		_visibleTA	=	NSTrackingArea(rect: visibleRect, options: [.MouseEnteredAndExited, .ActiveInKeyWindow, .InVisibleRect], owner: self, userInfo: nil)
		addTrackingArea(_visibleTA!)
	}
	private func _deinstall() {
		removeTrackingArea(_visibleTA!)
		_visibleTA	=	nil
	}



	private func _applyStateChanges() {
		needsDisplay	=	true
	}








	private func _draw() {
		enum RenderingState {
			case AsMouseHoveringWhileSelected
			case AsMouseHoveringWhileUnselected
			case AsSelected
			case AsUnselected
		}

		func determineRenderingState() -> RenderingState {
			if _state.mouseGrabbing {
				switch (_state.mouseHovering, _state.selected) {
				case (true, _):	return	.AsMouseHoveringWhileSelected
				case (false, true):	return	.AsMouseHoveringWhileSelected
				case (false, false):	return	.AsMouseHoveringWhileUnselected
				}
			}
			else {
				switch (_state.mouseHovering, _state.selected) {
				case (true, true):	return	.AsMouseHoveringWhileSelected
				case (true, false):	return	.AsMouseHoveringWhileUnselected
				case (false, true):	return	.AsSelected
				case (false, false):	return	.AsUnselected
				}
			}
		}



		///

		func fillRoundBox(c: NSColor) {
			let	f	=	CGRectInset(bounds, 0, 0)
			let	p	=	NSBezierPath(roundedRect: f, xRadius: _CORNER_RADIUS, yRadius: _CORNER_RADIUS)
			c.setFill()
			p.fill()
		}
		func strokeRoundBox(c: NSColor) {
			let	f	=	CGRectInset(bounds, 0.5, 0.5)
			let	p	=	NSBezierPath(roundedRect: f, xRadius: _CORNER_RADIUS, yRadius: _CORNER_RADIUS)
			p.lineWidth	=	1
			c.setStroke()
			p.stroke()
		}
		func drawTitle(c: NSColor) {
			guard let title = title else {
				return
			}

			let	aa		=	_textAttributes(c)
			let	dim		=	_measureRectOfText(title, aa)
			let	box		=	CGRect(x: bounds.midX - (dim.width / 2), y: bounds.midY - (dim.height / 2), width: dim.width, height: dim.height)
			(title as NSString).drawInRect(box, withAttributes: aa)
		}
		func useShadow(c: NSColor) {
			layer!.shadowColor	=	c.CGColor
			layer!.shadowOpacity	=	0.5
			layer!.shadowRadius	=	1
			layer!.shadowOffset	=	CGSize.zero
		}
		func unuseShadow() {
			layer!.shadowColor	=	NSColor.clearColor().CGColor
			layer!.shadowOpacity	=	0
			layer!.shadowRadius	=	0
			layer!.shadowOffset	=	CGSize.zero
		}







		
		///

		switch determineRenderingState() {
			case .AsMouseHoveringWhileSelected: do {
				fillRoundBox(NSColor.controlLightHighlightColor())
				drawTitle(NSColor.selectedControlTextColor())
				useShadow(NSColor.selectedControlTextColor())
			}
			case .AsMouseHoveringWhileUnselected: do {
				strokeRoundBox(NSColor.controlTextColor())
				drawTitle(NSColor.controlTextColor())
				unuseShadow()
			}
			case .AsSelected: do {
				drawTitle(NSColor.controlHighlightColor())
				useShadow(NSColor.controlColor())
			}
			case .AsUnselected: do {
				drawTitle(NSColor.controlTextColor())
				unuseShadow()
			}
		}
	}

	private func _textAttributes(c: NSColor) -> [String: AnyObject] {
		let	para		=	NSMutableParagraphStyle()
		para.alignment		=	NSTextAlignment.Center
		return	[
			NSFontAttributeName		:	titleFont,
			NSForegroundColorAttributeName	:	c,
			NSParagraphStyleAttributeName	:	para,
			] as [String: AnyObject]
	}
	private func _measureRectOfText(text: String, _ attributes: [String: AnyObject]) -> CGRect {
		return	text.boundingRectWithSize(bounds.size, options: [], attributes: attributes)
	}
}











private let	_CORNER_RADIUS	=	CGFloat(4)
private let	_PADDING	=	NSEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
