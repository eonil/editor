//
//  Command.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon

///	Asynchronous mutator for application model.
///
public class CommandQueue {
	public func queueCommand(command: ModelCommand) {
		fatalErrorBecauseUnimplementedYet()
	}
}

public enum CommandResult {
	case Done
	case Cancel(Reason)

	public enum Reason {
		///	Assumed condition alsmot satisfied, but some operation is
		///	not finished yet, and the operation seems take too long
		///	to finish. (over several seconds).
		case TooLongWaiting
		///	Assumed condition could not be satisfied in large at the
		///	point of execution.
		case BadExpectation
		///	Executer tried to execute command, and there was an error
		///	while executing it.
		case Error(message: String)
	}
}

public enum ModelCommand {
	case Workspace(WorkspaceCommand)
	case Navigation(NavigationCommand)
	case Search(SearchCommand)
	case Debugging(DebuggingCommand)
	case Reporting(ReportingCommand)
	case Inspection(InspectionCommand)
}

public enum WorkspaceCommand {
	case Select(WorkspaceModel)
	case Deselect

	case Run(WorkspaceModel)
	case Halt
	case Build
	case CleanAll
	case CleanCurrentModuleOnly
}

public enum NavigationCommand {
	case SelectFiles([NSURL])
	case DeselectFiles([NSURL])
	case DeselectAllFiles
	
	case ShowFileTree
	case HideFileTree
	case ShowInspector
	case HideInspector
	case CloseAllFiles
	case OpenFile(NSURL)
	case CloseFile(NSURL)
}

public enum SearchCommand {
	case RunFind(SearchInfo)
	case RunReplace(SearchInfo, ReplacementInfo)
	case Halt

	public struct SearchInfo {
		public var	expression	:	String
		public var	method		:	Method

		public enum Method {
			case Textual
			case RegularExpression
		}
	}
	public struct ReplacementInfo {
		public var	expression	:	String
	}
}


public enum ReportingCommand {
	case Log(String)
	case Clean
}

public enum InspectionCommand {
	case SelectFile(NSURL)
	case Deselect
}






