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
				let	selState	=	_segmentV.isSelectedForSegment(newSelIdx)
				if selState {
					configuration!.optionSegments[newSelIdx].selection.state	=	true
//					configuration!.optionSegments[newSelIdx].select()
				} else {
					configuration!.optionSegments[newSelIdx].selection.state	=	false
//					configuration!.optionSegments[newSelIdx].deselect()
				}
			}
			
		case .One:
			if newSelIdx != _pastSelIdx {
				if let idx = _pastSelIdx {
					configuration!.optionSegments[idx].selection.state		=	false
//					configuration!.optionSegments[idx].deselect()
				}
				if let idx = newSelIdx {
					configuration!.optionSegments[idx].selection.state		=	true
//					configuration!.optionSegments[idx].select()
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
	
	let	text		=	EditableValueStorage<String?>(nil)
	let	selection	=	EditableValueStorage<Bool>(false)
	
//	func resetText(s: String?) {
//		text.state	=	s
//	}
//	func select() {
//		selection.state	=	true
//	}
//	func deselect() {
//		selection.state	=	false
//	}
	
	///
	
	private weak var	_owner		:	OptionSegmentstripPiece?
	private var		_index		:	Int?
	
	private let		_txtmon		=	MonitoringValueStorage<String?>()
	private let		_selmon		=	MonitoringValueStorage<Bool>()
	
	private var		_connected	=	false
	
	private func _connect() {
		_txtmon.didApplySignal		=	{ [weak self] in self!._onTextSignal($0) }
		_selmon.didApplySignal		=	{ [weak self] in self!._onSelectionSignal($0) }
		text.emitter.register(_txtmon.sensor)
		selection.emitter.register(_selmon.sensor)
		_connected			=	true
	}
	private func _disconnect() {
		text.emitter.deregister(_txtmon.sensor)
		selection.emitter.deregister(_selmon.sensor)
		_txtmon.didApplySignal		=	nil
		_selmon.didApplySignal		=	nil
		_connected			=	false
	}
	private func _onTextSignal(s: ValueSignal<String?>) {
		assert(_owner != nil)
		assert(_index != nil)
		func resolve() -> String {
			switch s {
			case .Initiation(let s):	return	s() ?? ""
			case .Transition(let s):	return	s() ?? ""
			case .Termination(let s):	return	s() ?? ""
			}
		}
		_owner!._segmentV.setLabel(resolve(), forSegment: _index!)
	}
	private func _onSelectionSignal(s: ValueSignal<Bool>) {
		assert(_owner != nil)
		assert(_index != nil)
		func resolve() -> Bool {
			switch s {
			case .Initiation(let s):	return	s()
			case .Transition(let s):	return	s()
			case .Termination(let s):	return	false
			}
		}
		println("\(self) \(ObjectIdentifier(self).uintValue) \(resolve())")
		_owner!._segmentV.setSelected(resolve(), forSegment: _index!)
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







