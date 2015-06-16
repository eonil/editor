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
	
	weak var model: Palette? {
		willSet {
			if model != nil {
				_disconnect()
			}
		}
		didSet {
			if model != nil {
				_connect()
			}
		}
	}
	
	override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()
		if window != nil {
			_install()
		}
	}
	override func viewWillMoveToWindow(newWindow: NSWindow?) {
		super.viewWillMoveToWindow(newWindow)
		if window != nil {
			_deinstall()
		}
	}
	override func resizeSubviewsWithOldSize(oldSize: NSSize) {
		super.resizeSubviewsWithOldSize(oldSize)
		_layout()
	}
	
	///
	
	private let	_deck		=	TrinityDeckPiece2()
	private let	_navPDSync	=	EditableValueStorageSynchronizer<Bool>()
	private let	_inspPDSync	=	EditableValueStorageSynchronizer<Bool>()
	private var	_installed	=	false
	private var	_connected	=	false
	
	private func _install() {
		assert(_installed == false)
		_deck.configuration	=	TrinityDeckView.Configuration(
			dividerOrientation: 	TrinityDeckView.DividerOrientation.Vertical,
			firstPane: 		TrinityDeckView.Configuration.Pane(minimumLength: 30),
			middlePane: 		TrinityDeckView.Configuration.Pane(minimumLength: 30),
			lastPane: 		TrinityDeckView.Configuration.Pane(minimumLength: 30))
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
		assert(model != nil)
		_navPDSync.pair			=	(model!.navigatorPaneDisplay, _deck.firstPaneDisplay)
		_inspPDSync.pair		=	(model!.inspectorPaneDisplay, _deck.lastPaneDisplay)
		_connected			=	true
	}
	private func _disconnect() {
		assert(_connected == true)
		assert(model != nil)
		_navPDSync.pair			=	nil
		_inspPDSync.pair		=	nil
		_connected			=	false
	}
	
	private func _layout() {
		_deck.frame		=	bounds
	}
}

