//
//  RepositoryState.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/14.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation.NSURL
import EonilToolbox

////////////////////////////////////////////////////////////////

enum IssueState {
    case ProjectConfigurationError
    case ProjectConfigurationWarning
    case CompileWarning
    case CompileError
}

struct BreakpointState {

}

/// Logs for one build session.
struct BuildLogState {
    private(set) var logs = [String]()
}











////////////////////////////////////////////////////////////////

struct DebuggingState {
    private(set) var processes = [DebuggingProcessState]()
    private(set) var threads = [DebuggingThreadState]()
    private(set) var stackFrames = [DebuggingStackFrameState]()
    private(set) var slotValues = [DebuggingSlotValueState]()
}
//enum DebuggingProcessPhase {
//        case NotLaunchedYet
//        case Running
//        case Paused
//        case Exited
//}
struct DebuggingProcessState {
    private(set) var name: String
    private(set) var phase: String
}
struct DebuggingThreadState {
    private(set) var name: String?
}
struct DebuggingStackFrameState {
    private(set) var name: String?
}
struct DebuggingSlotValueState {
    private(set) var name: String?
    private(set) var value: String?
}















