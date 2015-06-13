//
//  SegmentOptionViewForMainWidnowPaneDisplay.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/06/13.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import SignalGraph

class SegmentOptionViewForMainWidnowPaneDisplay: SegmentOptionView {
	
	weak var palette: UIPalette? {
		willSet {
			
		}
	}
	
	///
	
	private func _install() {
		configuration	=	SegmentOptionView.Configuration(selectionMode: SegmentOptionView.SelectionMode.Any, options: [
			SegmentOptionView.Option(displayText: "Navigation", onSelect: {}, onDeselect: {}),
			SegmentOptionView.Option(displayText: "Editor", onSelect: {}, onDeselect: {}),
			SegmentOptionView.Option(displayText: "Inspector", onSelect: {}, onDeselect: {}),
			])
	}
	private func _deinstall() {
		configuration	=	nil
	}
	
	private func _connect() {
		
	}
	private func _disconnect() {
		
	}
	
	private func _onInspectorPaneDisplaySignal(s: ValueSignal<Bool>) {
		func process(s: Bool) {
			let	oldState	=	selectionStateOfOptionAtIndex(2)
			let	newState	=	s
			if oldState != newState {
				if newState {
					selectOptionAtIndex(2)
				} else {
					deselectOptionAtIndex(2)
				}
			}
		}
		switch s {
		case .Initiation(let s):	process(s())
		case .Transition(let s):	process(s())
		case .Termination(let s):	break
		}
	}
}