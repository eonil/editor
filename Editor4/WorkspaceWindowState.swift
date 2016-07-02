//
//  WorkspaceWindowState.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/14.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// We do not keep selection/editing informaiton in navigational state
/// except it's really required because it affects performance too much.
struct WorkspaceWindowState {
    var navigatorPane = NavigatorPaneState()
    var editorPane = EditorPaneState()
    var utilityPane = UtilityPaneState()
    var commandPane = CommandPaneState()
}

////////////////////////////////////////////////////////////////

struct NavigatorPaneState {
    /// Set `nil` to hide pane.
    var current: NavigatorPaneID?
    var file = FileNavigatorPaneState()
    var issue = IssueNavigatorPaneState()
}
enum NavigatorPaneID {
    case files
    case issues
    case breakpoints
    case debug
}
struct FileNavigatorPaneState {
    /// Path to a file-node that is currently in editing.
    var editing: Bool = false
    var filterExpression: String?
    var selection = FileNavigatorPaneSelectionState()
}
struct FileNavigatorPaneSelectionState {
    /// Currently focused file node.
    /// This is clicked file while context-menu is running.
    private(set) var highlighting: FileID2?
    /// User's most recent focused selection.
    /// This is rarely required.
    /// - Parameter current:
    ///     This must be included in `all`.
    private(set) var current: FileID2?
    /// This work only in specific time-span. Which means
    /// accessible only if `version == accessibleVerison`.
    private(set) var items: TemporalLazyCollection<FileID2> = []

    private init() {
    }
    mutating func reset() {
        highlighting = nil
        current = nil
        items = []
    }
    mutating func reset(newCurrent: FileID2?) {
        reset()
        if let newCurrent = newCurrent {
            reset(newCurrent)
        }
    }
    mutating func reset(newCurrent: FileID2) {
        reset(newCurrent, [newCurrent])
    }
    /// You must have a "current" file when you set to a new files.
    mutating func reset(newCurrent: FileID2, _ newItems: TemporalLazyCollection<FileID2>) {
        assert(newItems.contains(newCurrent))
        highlighting = nil
        current = newCurrent
        items = newItems
    }
    mutating func highlight(newHighlight: FileID2) {
        highlighting = newHighlight
        current = nil
        // Keeps current selection.
    }
}
extension FileNavigatorPaneSelectionState {
    func getHighlightOrCurrent() -> FileID2? {
        return highlighting ?? current
    }
    /// - Returns:
    ///     A highlighted file ID if highlighted file ID is not a part of selected file IDs.
    ///     All selected file IDs if the highlighted file ID is a part of selected file IDs
    ///     or there's no highlighted file ID.
    func getHighlightOrItems() -> AnyRandomAccessCollection<FileID2> {
        if let highlighting = highlighting {
            if items.contains(highlighting) {
                return AnyRandomAccessCollection(items)
            }
            else {
                return AnyRandomAccessCollection(CollectionOfOne(highlighting).flatMap({$0}))
            }
        }
        else {
            return AnyRandomAccessCollection(items)
        }
    }
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































