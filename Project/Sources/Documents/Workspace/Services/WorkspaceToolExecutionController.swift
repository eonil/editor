//
//  WorkspaceToolExecutionController.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/18.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import EonilDispatch
import EditorToolComponents


protocol WorkspaceToolExecutionControllerDelegate: class {
	func workspaceToolExecutionControllerQueryWorkingDirectoryURL() -> NSURL
	func workspaceToolExecutionControllerDidDiscoverRustCompilerIssue(issue:RustCompilerIssue)
	func workspaceToolExecutionControllerDidDiscoverRustCompilerMessage(message:String)
	func workspaceToolExecutionControllerDidFinish()
}
class WorkspaceToolExecutionController {
	weak var delegate:WorkspaceToolExecutionControllerDelegate? {
		willSet {
			assert(delegate == nil, "Resetting delegate is not allowed by design.")
		}
	}
	
	init() {
	}
	func cancelAll() {
		if let c = cargo {
			c.kill()
			cargo	=	nil
		}
	}
//	func executeCargoRun() {
//		precondition(cargo == nil)
//		
//		cargo	=	CargoExecutionController()
//		cargo!.delegate	=	self
//		cargo!.launchRun(workingDirectoryURL: self.delegate!.workspaceToolExecutionControllerQueryWorkingDirectoryURL())
//	}
	func executeCargoBuild() {
		precondition(cargo == nil)
		
		cargo	=	CargoExecutionController()
		cargo!.delegate	=	self
		cargo!.launchBuild(workingDirectoryURL: self.delegate!.workspaceToolExecutionControllerQueryWorkingDirectoryURL())
	}
	func executeCargoClean() {
		precondition(cargo == nil)
		
		cargo	=	CargoExecutionController()
		cargo!.delegate	=	self
		cargo!.launchClean(workingDirectoryURL: self.delegate!.workspaceToolExecutionControllerQueryWorkingDirectoryURL())
	}
	
	////
	
	private var	cargo	=	nil as CargoExecutionController?
}



extension WorkspaceToolExecutionController: CargoExecutionControllerDelegate {
	func cargoExecutionControllerDidPrintMessage(s: String) {
		async(Queue.main) {
			self.delegate!.workspaceToolExecutionControllerDidDiscoverRustCompilerMessage(s)
		}
	}
	func cargoExecutionControllerDidDiscoverRustCompilationIssue(issue: RustCompilerIssue) {
		async(Queue.main) {
			self.delegate!.workspaceToolExecutionControllerDidDiscoverRustCompilerIssue(issue)
		}
	}
	func cargoExecutionControllerRemoteProcessDidTerminate() {
		async(Queue.main) {	
			self.cargo	=	nil
			self.delegate!.workspaceToolExecutionControllerDidFinish()
			()
		}
	}
}










