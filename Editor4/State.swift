//
//  State.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import EonilToolbox

// If copying cost becomes too big, consider using of COW objects.

struct State {
    var currentWorkspaceID: WorkspaceID? = nil
    var workspaces = KeysetVersioningDictionary<WorkspaceID, WorkspaceState>()
//    var workspaces = [WorkspaceID: WorkspaceState]()
}
struct WorkspaceID: Hashable {
    var hashValue: Int {
        get { return oid.hashValue }
    }
    private let oid = ObjectAddressID()
}
func == (a: WorkspaceID, b: WorkspaceID) -> Bool {
    return a.oid == b.oid
}
struct WorkspaceState: VersioningStateType {
    var location: NSURL?
    var version = Version()
    var fileNavigator = FileNavigatorState()
    var textEditor = TextEditorState()
    var issues = [Issue]()
    var panes = [WorkspacePaneID: WorkspacePaneState]()
}
enum WorkspacePaneID {
    case Navigator
    case Inspector
    case Console
}
enum WorkspacePaneState {
    case Open
    case Closed
}
//struct WorkspaceItemPath {
//}

struct TextEditorState {
    private(set) var lines = [String]()
}
struct AutocompletionState {
    private(set) var candidates = [AutocompletionCandidateState]()
}
struct AutocompletionCandidateState {
    private(set) var code: String
}
struct ConsoleState {
    private(set) var logs = [String]()
}
enum Issue {
    case ProjectConfigurationError
    case ProjectConfigurationWarning
    case CompileWarning
    case CompileError
}
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













