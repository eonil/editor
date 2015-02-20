//
//  WorkspaceCommandExecutionController.swift
//  Editor
//
//  Created by Hoon H. on 2015/02/20.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import EditorToolComponents
import EditorDebuggingFeature
import EonilDispatch


///	MARK:
///	MARK:	WorkspaceCommandExecutionController

///	A serial execution command queue.
final class WorkspaceCommandExecutionController: WorkspaceCommandDelegate {
	deinit {
		_commands	=	[]
	}
	
	func queue(command:WorkspaceCommand) {
		_commands.append(command)
	}
	func runAllCommandExecution() {
		stepCommandExecution()
	}
	func cancelAllCommandExecution() {
		_current?.cancel()
		_current?.delegate	=	nil
		_current	=	nil
	}
	
	private func stepCommandExecution() {
		precondition(_commands.count > 0)
		
		_current			=	_commands.removeAtIndex(0)
		_current!.delegate	=	self
		_current!.launch()
	}
	final func workspaceCommandWillStart(command: WorkspaceCommand) {
//		assert(_current! === command)
	}
	final func workspaceCommandDidFinish(command: WorkspaceCommand) {
//		assert(_current! === command)
		
		if _commands.count > 0 {
			stepCommandExecution()
		}
	}
	
	private var	_commands	=	[] as [WorkspaceCommand]
	private var _current	=	nil as WorkspaceCommand?
}




protocol WorkspaceCommandDelegate: class {
	func workspaceCommandWillStart(command:WorkspaceCommand)
	func workspaceCommandDidFinish(command:WorkspaceCommand)
	
//	optional func CommandWillCancel(command:Command)
//	optional func CommandDidCancel(command:Command)
}

///	A cancellable asynchronous command.
protocol WorkspaceCommand {
	weak var delegate:WorkspaceCommandDelegate? { get set }
	func launch()
	func cancel()
}









final class CargoCommand: WorkspaceCommand, CargoExecutionControllerDelegate {
	weak var delegate:WorkspaceCommandDelegate?
	
	enum Subcommand {
		case Clean
		case Build
	}
//	struct Configuration {
//		let	workspaceRootPath:String
//		let	subcommand:Subcommand
//	}
	
	let	workspaceRootURL:NSURL
	let	subcommand:Subcommand
	unowned let cargoDelegate:CargoExecutionControllerDelegate
	init(workspaceRootURL:NSURL, subcommand:Subcommand, cargoDelegate:CargoExecutionControllerDelegate) {
		self.workspaceRootURL	=	workspaceRootURL
		self.subcommand			=	subcommand
		self.cargoDelegate		=	cargoDelegate
		
		_cargo			=	CargoExecutionController()
		_cargo.delegate	=	self
	}
	
	func launch() {
		switch self.subcommand {
		case .Clean:
			_cargo.launchClean(workingDirectoryURL: workspaceRootURL)
		case .Build:
			_cargo.launchBuild(workingDirectoryURL: workspaceRootURL)
		}
	}
	func cancel() {
		_cargo.kill()
		self.delegate!.workspaceCommandDidFinish(self)
	}
	func cargoExecutionControllerDidDiscoverRustCompilationIssue(issue: RustCompilerIssue) {
		sync(Queue.main) {
			self.cargoDelegate.cargoExecutionControllerDidDiscoverRustCompilationIssue(issue)
		}
	}
	func cargoExecutionControllerDidPrintMessage(s: String) {
		sync(Queue.main) {
			self.cargoDelegate.cargoExecutionControllerDidPrintMessage(s)
		}
	}
	func cargoExecutionControllerRemoteProcessDidTerminate() {
		sync(Queue.main) {
			self.cargoDelegate.cargoExecutionControllerRemoteProcessDidTerminate()
			self.delegate!.workspaceCommandDidFinish(self)
		}
	}
	
	////
	
	private let	_cargo:CargoExecutionController
}
















final class LaunchDebuggingSessionCommand: WorkspaceCommand {
	weak var delegate:WorkspaceCommandDelegate?
	
	unowned let	debuggingController:WorkspaceDebuggingController
	let	workspaceRootURL:NSURL
	
	init(debuggingController:WorkspaceDebuggingController, workspaceRootURL:NSURL) {
		self.debuggingController	=	debuggingController
		self.workspaceRootURL		=	workspaceRootURL
	}
	deinit {
	}
	func launch() {
		let	f	=	workspaceRootURL.URLByAppendingPathComponent("target").URLByAppendingPathComponent("rp7")
		if f.existingAsDataFile {
			debuggingController.launchSessionWithExecutableURL(f)
			
		} else {
			//	TODO:	Launch failure. Route to GUI.
		}
		
		self.delegate!.workspaceCommandWillStart(self)
		self.delegate!.workspaceCommandDidFinish(self)
	}
	func cancel() {
		//	This just initiate debuging session, and does not wait for finish.
		//	So nothing to do at here.
	}
}





