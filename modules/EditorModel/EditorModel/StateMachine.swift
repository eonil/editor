//
//  StateMachine.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/11/18.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

class Transition<State: Equatable, Event> {
	typealias	Rule	=	(from: State, to: State, event: Event)

	var onEvent: (Event->())?

	init(_ state: State, _ rules: [Rule] = []) {
		self.rules	=	rules
		self.state	=	state
	}

	var rules: [Rule]

	var state: State {
		willSet {
			assert({
				for t in rules {
					if t.from == state && t.to == newValue {
						return	true
					}
				}
				return	false
				}(), "Unsupported transition from `\(state)` to `\(newValue)`.")
		}
		didSet {
			if state != oldValue {
				for t in rules {
					if t.from == oldValue && t.to == state {
						onEvent?(t.event)
						return
					}
				}
				fatalError("Unsupported transition from `\(oldValue)` to `\(state)`.")
			}
		}
	}
}

extension Transition where Event: Equatable {
	func transit(event: Event) {
		for t in rules {
			if t.event == event && t.from == state {
				state	=	t.to
				return
			}
		}
		fatalError("Unsupported transition for event `\(event)`.")
	}
}











