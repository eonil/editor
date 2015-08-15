////
////  CommandQueue.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/08/15.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import EditorCommon
//
/////	Asynchronous mutator for application model.
/////
//public class CommandQueue {
//	public func queueCommand(command: ModelCommand) {
//		fatalErrorBecauseUnimplementedYet()
//	}
//}
//
//public enum CommandResult {
//	case Done
//	case Cancel(Reason)
//
//	public enum Reason {
//		///	Assumed condition alsmot satisfied, but some operation is
//		///	not finished yet, and the operation seems take too long
//		///	to finish. (over several seconds).
//		case TooLongWaiting
//		///	Assumed condition could not be satisfied in large at the
//		///	point of execution.
//		case BadExpectation
//		///	Executer tried to execute command, and there was an error
//		///	while executing it.
//		case Error(message: String)
//	}
//}
