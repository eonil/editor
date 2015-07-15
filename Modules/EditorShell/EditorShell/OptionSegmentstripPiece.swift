//
//  OptionSegmentstripPiece.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/06/13.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import SignalGraph


///	Selection of each options are controlled by each `OptionSegment`
///	object.
class OptionSegmentstripPiece: NSView {

	struct Configuration {
		var	selectionMode	:	SelectionMode
		var	optionSegments	:	[OptionSegment]
	}
	
	enum SelectionMode {
//		case None
		case One
		case Any
	}
	
	///
	
	deinit {
		assert(_installed == false)
	}
	
	var configuration: Configuration? {
		willSet {
			if let _ = configuration {
				assert(_installed == true)
				_disconnect()
				_deinstall()
			}
		}
		didSet {
			if let _ = configuration {
				assert(_installed == false)
				//	`_connect` call must be done here to provide
				//	sizeToFit to work properly.
				//	
				//	Segment label will be set in `_connect` call
				//	because it will be connected via signal-graph.
				//	Anyway, `sizeToFit` will produce unexpected
				//	result without label. And this view must be
				//	sized correctly when it is being passed to a 
				//	toolbar item.
				_install()
				_connect()

			}
		}
	}
	func sizeToFit() {
		_segmentV.sizeToFit()
		setFrameSize(_segmentV.frame.size)
	}
	
	///
	
	override func viewWillMoveToWindow(newWindow: NSWindow?) {
		super.viewWillMoveToWindow(newWindow)
		if window != nil {
//			_disconnect()
		}
	}
	override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()
		if window != nil {
//			_connect()
		}
	}
	override func resizeSubviewsWithOldSize(oldSize: NSSize) {
		super.resizeSubviewsWithOldSize(oldSize)
		_layout()
	}
	
	///
	
//	private let	_selch		=	EditableArrayStorage<OptionSegment>([])
//	private let	_selmon		=	SignalMonitor<ArraySignal<OptionSegment>>()
	
	private let	_segmentV	=	CustomizableTextSegmentedControl()
	private let	_segmantAgent	=	OBJCAgent()
	private var	_installed	=	false
	private var	_pastSelIdx	:	Int?

	private func _install() {
		assert(_installed == false)
		assert(configuration != nil)
		func resolveTrackingMode(f: SelectionMode) -> NSSegmentSwitchTracking {
			switch f {
			case .Any:	return	NSSegmentSwitchTracking.SelectAny
			case .One:	return	NSSegmentSwitchTracking.SelectOne
//			case .None:	return	NSSegmentSwitchTracking.Momentary
			}
		}
		let	c		=	configuration!.optionSegments.count
		_segmentV.segmentCount	=	c
		_segmentV.trackingMode	=	resolveTrackingMode(configuration!.selectionMode)
		_segmentV.colors	=	configuration!.selectionMode == .Any ? (NSColor.blackColor(), NSColor.controlTextColor()) : nil
		_segmentV.colors	=	(NSColor.blackColor(), NSColor.controlTextColor())
		addSubview(_segmentV)
		_installed		=	true
	}
	private func _deinstall() {
		assert(_installed == true)
		assert(configuration != nil)
		_segmentV.removeFromSuperview()
		_segmentV.segmentCount	=	0
		_installed		=	false
	}
	
	private func _connect() {
		assert(_installed == true)
		_segmantAgent.owner	=	self
		_segmentV.target	=	_segmantAgent
		_segmentV.action	=	"Editor_onUserDidClickSegment:"
		let	c		=	configuration!.optionSegments.count
		for i in 0..<c {
			let	optseg	=	configuration!.optionSegments[i]
			assert(optseg._owner == nil)
			assert(optseg._index == nil)
			optseg._owner	=	self
			optseg._index	=	i
			optseg._connect()
		}
//		_selmon.handler		=	{ [weak self] in self!._onSelectionSignal($0) }
//		_selch.emitter.register(_selmon)
	}
	private func _disconnect() {
		assert(_installed == true)
//		_selch.emitter.deregister(_selmon)
//		_selmon.handler		=	{ _ in }
		let	c		=	configuration!.optionSegments.count
		for i in 0..<c {
			let	optseg	=	configuration!.optionSegments[i]
			assert(optseg._owner == self)
			assert(optseg._index == i)
			optseg._disconnect()
			optseg._owner	=	nil
			optseg._index	=	nil
		}
		_segmentV.target	=	nil
		_segmentV.action	=	nil
		_segmantAgent.owner	=	nil
	}
	
	private func _layout() {
		_segmentV.frame		=	bounds
	}
	
//	private func _onSelectionSignal(s: ArraySignal<OptionSegment>) {
////		for i in 0..<_segmentV.segmentCount {
////			_segmentV.setSelected(false, forSegment: i)
////		}
////		for opt in configuration!.optionSegments {
////			
////		}
////		for _selch.state
//	}
	private func _notifyUserSegmentClicking() {
		func getNewSelIdx() -> Int? {
			let	i	=	_segmentV.selectedSegment
			return	i == -1 ? nil : i
		}
		let	newSelIdx	=	getNewSelIdx()
		
		switch configuration!.selectionMode {
		case .Any:
			if let newSelIdx = newSelIdx {
				let	segment		=	configuration!.optionSegments[newSelIdx]
				let	oldSelState	=	segment.selection.state
				let	curSelState	=	_segmentV.isSelectedForSegment(newSelIdx)
				if curSelState != oldSelState {
					segment.selection.state	=	curSelState
					assert(segment.selection.state == curSelState)
				}
			}
			
		case .One:
			if newSelIdx != _pastSelIdx {
				if let idx = _pastSelIdx {
					configuration!.optionSegments[idx].selection.state	=	false
				}
				if let idx = newSelIdx {
					configuration!.optionSegments[idx].selection.state	=	true
				}
			}
			
		default:
			fatalError("Unsupported yet...")
		}
		
		_pastSelIdx	=	newSelIdx
	}
}





class OptionSegment {
	init() {
	}
	deinit {
		assert(_connected == false)
	}
	
	let	text		=	ValueStorage<String?>(nil)
	let	selection	=	ValueStorage<Bool>(false)
	
	///
	
	private weak var	_owner		:	OptionSegmentstripPiece?
	private var		_index		:	Int?
	
	private let		_txtmon		=	ValueMonitor<String?>()
	private let		_selmon		=	ValueMonitor<Bool>()
	
	private var		_connected	=	false
	
	private func _connect() {
		_txtmon.didBegin		=	{ [weak self] in self!._onBeginText($0) }
		_txtmon.willEnd			=	{ [weak self] in self!._onEndText($0) }
		_selmon.didBegin		=	{ [weak self] in self!._onBeginSelection($0) }
		_selmon.willEnd			=	{ [weak self] in self!._onEndSelection($0) }
		text.register(_txtmon)
		selection.register(_selmon)
		_connected			=	true
	}
	private func _disconnect() {
		text.deregister(_txtmon)
		selection.deregister(_selmon)
		_txtmon.willEnd			=	nil
		_txtmon.didBegin		=	nil
		_selmon.willEnd			=	nil
		_selmon.didBegin		=	nil
		_connected			=	false
	}
	private func _onBeginText(s: String?) {
		assert(_owner != nil)
		assert(_index != nil)
		_owner!._segmentV.setLabel(s ?? "", forSegment: _index!)
	}
	private func _onEndText(s: String?) {
		_owner!._segmentV.setLabel("", forSegment: _index!)
	}
	private func _onBeginSelection(s: Bool) {
		assert(_owner != nil)
		assert(_index != nil)
		let	sel	=	s
		if sel != _owner!._segmentV.isSelectedForSegment(_index!) {
			println("\(self) \(ObjectIdentifier(self).uintValue) \(resolve())")
			_owner!._segmentV.setSelected(sel, forSegment: _index!)
		}
	}
	private func _onEndSelection(s: Bool) {
		let	sel	=	false
		if sel != _owner!._segmentV.isSelectedForSegment(_index!) {
			println("\(self) \(ObjectIdentifier(self).uintValue) \(resolve())")
			_owner!._segmentV.setSelected(sel, forSegment: _index!)
		}
	}
}





@objc
class OBJCAgent: NSObject {
	weak var owner: OptionSegmentstripPiece?
	
	@objc
	func Editor_onUserDidClickSegment(AnyObject?) {
		owner!._notifyUserSegmentClicking()
	}
}







