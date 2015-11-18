//
//  ShellProgramExecutionTask.swift
//  Editor
//
//  Created by Hoon H. on 2015/11/18.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import Cocoa

/// This object is one time use only.
/// Anyway, you can execute multiple commands on the shell.
///
class ShellProgramExecutionTask {

	enum State {
		case None
		case Running
		case Done
	}

	enum Event {
		/// None -> Running
		case Launch
		/// Running -> Done
		case Exit
	}






	private(set) var state: State = .None
	var onEvent: (Event->())?

















	private func _launch() {

	}
}






