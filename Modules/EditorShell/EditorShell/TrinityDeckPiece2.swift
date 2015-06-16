//
//  SignalingTrinityDeckView.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/06/13.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import SignalGraph



///	**NOTE**	A piece must have a mutable state storage.
///			So it couldn't be simply replicating storage.
///
class TrinityDeckPiece2: NSView {
	typealias	Configuration	=	TrinityDeckView.Configuration
	
	let	firstPaneDisplay	=	EditableValueStorage<Bool>(false)
	let	lastPaneDisplay		=	EditableValueStorage<Bool>(false)
	
	var configuration: Configuration? {
		willSet {
			assert(_installed == false)
			assert(_connected == false)
		}
		didSet {
			_view.configuration	=	configuration
		}
	}
	
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
	override func resizeSubviewsWithOldSize(oldSize: NSSize) {
		super.resizeSubviewsWithOldSize(oldSize)
		_layout()
	}
	
	///
	
	private let	_view		=	TrinityDeckView()
	private let	_firstPDMon	=	MonitoringValueStorage<Bool>()
	private let	_lastPDMon	=	MonitoringValueStorage<Bool>()
	
	private var	_installed	=	false
	private var	_connected	=	false
	
	private func _install() {
		assert(configuration != nil)
		addSubview(_view)
		_layout()
		_installed	=	true
	}
	private func _deinstall() {
		assert(configuration != nil)
		_view.removeFromSuperview()
		_installed	=	false
	}
	
	private func _connect() {
		assert(configuration != nil)
		_firstPDMon.didApplySignal	=	{ [weak self] in self!._onFirstPaneDisplaySignal($0) }
		firstPaneDisplay.emitter.register(_firstPDMon.sensor)
		_lastPDMon.didApplySignal	=	{ [weak self] in self!._onLastPaneDisplaySignal($0) }
		lastPaneDisplay.emitter.register(_lastPDMon.sensor)
		_connected			=	true
	}
	private func _disconnect() {
		assert(configuration != nil)
		firstPaneDisplay.emitter.deregister(_firstPDMon.sensor)
		_firstPDMon.didApplySignal	=	{ _ in }
		lastPaneDisplay.emitter.deregister(_lastPDMon.sensor)
		_lastPDMon.didApplySignal	=	{ _ in }
		_connected			=	false
	}
	
	private func _layout() {
		_view.frame		=	bounds
	}
	
	private func _onFirstPaneDisplaySignal(s: ValueSignal<Bool>) {
		if _getSnapshotOfValueSignal(postTerminationValue: false)(s) {
			if _view.isFirstPaneOpen() == false {
				_view.openFirstPane()
			}
		} else {
			if _view.isFirstPaneOpen() == true {
				_view.closeFirstPane()
			}
		}
	}
	private func _onLastPaneDisplaySignal(s: ValueSignal<Bool>) {
		if _getSnapshotOfValueSignal(postTerminationValue: false)(s) {
			if _view.isLastPaneOpen() == false {
				_view.openLastPane()
			}
		} else {
			if _view.isLastPaneOpen() == true {
				_view.closeLastPane()
			}
		}
	}
	
	private func _notifyUserDividerInteraction() {
		if _view.isFirstPaneOpen() != firstPaneDisplay.state {
			firstPaneDisplay.state	=	_view.isFirstPaneOpen()
		}
		if _view.isLastPaneOpen() != lastPaneDisplay.state {
			lastPaneDisplay.state	=	_view.isLastPaneOpen()
		}
	}

	///
	
	private class Agent: TrinityDeckViewDelegate {
		weak var owner: TrinityDeckPiece2?
		private func trinityDeckViewOnUserDidDividerInteraction() {
			owner!._notifyUserDividerInteraction()
		}
	}
}

private func _getSnapshotOfValueSignal(#postTerminationValue: Bool?)(_ s: ValueSignal<Bool>) -> Bool {
	switch s {
	case .Initiation(let s):	return	s()
	case .Transition(let s):	return	s()
	case .Termination(let s):	return	postTerminationValue ?? s()
	}
}


