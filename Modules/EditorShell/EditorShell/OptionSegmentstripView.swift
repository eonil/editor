//
//  OptionSegmentstripView.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/06/13.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import SignalGraph

class OptionSegmentstripView: NSView {

	struct Configuration {
		var	selectionMode	:	SelectionMode
		var	optionSegments	:	[OptionSegment]
	}
	
	enum SelectionMode {
		case None
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
		println(_segmentV.frame)
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
	
	private let	_segmentV	=	CustomizableTextSegmentedControl()
	private let	_segmantAgent	=	OBJCAgent()
	private var	_installed	=	false

	private func _install() {
		assert(_installed == false)
		assert(configuration != nil)
		func resolveTrackingMode(f: SelectionMode) -> NSSegmentSwitchTracking {
			switch f {
			case .Any:	return	NSSegmentSwitchTracking.SelectAny
			case .One:	return	NSSegmentSwitchTracking.SelectOne
			case .None:	return	NSSegmentSwitchTracking.Momentary
			}
		}
		let	c		=	configuration!.optionSegments.count
		_segmentV.segmentCount	=	c
		_segmentV.trackingMode	=	resolveTrackingMode(configuration!.selectionMode)
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
		
		sizeToFit()
		println(_segmentV.frame)
	}
	private func _disconnect() {
		assert(_installed == true)
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
	
	private func _notifyUserSegmentClicking() {
		let	lastSelIdx	=	_segmentV.selectedSegment
		if lastSelIdx == -1 {
			return
		}
		let	selState	=	_segmentV.isSelectedForSegment(lastSelIdx)
		if selState {
			configuration!.optionSegments[lastSelIdx].select()
		} else {
			configuration!.optionSegments[lastSelIdx].deselect()
		}
	}
}





class OptionSegment {
	init() {
	}
	deinit {
		assert(_connected == false)
	}
	
	var textState: ValueStorage<String?> {
		get {
			return	_txtch
		}
	}
	var selectionState: ValueStorage<Bool> {
		get {
			return	_selch
		}
	}
	
	func resetText(s: String?) {
		_txtch.state	=	s
	}
	func select() {
		_selch.state	=	true
	}
	func deselect() {
		_selch.state	=	false
	}
	
	///
	
	private weak var	_owner		:	OptionSegmentstripView?
	private var		_index		:	Int?
	
	private let		_txtch		=	EditableValueStorage<String?>(nil)
	private let		_txtmon		=	SignalMonitor<ValueSignal<String?>>()
	
	private let		_selch		=	EditableValueStorage<Bool>(false)
	private let		_selmon		=	SignalMonitor<ValueSignal<Bool>>()
	
	private var		_connected	=	false
	
	private func _connect() {
		_txtmon.handler	=	{ [weak self] in self!._onTextSignal($0) }
		_selmon.handler	=	{ [weak self] in self!._onSelectionSignal($0) }
		_txtch.emitter.register(_txtmon)
		_selch.emitter.register(_selmon)
		_connected	=	true
	}
	private func _disconnect() {
		_txtch.emitter.deregister(_txtmon)
		_selch.emitter.deregister(_selmon)
		_txtmon.handler	=	{ _ in }
		_selmon.handler	=	{ _ in }
		_connected	=	false
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
		println(resolve())
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
		_owner!._segmentV.setSelected(resolve(), forSegment: _index!)
	}
}





@objc
class OBJCAgent: NSObject {
	weak var owner: OptionSegmentstripView?
	
	@objc
	func Editor_onUserDidClickSegment(AnyObject?) {
		owner!._notifyUserSegmentClicking()
	}
}







