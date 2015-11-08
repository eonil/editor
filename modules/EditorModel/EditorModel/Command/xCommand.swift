////
////  Command.swift
////  EditorShell
////
////  Created by Hoon H. on 2015/08/14.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import EditorCommon
//
//public enum ModelCommand {
//	case Workspace(WorkspaceCommand)
//	case Navigation(NavigationCommand)
//	case Search(SearchCommand)
//	case Debugging(DebuggingCommand)
//	case Reporting(ReportingCommand)
//	case Inspection(InspectionCommand)
//}
//
//public enum WorkspaceCommand {
//
//	case New
//	case Open
//	case Close
//
//	case Select(WorkspaceModel)
//	case Deselect
//
//	case Run(WorkspaceModel)
//	case Halt
//	case Build
//	case CleanAll
//	case CleanCurrentModuleOnly
//}
//
//public enum NavigationCommand {
//	case SelectFiles([NSURL])
//	case DeselectFiles([NSURL])
//	case DeselectAllFiles
//	
//	case ShowFileTree
//	case HideFileTree
//	case ShowInspector
//	case HideInspector
//	case CloseAllFiles
//	case OpenFile(NSURL)
//	case CloseFile(NSURL)
//}
//
//public enum SearchCommand {
//	case RunFind(SearchInfo)
//	case RunReplace(SearchInfo, ReplacementInfo)
//	case Halt
//
//	public struct SearchInfo {
//		public var	expression	:	String
//		public var	method		:	Method
//
//		public enum Method {
//			case Textual
//			case RegularExpression
//		}
//	}
//	public struct ReplacementInfo {
//		public var	expression	:	String
//	}
//}
//
//
//public enum ReportingCommand {
//	case Log(String)
//	case Clean
//}
//
//public enum InspectionCommand {
//	case SelectFile(NSURL)
//	case Deselect
//}
//
//
//
//
//
//
