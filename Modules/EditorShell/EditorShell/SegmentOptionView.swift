////
////  SegmentOptionView.swift
////  EditorShell
////
////  Created by Hoon H. on 2015/06/13.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//
//class SegmentOptionView: NSView {
//	enum SelectionMode {
//		case None
//		case One
//		case Any
//	}
//	struct Option {
//		var	displayText	:	String
//		var	onSelect	:	()->()
//		var	onDeselect	:	()->()
//	}
//	struct Configuration {
//		var	selectionMode	:	SelectionMode
//		var	options		:	[Option]
//	}
//	
//	///
//	
//	deinit {
//		_deinstall()
//		assert(_installed == false)
//	}
//	
//	var configuration: Configuration? {
//		willSet {
//			if configuration != nil {
//				_disconnect()
//				_deinstall()
//			}
//		}
//		didSet {
//			if configuration != nil {
//				_install()
//				_connect()
//			}
//		}
//	}
//	
//	func selectionStateOfOptionAtIndex(index: Int) -> Bool {
//		return	_segmentView.isSelectedForSegment(index)
//	}
//	func selectOptionAtIndex(index: Int) {
//		assert(_segmentView.isSelectedForSegment(index) == false)
//		_segmentView.setSelected(true, forSegment: index)
//	}
//	func deselectOptionAtIndex(index: Int) {
//		assert(_segmentView.isSelectedForSegment(index) == true)
//		_segmentView.setSelected(false, forSegment: index)
//	}
//	
//	func sizeToFit() {
//		_segmentView.sizeToFit()
//		setFrameSize(_segmentView.frame.size)
//	}
//	
//	///
//	
//	private let	_segmentView		=	CustomizableTextSegmentedControl()
//	private let	_segmentAgent		=	_OBJCSegmentAgent()
//	
//	private var	_installed		=	false
//	private var	_lastSelectionStates	:	[Bool]?
//	
//	private func _install() {
//		assert(_installed == false)
//		func resolveTrackingMode(f: SelectionMode) -> NSSegmentSwitchTracking {
//			switch f {
//			case .Any:	return	NSSegmentSwitchTracking.SelectAny
//			case .One:	return	NSSegmentSwitchTracking.SelectOne
//			case .None:	return	NSSegmentSwitchTracking.Momentary
//			}
//		}
//		_segmentView.colors		=	(NSColor.blackColor(), NSColor.controlTextColor())
//		_segmentView.trackingMode	=	resolveTrackingMode(configuration!.selectionMode)
//		_segmentView.segmentCount	=	configuration!.options.count
//		for i in 0..<configuration!.options.count {
//			let	opt		=	configuration!.options[i]
//			_segmentView.setLabel(opt.displayText, forSegment: i)
//			_segmentView.setSelected(false, forSegment: i)
//		}
//		addSubview(_segmentView)
//		_lastSelectionStates		=	(0..<configuration!.options.count).map({ _ in return false })
//		_installed			=	true
//	}
//	private func _deinstall() {
//		assert(_installed == true)
//		_segmentView.removeFromSuperview()
//		_lastSelectionStates		=	nil
//		_installed			=	false
//	}
//	
//	private func _connect() {
//		_segmentView.target		=	_segmentAgent
//		_segmentView.action		=	"Editor_segmentedControlOnValueChanged:"
//		_segmentAgent.owner		=	self
//	}
//	private func _disconnect() {
//		_segmentAgent.owner		=	nil
//		_segmentView.target		=	nil
//		_segmentView.action		=	nil
//	}
//	
//	private func _layout() {
//		_segmentView.frame		=	bounds
//	}
//	
//	private func _notifySelectionChange() {
//		let	sidx			=	_segmentView.selectedSegment
//		if sidx == -1 {
//			fatalError()
//		}
//		let	oldSelectionState	=	_lastSelectionStates![sidx]
//		let	newSelectionState	=	_segmentView.isSelectedForSegment(sidx)
//		if oldSelectionState != newSelectionState {
//			_lastSelectionStates![sidx]	=	newSelectionState
//			let	handler			= 	newSelectionState
//							?	configuration!.options[sidx].onSelect
//							:	configuration!.options[sidx].onDeselect
//			
//			handler()
//		}
//	}
//}
//
//private class _OBJCSegmentAgent: NSObject {
//	weak var owner: SegmentOptionView?
//	@objc
//	func Editor_segmentedControlOnValueChanged(AnyObject?) {
//		owner!._notifySelectionChange()
//	}
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
