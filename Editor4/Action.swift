//
//  Action.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation.NSURL

/// Defineds atomic action for UI state.
///
/// Action definitions can be nested to provide:
/// - Semantic locality
/// - Common contextual parameter
enum Action {
    /// The first action to activate driver.
    case Reset
    case Test(TestAction)
    case Shell(ShellAction)
    case Workspace(WorkspaceID, WorkspaceAction)
    case ApplyCargoServiceState(CargoServiceState)
}
enum TestAction {
    case Test1
    case Test2CreateWorkspaceAt(NSURL)
}
enum ShellAction {
    case Quit
    case Alert(ErrorType)
    case RunCreatingWorkspaceDialogue
    case RunOpeningWorkspaceDialogue
//    case NewWorkspace(NSURL)
//    case OpenWorkspace(NSURL)
}
/// Actions about a workspace.
///
/// - Note:
///     "Creating a new workspace" is composed by three stages:
///     1. Backend(Cargo) prepares the workspace in file-system.
///     2. Opens an empty workspace.
///     3. Relocate the workspace to the URL.
enum WorkspaceAction {
    case Open
    case Close
    case Reconfigure(location: NSURL?)
    case SetCurrent
    case File(FileAction)
    case Editor(EditorAction)
    //        case FileNode(path: WorkspaceItemPath, FileNodeAction)
    //        case FileNodeList(paths: [WorkspaceItemPath], FileNodeAction)
    case Build(BuildAction)
    case Debug(DebugAction)
    case UpdateBuildState
}

enum FileAction {
    /// Creates a new folder at index in the specified container
    /// and put it under editing state.
    case CreateFolderAndStartEditingName(container: FileID2, index: Int)
    /// Creates a new file at index in the specified container
    /// and put it under editing state.
    case CreateFileAndStartEditingName(container: FileID2, index: Int)
    case StartEditingCurrentFileName
    case Remove(FileID2)
    case Remvoe(FileID2)
    case Reconfigure(FileID2, FileState2)
    case Drop(from: [NSURL], onto: FileNodePath)
    case Move(from: [FileNodePath], onto: FileNodePath)
//    case EditTree(id: FileNodeID, action: FileTreeEditAction)
    case SetCurrent(FileID2?)
    case SetSelectedFiles(MemoizingLazyList<FileID2>)
}

enum FileActionError: ErrorType {
    case BadFileNodePath(FileNodePath)
    case BadFileNodeIndex
}
//enum FileTreeEditAction {
//}
//enum FileNodeAction {
//        case Select
//        case Deselect
//        case Delete
//}
enum EditorAction {
    case Open(NSURL)
    case Save
    case Close
    case TextEditor(TextEditorAction)
}
enum TextEditorAction {
}
enum AutocompletionAction {
    case ShowCandidates
    case HideCandidates
    case ReconfigureCandidates(expression: String)
}
enum BuildAction {
    case Clean
    case Build
}
enum DebugAction {
    case Launch
    case Halt
    case Pause
    case Resume
    case StepInto
    case StepOver
    case StepOut
    case SelectStackFrame(index: Int)
    case DeselectStackFrame
//        case SelectSlotVariable(index: Int)
//        case DeselectSlotVariable
    case PrintSlotVariable(index: Int)
}








