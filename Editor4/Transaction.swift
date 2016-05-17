//
//  Transaction.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation.NSURL

/// Defineds atomic transaction for UI state.
///
/// Transaction definitions can be nested to provide:
/// - Semantic locality
/// - Common contextual parameter
enum Transaction {
    /// The first transaction to activate driver.
    case Reset
    case Test(TestTransaction)
    case Shell(ShellTransaction)
    case Workspace(WorkspaceID, WorkspaceTransaction)
    case ApplyCargoServiceState(CargoServiceState)
}
enum TestTransaction {
    case Test1
    case Test2CreateWorkspaceAt(NSURL)
}
enum ShellTransaction {
    case Quit
    case RunCreatingWorkspaceDialogue
    case RunOpeningWorkspaceDialogue
//    case NewWorkspace(NSURL)
//    case OpenWorkspace(NSURL)
}
/// Transactions about a workspace.
///
/// - Note:
///     "Creating a new workspace" is composed by three stages:
///     1. Backend(Cargo) prepares the workspace in file-system.
///     2. Opens an empty workspace.
///     3. Relocate the workspace to the URL.
enum WorkspaceTransaction {
    case Open
    case Close
    case Reconfigure(location: NSURL?)
    case SetCurrent
    case File(FileTransaction)
    case Editor(EditorTransaction)
    //        case FileNode(path: WorkspaceItemPath, FileNodeTransaction)
    //        case FileNodeList(paths: [WorkspaceItemPath], FileNodeTransaction)
    case Build(BuildTransaction)
    case Debug(DebugTransaction)
    case UpdateBuildState
}
enum FileTransaction {
    case Delete(FileNodePath)
    case DeleteAllSelected
    case Select([FileNodePath])
    case SelectAll
    case Deselect([FileNodePath])
    case DeselectAll
    case Drop(from: [NSURL], onto: FileNodePath)
    case Move(from: [FileNodePath], onto: FileNodePath)
//    case EditTree(id: FileNodeID, transaction: FileTreeEditTransaction)
}
enum FileTransactionError: ErrorType {
    case BadFileNodePath(FileNodePath)
    case BadFileNodeIndex
}
//enum FileTreeEditTransaction {
//}
//enum FileNodeTransaction {
//        case Select
//        case Deselect
//        case Delete
//}
enum EditorTransaction {
    case Open(NSURL)
    case Save
    case Close
    case TextEditor(TextEditorTransaction)
}
enum TextEditorTransaction {
}
enum AutocompletionTransaction {
    case ShowCandidates
    case HideCandidates
    case ReconfigureCandidates(expression: String)
}
enum BuildTransaction {
    case Clean
    case Build
}
enum DebugTransaction {
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








