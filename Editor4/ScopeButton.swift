//
//  ScopeButton.swift
//  EditorUICommon
//
//  Created by Hoon H. on 2015/11/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

final class ScopeButton: CommonView {
	var title: String? {
		didSet {
			_triggerRedrawing()
		}
	}
	var titleFont: NSFont = NSFont.systemFontOfSize(NSFont.systemFontSize()) {
		didSet {
			_triggerRedrawing()
		}
	}
	/// Default is `false`.
	var selected: Bool {
		get {
			return _state.selected
		}
		set {
			_state.selected = newValue
			_triggerRedrawing()
		}
	}
	var onClick: (()->())?
	var onShouldChangeSelectionStateByUserClick: (()->Bool)?


	// MARK: -
	override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()
		if window != nil {
			_install()
			_triggerRedrawing()
		}
	}
	override func viewWillMoveToWindow(newWindow: NSWindow?) {
		if window != nil {
			_deinstall()
		}
		super.viewWillMoveToWindow(newWindow)
	}
	override func resizeSubviewsWithOldSize(oldSize: NSSize) {
		super.resizeSubviewsWithOldSize(oldSize)
		_triggerRedrawing()
	}
	override func sizeThatFits(size: CGSize) -> CGSize {
		guard let title = title else {
			return	size
		}
		let f	= _measureRectOfText(title, _textAttributes(NSColor.clearColor()))
		let f1	= (-_PADDING).insetting(f)
		return f1.size.ceiling
	}
	override func drawRect(dirtyRect: NSRect) {
		_drawShapes()
	}
	override func mouseEntered(theEvent: NSEvent) {
		super.mouseEntered(theEvent)
		_state.mouseHovering = true
		_triggerRedrawing()
	}
	override func mouseExited(theEvent: NSEvent) {
		super.mouseExited(theEvent)
		_state.mouseHovering = false
		_triggerRedrawing()
	}
	override func mouseDown(theEvent: NSEvent) {
		super.mouseDown(theEvent)
		_state.mouseGrabbing = true
		_triggerRedrawing()
	}
	override func mouseUp(theEvent: NSEvent) {
		super.mouseUp(theEvent)
		_state.mouseGrabbing = false
		if _state.mouseHovering {
			guard (onShouldChangeSelectionStateByUserClick?() ?? true) == true else {
				return
			}
			selected = selected == false
			onClick?()
		}
		_triggerRedrawing()
	}

	// MARK: -
	private struct _State {
		var selected	  = false
		var mouseHovering = false
		var mouseGrabbing = false
	}

	private var _state	= _State()
	private var _visibleTA	: NSTrackingArea?

	// MARK: -
	private func _install() {
		_visibleTA	= NSTrackingArea(rect: visibleRect, options: [.MouseEnteredAndExited, .ActiveInKeyWindow, .InVisibleRect], owner: self, userInfo: nil)
		addTrackingArea(_visibleTA!)
		_triggerRedrawing()
	}
	private func _deinstall() {
		removeTrackingArea(_visibleTA!)
		_visibleTA	= nil
	}
	private func _triggerRedrawing() {
		setNeedsDisplay()
	}
	private func _drawShapes() {
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
				case (false, true):	return .AsMouseHoveringWhileSelected
				case (false, false):	return .AsMouseHoveringWhileUnselected
				}
			}
			else {
				switch (_state.mouseHovering, _state.selected) {
				case (true, true):	return .AsMouseHoveringWhileSelected
				case (true, false):	return .AsMouseHoveringWhileUnselected
				case (false, true):	return .AsSelected
				case (false, false):	return .AsUnselected
				}
			}
		}
		//
		func fillRoundBox(c: NSColor) {
			let	f	= CGRectInset(bounds, 0, 0)
			let	p	= NSBezierPath(roundedRect: f, xRadius: _CORNER_RADIUS, yRadius: _CORNER_RADIUS)
			c.setFill()
			p.fill()
		}
		func strokeRoundBox(c: NSColor) {
			let	f	= CGRectInset(bounds, 0.5, 0.5)
			let	p	= NSBezierPath(roundedRect: f, xRadius: _CORNER_RADIUS, yRadius: _CORNER_RADIUS)
			p.lineWidth	= 1
			c.setStroke()
			p.stroke()
		}
		func drawLabel(c: NSColor) {
			guard let title = title else {
				return
			}

			let	aa		= _textAttributes(c)
			let	dim		= _measureRectOfText(title, aa)
			let	box		= CGRect(x: bounds.midX - (dim.width / 2), y: bounds.midY - (dim.height / 2), width: dim.width, height: dim.height)
			(title as NSString).drawInRect(box, withAttributes: aa)
		}
		func useShadow(c: NSColor) {
			layer!.shadowColor	= c.CGColor
			layer!.shadowOpacity	= 0.5
			layer!.shadowRadius	= 1
			layer!.shadowOffset	= CGSize.zero
		}
		func unuseShadow() {
			layer!.shadowColor	= NSColor.clearColor().CGColor
			layer!.shadowOpacity	= 0
			layer!.shadowRadius	= 0
			layer!.shadowOffset	= CGSize.zero
		}
		//
		switch determineRenderingState() {
			case .AsMouseHoveringWhileSelected: do {
				fillRoundBox(NSColor.controlLightHighlightColor())
				drawLabel(NSColor.selectedControlTextColor())
				useShadow(NSColor.selectedControlTextColor())
			}
			case .AsMouseHoveringWhileUnselected: do {
				strokeRoundBox(NSColor.controlTextColor())
				drawLabel(NSColor.controlTextColor())
				unuseShadow()
			}
			case .AsSelected: do {
				drawLabel(NSColor.controlHighlightColor())
				useShadow(NSColor.controlColor())
			}
			case .AsUnselected: do {
				drawLabel(NSColor.controlTextColor())
				unuseShadow()
			}
		}
	}
	private func _textAttributes(c: NSColor) -> [String: AnyObject] {
		let para = NSMutableParagraphStyle()
		para.alignment = .Center
		return [
			NSFontAttributeName		: titleFont,
			NSForegroundColorAttributeName	: c,
			NSParagraphStyleAttributeName	: para,
			] as [String: AnyObject]
	}
	private func _measureRectOfText(text: String, _ attributes: [String: AnyObject]) -> CGRect {
		return text.boundingRectWithSize(bounds.size, options: [], attributes: attributes)
	}
}

private let _CORNER_RADIUS = CGFloat(4)
private let _PADDING = NSEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)






























