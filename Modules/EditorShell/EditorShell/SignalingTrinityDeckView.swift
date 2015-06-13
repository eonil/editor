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

class SignalingTrinityDeckView: NSView {
	typealias	Configuration	=	TrinityDeckView.Configuration
	typealias	Channel		=	(emitter: SignalEmitter<Bool>, sensor: SignalSensor<Bool>)
	
//	var paneVisibilitySwitch: (firstPane: Channel, lastPane: Channel) {
//		get {
//			
//		}
//	}
	
	///
	
	private let	_firstPaneChannel	=	PaneSwitchChannel()
	private let	_lastPaneChannel	=	PaneSwitchChannel()
	
	private func _connect() {
//		_firstPaneChannel.monitor.handler	=	{
//			
//		}
	}
}

private struct PaneSwitchChannel {
	let	monitor		=	SignalMonitor<ValueSignal<Bool>>()
	let	dispatcher	=	SignalDispatcher<ValueSignal<Bool>>()
}
