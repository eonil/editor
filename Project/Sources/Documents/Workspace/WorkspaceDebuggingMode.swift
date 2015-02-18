//
//  WorkspaceDebuggingMode.swift
//  Editor
//
//  Created by Hoon H. on 2015/02/18.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper





protocol WorkspaceDebuggingModeDelegate: class {
	func workspaceDebuggingModeWillSwitchState(sender:WorkspaceDebuggingMode)
	func workspaceDebuggingModeDidSwitchState(sender:WorkspaceDebuggingMode)
}



///	This object executes the target when it is being initialised.
///	So initial state becomes `Executing`.
///
class WorkspaceDebuggingMode: WorkspaceMode {
	weak var delegate:WorkspaceDebuggingModeDelegate! {
		willSet {
			assert(self.delegate == nil, "You cannot reset once assigned delegate.")
		}
	}
	
	init(targetExecutablePath:String) {
		_debugger.createTargetWithFilename(targetExecutablePath)
	}
	deinit {
	}
	var state:State {
		get {
			return	_state
		}
	}
	
	func stepOver() {
		
	}
	func stepInto() {
		
	}
	func stepOut() {
		
	}
	func `continue`() {
		
	}
	func pause() {
		
	}
	func stop() {
		
	}
	
	
	
	
	private var	_state:State	=	State.Executing
	private let _debugger		=	LLDBDebugger()
}


extension WorkspaceDebuggingMode {
	enum State {
		case Executing
		case Inspecting
	}
}