//
//  State.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

// If copying cost becomes too big, consider using of COW objects.

struct State {
        var keyWorkspaceID: WorkspaceID? = nil
        var workspaces = [WorkspaceID: WorkspaceState]()
}
struct WorkspaceID: Hashable {
        var hashValue: Int {
                get { return ObjectIdentifier(dummy).hashValue }
        }
        private let dummy = NonObjectiveCBase()
}
func == (a: WorkspaceID, b: WorkspaceID) -> Bool {
        return a.dummy === b.dummy
}
struct WorkspaceState: VersionedStateType {
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
struct WorkspaceItemPath {
}
struct FileNavigatorState: VersionedStateType {
        private(set) var version = Version()
        private(set) var root: FileNodeID? = nil
        private(set) var nodes = [FileNodeID: FileNodeState]()
        private(set) var selection = [FileNodeID]()
}
struct FileNodeID: Hashable {
        var hashValue: Int {
                get { return ObjectIdentifier(dummy).hashValue }
        }
        private let dummy = NonObjectiveCBase()
}
func == (a: FileNodeID, b: FileNodeID) -> Bool {
        return a.dummy === b.dummy
}
struct FileNodeState {
        private(set) var name: String
        private(set) var comment: String?
        private(set) var isGroup: Bool
        private(set) var subnodes = [FileNodeID]()
}
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













