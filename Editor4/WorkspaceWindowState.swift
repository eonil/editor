//
//  WorkspaceWindowState.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/14.
//  Copyright © 2016 Eonil. All rights reserved.
//

struct WorkspaceWindowState {
    var navigatorPane = NavigatorPaneState()
    var editorPane = EditorPaneState()
    var utilityPane = UtilityPaneState()
    var commandPane = CommandPaneState()
}

//////////////////////////////////////////= //////////////////////

struct NavigatorPaneState {
    /// Set `nil` to hide pane.
    var current: NavigatorPaneID?
    var file = FileNavigatorPaneState()
    var issue = IssueNavigatorPaneState()
}
enum NavigatorPaneID {
    case File
    case Issue
    case Breakpoints
    case Debug
}
struct FileNavigatorPaneState {
    var selection = [FileNodePath]()
    var filterExpression: String?
}
struct IssueNavigatorPaneState {
    var hideWarnings = false
}

////////////////////////////////////////////////////////////////

struct EditorPaneState {
    var current: EditorPaneID?
    var text = TextEditorPaneState()
}
enum EditorPaneID {
    case Text
}
struct TextEditorPaneState {
    private(set) var lines = [String]()
}

struct AutocompletionState {
    private(set) var candidates = [AutocompletionCandidateState]()
}
struct AutocompletionCandidateState {
    private(set) var code: String
}

////////////////////////////////////////////////////////////////

enum CommandPaneID {
    case Console
    case Variables
}
struct CommandPaneState {
    /// Set `nil` to hide pane.
    var current: CommandPaneID?
    var variable = VariableNavigatorPaneState()
    var console = ConsoleCommandPaneState()
}
struct VariableNavigatorPaneState {

}
struct ConsoleCommandPaneState {

}

////////////////////////////////////////////////////////////////

struct UtilityPaneState {
    /// Set `nil` to hide pane.
    var current: UtilityPaneID?
}
enum UtilityPaneID {
    case Inspector
    case Help
}
struct InspectorUtilityPaneState {
    var current: InspectableID?
}
enum InspectableID {
    case File(FileNodePath)
}































