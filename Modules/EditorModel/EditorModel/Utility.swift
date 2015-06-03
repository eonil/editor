//
//  Utility.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/06/01.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import EditorToolComponents




func queryCargoAtDirectoryURL(directoryURL: NSURL, keyPath: String) -> String? {
	@objc class Marker {
	}
	let	p	=	NSBundle(forClass: Marker.self).pathForResource("bin/CargoQueryServer", ofType: "")
	let	s	=	runShellCommand(directoryURL, "\(p) \(keyPath)")
	return	s
}






///	Runs a shell command using `bash` and returns
///	all outputs. Returns `nil` on any error.
func runShellCommand(workingDirectoryURL: NSURL, command: String) -> String? {
	let	sh	=	ShellTaskExecutionController()
	let	a	=	Agent()
	sh.delegate	=	a
	sh.launch(workingDirectoryURL: workingDirectoryURL)
	sh.writeToStandardInput(command)
	sh.waitUntilExit()
	if sh.exitCode == 0 {
		return	a.allOutput
	}
	return	nil
}

class Agent: ShellTaskExecutionControllerDelegate {
	var	allError	:	String?
	var	allOutput	:	String?
	func shellTaskExecutableControllerDidReadFromStandardError(s: String) {
		if allError == nil {
			allError	=	""
		}
		allError!	+=	s
	}
	func shellTaskExecutableControllerDidReadFromStandardOutput(s: String) {
		if allOutput == nil {
			allOutput	=	""
		}
		allOutput!	+=	s
	}
	func shellTaskExecutableControllerRemoteProcessDidTerminate(#exitCode: Int32, reason: NSTaskTerminationReason) {
		
	}
}