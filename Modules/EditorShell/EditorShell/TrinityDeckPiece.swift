////
////  SignalingTrinityDeckView.swift
////  EditorShell
////
////  Created by Hoon H. on 2015/06/13.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//import SignalGraph
//
//class TrinityDeckPiece: NSView {
//	typealias	Configuration	=	TrinityDeckView.Configuration
//	
//	weak var firstPaneDisplay: EditableValueStorage<Bool>? {
//		willSet {
//			assert(_connected == false)
//		}
//	}
//	weak var lastPaneDisplay: EditableValueStorage<Bool>? {
//		willSet {
//			assert(_connected == false)
//		}
//	}
//	
//	var configuration: Configuration? {
//		didSet {
//			_view.configuration	=	configuration
//		}
//	}
//	
//	override func viewDidMoveToWindow() {
//		super.viewDidMoveToWindow()
//		if window != nil {
//			_install()
//			_connect()
//		}
//	}
//	override func viewWillMoveToWindow(newWindow: NSWindow?) {
//		super.viewWillMoveToWindow(newWindow)
//		if window != nil {
//			_disconnect()
//			_deinstall()
//		}
//	}
//	override func resizeSubviewsWithOldSize(oldSize: NSSize) {
//		super.resizeSubviewsWithOldSize(oldSize)
//		_layout()
//	}
//	
//	///
//	
//	private let	_view		=	TrinityDeckView()
//	private let	_firstPDMon	=	SignalMonitor<ValueSignal<Bool>>()
//	private let	_lastPDMon	=	SignalMonitor<ValueSignal<Bool>>()
//	
//	private var	_connected	=	false
//	
//	private func _install() {
//		addSubview(_view)
//		_layout()
//	}
//	private func _deinstall() {
//		_view.removeFromSuperview()
//	}
//	
//	private func _connect() {
//		assert(firstPaneDisplay != nil)
//		assert(lastPaneDisplay != nil)
//		_firstPDMon.handler	=	{ [weak self] in self!._onFirstPaneDisplaySignal($0) }
//		firstPaneDisplay!.emitter.register(_firstPDMon)
//		_lastPDMon.handler	=	{ [weak self] in self!._onLastPaneDisplaySignal($0) }
//		lastPaneDisplay!.emitter.register(_lastPDMon)
//		_connected		=	true
//	}
//	private func _disconnect() {
//		assert(firstPaneDisplay != nil)
//		assert(lastPaneDisplay != nil)
//		firstPaneDisplay!.emitter.deregister(_firstPDMon)
//		_firstPDMon.handler	=	{ _ in }
//		lastPaneDisplay!.emitter.deregister(_lastPDMon)
//		_lastPDMon.handler	=	{ _ in }
//		_connected		=	false
//	}
//	
//	private func _layout() {
//		_view.frame		=	bounds
//	}
//	
//	private func _onFirstPaneDisplaySignal(s: ValueSignal<Bool>) {
//		if _getSnapshotOfValueSignal(postTerminationValue: false)(s) {
//			if _view.isFirstPaneOpen() == false {
//				_view.openFirstPane()
//			}
//		} else {
//			if _view.isFirstPaneOpen() == true {
//				_view.closeFirstPane()
//			}
//		}
//	}
//	private func _onLastPaneDisplaySignal(s: ValueSignal<Bool>) {
//		if _getSnapshotOfValueSignal(postTerminationValue: false)(s) {
//			if _view.isLastPaneOpen() == false {
//				_view.openLastPane()
//			}
//		} else {
//			if _view.isLastPaneOpen() == true {
//				_view.closeLastPane()
//			}
//		}
//	}
//	
//	private func _notifyUserDividerInteraction() {
//		if _view.isFirstPaneOpen() != firstPaneDisplay!.state {
//			firstPaneDisplay!.state	=	_view.isFirstPaneOpen()
//		}
//		if _view.isLastPaneOpen() != lastPaneDisplay!.state {
//			lastPaneDisplay!.state	=	_view.isLastPaneOpen()
//		}
//	}
//
//	///
//	
//	private class Agent: TrinityDeckViewDelegate {
//		weak var owner: TrinityDeckPiece?
//		private func trinityDeckViewOnUserDidDividerInteraction() {
//			owner!._notifyUserDividerInteraction()
//		}
//	}
//}
//
//private func _getSnapshotOfValueSignal(#postTerminationValue: Bool?)(_ s: ValueSignal<Bool>) -> Bool {
//	switch s {
//	case .Initiation(let s):	return	s()
//	case .Transition(let s):	return	s()
//	case .Termination(let s):	return	postTerminationValue ?? s()
//	}
//}
////private extension ValueSignal {
////	func snapshot() -> T {
////		switch self {
////		case .Initiation(let s):	return	s()
////		case .Transition(let s):	return	s()
////		case .Termination(let s):	return	s()
////		}
////	}
////}
//
//
