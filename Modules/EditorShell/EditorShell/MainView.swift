//
//  MainView.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/06/13.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import SignalGraph

class MainView: NSView {
	
	///	You MUST set this BEFORE adding this view to a window
	///	and should not change until this view to be removed from the window.
	weak var palette: UIPalette? {
		willSet {
			assert(_installed == false)
		}
		didSet {
			
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
	
	private let	_paneSwMon	=	SignalMonitor<ValueSignal<Bool>>()
	private var	_installed	=	false
	
	private func _install() {
		assert(_installed == false)
		_deckView.configuration	=	TrinityDeckView.Configuration(
			dividerOrientation: 	TrinityDeckView.DividerOrientation.Vertical,
			firstPane: 		TrinityDeckView.Configuration.Pane(minimumLength: 30, onOpen: {}, onClose: {}),
			middlePane: 		TrinityDeckView.Configuration.Pane(minimumLength: 30, onOpen: {}, onClose: {}),
			lastPane: 		TrinityDeckView.Configuration.Pane(minimumLength: 30, onOpen: {}, onClose: {}))

		addSubview(_deckView)
		_layout()
		_installed	=	true
	}
	private func _deinstall() {
		assert(_installed == true)
		_deckView.removeFromSuperview()
		_installed	=	false
	}
	
	private func _connect() {
//		assert(palette != nil)
//		_paneSwMon.handler	=	{ [weak self] s in
//			
//		}
	}
	private func _disconnect() {
//		assert(palette != nil)
//		_paneSwMon.handler	=	{ _ in }
	}
	
	private func _layout() {
		_deckView.frame		=	bounds
	}
	
	private func _onPaneSwitchChange(s: ValueSignal<Bool>) {
//		switch s {
//		case .Initiation(let s):
//		case .Transition(let s):
//		case .Termination(let s):
//		}
	}
	
	///
	
	private let	_deckView	=	TrinityDeckView()
}

