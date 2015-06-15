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
			assert(_connected == false)
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
	private var	_connected	=	false
	
	private func _install() {
		assert(_installed == false)
		_deck.configuration	=	TrinityDeckView.Configuration(
			dividerOrientation: 	TrinityDeckView.DividerOrientation.Vertical,
			firstPane: 		TrinityDeckView.Configuration.Pane(minimumLength: 30, onOpen: {}, onClose: {}),
			middlePane: 		TrinityDeckView.Configuration.Pane(minimumLength: 30, onOpen: {}, onClose: {}),
			lastPane: 		TrinityDeckView.Configuration.Pane(minimumLength: 30, onOpen: {}, onClose: {}))
		addSubview(_deck)
		
		_layout()
		_installed	=	true
	}
	private func _deinstall() {
		assert(_installed == true)
		_deck.removeFromSuperview()
		_installed	=	false
	}
	
	private func _connect() {
		assert(_connected == false)
		assert(palette != nil)
		_deck.firstPaneDisplay		=	palette!.navigatorPaneDisplay
		_deck.lastPaneDisplay		=	palette!.inspectorPaneDisplay
		_connected			=	true
	}
	private func _disconnect() {
		assert(_connected == true)
		assert(palette != nil)
		_deck.firstPaneDisplay		=	nil
		_deck.lastPaneDisplay		=	nil
		_connected			=	false
	}
	
	private func _layout() {
		_deck.frame		=	bounds
	}
	
	///
	
	private let	_deck		=	TrinityDeckPiece()
}

