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
class TrinityDeckPiece: NSView {
	typealias	Configuration		=	TrinityDeckView.Configuration
	
	let		firstPaneDisplay	=	ValueStorage<Bool>(false)
	let		lastPaneDisplay		=	ValueStorage<Bool>(false)
	
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
	private let	_firstPDMon	=	ValueMonitor<Bool>()
	private let	_lastPDMon	=	ValueMonitor<Bool>()
	
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

		_firstPDMon.didBegin		=	{ [weak self] in self!._onBeginFirstPaneDisplayState($0) }
		_firstPDMon.willEnd		=	{ [weak self] in self!._onEndFirstPaneDisplayState($0) }
		firstPaneDisplay.register(_firstPDMon)

		_lastPDMon.didBegin		=	{ [weak self] in self!._onBeginLastPaneDisplayState($0) }
		_lastPDMon.willEnd		=	{ [weak self] in self!._onEndLastPaneDisplayState($0) }
		lastPaneDisplay.register(_lastPDMon)

		_connected			=	true
	}
	private func _disconnect() {
		assert(configuration != nil)

		lastPaneDisplay.deregister(_lastPDMon)
		_lastPDMon.willEnd		=	nil
		_lastPDMon.didBegin		=	nil

		firstPaneDisplay.deregister(_firstPDMon)
		_firstPDMon.willEnd		=	nil
		_firstPDMon.didBegin		=	nil

		_connected			=	false
	}
	
	private func _layout() {
		_view.frame		=	bounds
	}

	private func _onBeginFirstPaneDisplayState(s: Bool) {
		if s {
			if _view.isFirstPaneOpen() == false {
				_view.openFirstPane()
			}
		} else {
			if _view.isFirstPaneOpen() == true {
				_view.closeFirstPane()
			}
		}
	}
	private func _onEndFirstPaneDisplayState(s: Bool) {
		if _view.isFirstPaneOpen() == true {
			_view.closeFirstPane()
		}
	}

	private func _onBeginLastPaneDisplayState(s: Bool) {
		if s {
			if _view.isLastPaneOpen() == false {
				_view.openLastPane()
			}
		} else {
			if _view.isLastPaneOpen() == true {
				_view.closeLastPane()
			}
		}
	}
	private func _onEndLastPaneDisplayState(s: Bool) {
		if _view.isLastPaneOpen() == true {
			_view.closeLastPane()
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
		weak var owner: TrinityDeckPiece?
		private func trinityDeckViewOnUserDidDividerInteraction() {
			owner!._notifyUserDividerInteraction()
		}
	}
}



