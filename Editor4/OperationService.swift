//
//  OperationService.swift
//  Editor4
//
//  Created by Hoon H. on 2016/06/29.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Dispatch
import BoltsSwift

/// Executes multi-step long-running operations.
///
/// These are compositable core operations.
///
final class OperationService: DriverAccessible {
    private let processingGCDQ = dispatch_queue_create("\(DebugService.self)/processingGCDQ", DISPATCH_QUEUE_SERIAL)!
    private let continuationGCDQ = dispatch_queue_create("\(DebugService.self)/continuationGCDQ", DISPATCH_QUEUE_SERIAL)!

    private let platform = PlatformService()
    private let userInteraction = UserInteractionService()
    private let dialogue = DialogueService()
//    private let userCommandExecution = UserCommandExecutionService()

    //    let racer = RacerService()
    private let cargo = CargoService()
    private let debug = DebugService()

}

extension OperationService {
    func invalidateRendering() -> Task<()> {
        return driver.operation.userInteraction.dispatch { userInteractionState in
            userInteractionState.revise()
            return ()
        }
    }

    /// All menu commands are terminal (no return value) operation.
    ///
    /// - Returns:
    ///     A task completes when the command execution completes.
    ///     Completion timing of a command is defined differently
    ///     for each command.
    ///
    func executeMenuCommand(menuCommand: MenuCommand) -> Task<()> {
        return runWithUserInteraction { [driver] userInteractionState in
            // TODO: Consider using v-sync.
            do {
                switch menuCommand {
                case .main(let subcommand):
                    return try driver.operation.executeMainMenuCommand(subcommand, with: userInteractionState)
                case .fileNavigator(let subcommand):
                    return try driver.operation.executeFileNavigatorMenuCommand(subcommand, with: userInteractionState)
                }
            }
            catch let error {
                return Task(error: error)
            }
        }
    }

    func openWorkspace(location u: NSURL) -> Task<WorkspaceID> {
        return runWithUserInteraction { [driver] _ in
            assert(u.fileURL)
            guard u.fileURL else { throw OperationError.badFileURL(u) }
            return driver.operation.userInteraction.dispatch { (inout userInteractionState: UserInteractionState) throws -> WorkspaceID in
                let workspaceID = userInteractionState.addWorkspace()
                try userInteractionState.process(workspaceID) { workspaceState in
                    workspaceState.location = u
                }
                userInteractionState.currentWorkspaceID = workspaceID
                return workspaceID

            }.continueOnSuccessWithTask { (workspaceID: WorkspaceID) -> Task<WorkspaceID> in
                return driver.run(PlatformCommand.RestoreWorkspace(workspaceID, location: u)).continueOnSuccessWithTask { () throws -> Task<WorkspaceID> in
                    return Task(workspaceID)
                }
            }
        }
    }
    func closeWorkspace(workspaceID: WorkspaceID) -> Task<()> {
        return userInteraction.dispatch { state in
            try state.removeWorkspace(workspaceID)
        }
    }
    func setCurrentWorkspace(workspaceID: WorkspaceID) -> Task<()> {
        return driver.operation.userInteraction.dispatch { state in
            state.currentWorkspaceID = workspaceID
        }
    }
    func reloadWorkspace(workspaceID: WorkspaceID, workspaceState: WorkspaceState) -> Task<()> {
        return userInteraction.dispatch { userInteractionState in
            try userInteractionState.reloadWorkspace(workspaceID, workspaceState: workspaceState)
        }
    }
    func workspace(workspaceID: WorkspaceID, file fileID: FileID2, renameTo newName: String) -> Task<()> {
        return runWithUserInteraction { [driver] state in
            guard let workspace = state.workspaces[workspaceID] else { throw OperationError.badUserInteractionState(.missingWorkspaceStateFor(workspaceID)) }
            let filePath = workspace.files.resolvePathFor(fileID)
            guard let oldURL = workspace.location?.appending(filePath) else { throw OperationError.cannotResolveURLForWorkspaceFile(workspaceID, fileID) }
            guard let newURL = oldURL.URLByDeletingLastPathComponent?.URLByAppendingPathComponent(newName) else { throw OperationError.cannotResolveURLForWorkspaceFile(workspaceID, fileID) }
            // Hope file-system operation to be fast enough.
            return driver.run(PlatformCommand.RenameFile(from: oldURL, to: newURL)).continueOnSuccessWithTask { () -> Task<()> in
                // Update UI only if file-system operation is successful.
                return driver.operation.userInteraction.dispatch(workspaceID) { workspaceState in
                    try workspaceState.files.rename(fileID, to: newName)
                    return ()
                }.continueWithTask { (task: Task<()>) -> Task<()> in
                    // Store workspace at last.
                    guard let newWorkspaceState = state.workspaces[workspaceID] else { throw OperationError.badUserInteractionState(UserInteractionError.missingWorkspaceStateFor(workspaceID)) }
                    return driver.run(PlatformCommand.StoreWorkspace(newWorkspaceState)).continueWithTask(continuation: { (task: Task<()>) -> Task<()> in
                        if task.faulted {
                            // If we couldn't store workspace, it's a serious issue.
                            // For now, I have no idea how to deal with this, so
                            // just crash.
                            // TODO: Figure out better policy.
                            reportErrorToDevelopers("`PlatformCommand.StoreWorkspace` failed with error `\(task.error)`.")
                            fatalError("`PlatformCommand.StoreWorkspace` failed with error `\(task.error)`.")
                        }
                        return task
                    })
                }
            }
        }
    }
    func workspace(workspaceID: WorkspaceID, setHighlightedFile fileID: FileID2?) -> Task<()> {
        return userInteraction.dispatch(workspaceID) { workspaceState in
            workspaceState.window.navigatorPane.file.selection.reset(fileID)
        }
    }
    func workspace(workspaceID: WorkspaceID, resetSelection newSelection: (current: FileID2, items: TemporalLazyCollection<FileID2>)) -> Task<()> {
        return userInteraction.dispatch(workspaceID) { workspaceState in
            workspaceState.window.navigatorPane.file.selection.reset(newSelection.current, newSelection.items)
        }
    }
    /// Updates whole cargo state.
    func revise(cargoState: CargoServiceState) -> Task<()> {
        return userInteraction.dispatch { userInteractionState in
            userInteractionState.cargo = cargoState
        }
    }
    /// Updates whole debug state.
    func revise(debugState: DebugState) -> Task<()> {
        return userInteraction.dispatch { userInteractionState in
            userInteractionState.reviseDebugState(debugState)
        }
    }
}

extension OperationService {
    private func runWithUserInteraction<T>(transaction: (UserInteractionState) throws -> Task<T>) -> Task<T> {
        return userInteraction.dispatch { (inout state: UserInteractionState) -> UserInteractionState in
            return state
        }.continueOnSuccessWithTask(.Queue(processingGCDQ)) { (state: UserInteractionState) -> Task<T> in
            return try transaction(state)
        }.continueIn(continuationGCDQ)
    }
    private func runWithUserInteraction<T>(transaction: (UserInteractionState) throws -> T) -> Task<T> {
        return userInteraction.dispatch { (inout state: UserInteractionState) -> UserInteractionState in
            return state
        }.continueOnSuccessWith(.Queue(processingGCDQ)) { (state: UserInteractionState) -> T in
            return try transaction(state)
        }.continueIn(continuationGCDQ)
    }
}







////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Menu Execution
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
private extension OperationService {
    private func executeMainMenuCommand(command: MainMenuCommand, with userInteractionState: UserInteractionState) throws -> Task<()> {
        assertNonMainThread()
        switch command {
        case .FileNewWorkspace:
            /// "Creating a new workspace" is composed by three stages:
            /// 1. Backend(Cargo) prepares the workspace in file-system.
            /// 2. Opens an empty workspace.
            /// 3. Relocate the workspace to the URL.
            var u1: NSURL?
            return dialogue.runFolderSaveDialogue().continueOnSuccessWithTask { [driver] (u: NSURL) -> Task<()> in
                assert(u.fileURL)
                guard u.fileURL else { return Task(error: OperationError.badFileURL(u)) }
                u1 = u
                return driver.operation.cargo.dispatch(CargoCommand.New(u))

            }.continueWithTask { [driver] (task: Task<()>) -> Task<()> in
                return driver.operation.userInteraction.dispatch { state in
                    let workspaceID = state.addWorkspace()
                    try state.process(workspaceID) { workspaceState in
                        workspaceState.location = u1
                    }
                }
            }

        case .FileNewFolder:
            guard let workspaceID = userInteractionState.currentWorkspaceID else { throw OperationError.badUserInteractionState(.missingCurrentWorkspace) }
            guard let workspace = userInteractionState.currentWorkspace else { throw OperationError.badUserInteractionState(.missingCurrentWorkspace) }
            guard let currentFileID = workspace.window.navigatorPane.file.selection.getHighlightOrCurrent() else { throw OperationError.badUserInteractionState(.missingCurrentFile) }
            let currentFilePath = workspace.files.resolvePathFor(currentFileID)
            guard let newFolderName = (0..<128)
                .map({ "(new folder" + $0.description + ")" })
                .filter({ workspace.queryFile(currentFileID, containsSubfileWithName: $0) == false })
                .first else { throw OperationError.cannotMakeNameForNewFolder(workspaceID, container: currentFileID) }
            guard let u = workspace.location?.appending(currentFilePath) else { throw OperationError.cannotResolveURLForWorkspaceFile(workspaceID, currentFileID) }
            let u1 = u.URLByAppendingPathComponent(newFolderName)
            return driver.run(PlatformCommand.CreateDirectoryWithIntermediateDirectories(u1)).continueOnSuccessWithTask { [driver] () -> Task<WorkspaceState> in
                return driver.operation.userInteraction.dispatch(workspaceID) { workspaceState in
                    let newFolderID = try workspaceState.createFolder(in: currentFileID, at: 0, with: newFolderName)
                    workspaceState.startEditingName(of: newFolderID)
                    return workspaceState
                }
            }.continueOnSuccessWithTask { [driver] (workspaceState: WorkspaceState) -> Task<()> in
                return driver.operation.platform.dispatch(PlatformCommand.StoreWorkspace(workspaceState))
            }

        case .FileNewFile:
            guard let workspaceID = userInteractionState.currentWorkspaceID else { throw OperationError.badUserInteractionState(.missingCurrentWorkspace) }
            return driver.operation.userInteraction.dispatchToCurrentWorkspace { [driver] workspaceState in
                guard let currentFileID = workspaceState.window.navigatorPane.file.selection.getHighlightOrCurrent() else { throw OperationError.badUserInteractionState(.missingCurrentFile) }
                let currentFilePath = workspaceState.files.resolvePathFor(currentFileID)
                guard let newFileName = (0..<128)
                    .map({ "(new file" + $0.description + ")" })
                    .filter({ workspaceState.queryFile(currentFileID, containsSubfileWithName: $0) == false })
                    .first else { throw OperationError.cannotMakeNameForNewFolder(workspaceID, container: currentFileID) }
                guard let u = workspaceState.location?.appending(currentFilePath) else { throw OperationError.cannotResolveURLForWorkspaceFile(workspaceID, currentFileID) }
                let u1 = u.URLByAppendingPathComponent(newFileName)
                return (u1, currentFileID, newFileName)
            }.continueOnSuccessWithTask { [driver] (u: NSURL, currentFileID: FileID2, newFileName: String) in
                return driver.run(PlatformCommand.CreateDataFileWithIntermediateDirectories(u)).continueOnSuccessWithTask { [driver] () -> Task<()> in
                    return driver.operation.userInteraction.dispatchToCurrentWorkspace { workspaceState in
                        try workspaceState.createFile(in: currentFileID, at: 0, with: newFileName)
                        return workspaceState
                    }.continueOnSuccessWithTask { workspaceState in
                        return driver.run(PlatformCommand.StoreWorkspace(workspaceState))
                    }
                }
            }

        case .FileOpenWorkspace:
            return Task(()).continueWithTask { [driver] _ in
                return driver.operation.dialogue.runFolderOpenDialogue().continueOnSuccessWithTask { [driver] (u: NSURL) -> Task<()> in
                    assert(u.fileURL)
                    guard u.fileURL else { return Task(error: OperationError.badFileURL(u)) }
                    return driver.operation.openWorkspace(location: u).continueOnSuccessWith { _ in () }
                }
            }

        case .FileCloseWorkspace:
            guard let workspaceID = userInteractionState.currentWorkspaceID else { throw OperationError.badUserInteractionState(.missingCurrentWorkspace) }
            return driver.operation.closeWorkspace(workspaceID)

        case .FileDelete:
            guard let workspaceID = userInteractionState.currentWorkspaceID else { throw OperationError.badUserInteractionState(.missingCurrentWorkspace) }
            guard let workspace = userInteractionState.currentWorkspace else { throw OperationError.badUserInteractionState(.missingCurrentWorkspace) }
            guard let location = workspace.location else { throw OperationError.badUserInteractionState(.missingCurrentWorkspaceLocation) }
            let fileSequenceToDelete = workspace.window.navigatorPane.file.selection.getHighlightOrItems()
            let uniqueFileIDs = Set(fileSequenceToDelete)
            let us = uniqueFileIDs.map { (fileID: FileID2) -> NSURL in
                let p = workspace.files.resolvePathFor(fileID)
                let u = location.appending(p)
                return u
            }
            return driver.run(PlatformCommand.DeleteFileSubtrees(us)).continueOnSuccessWithTask { [driver] () -> Task<WorkspaceState> in
                return driver.operation.userInteraction.dispatchToCurrentWorkspace { workspaceState in
                    try workspaceState.deleteFiles(uniqueFileIDs)
                    return workspaceState
                }
            }.continueOnSuccessWithTask { [driver] (workspaceState: WorkspaceState) -> Task<()> in
                return driver.run(PlatformCommand.StoreWorkspace(workspaceState))
            }

        case .FileShowInFinder:
            guard let currentWorkspace = userInteractionState.currentWorkspace else { throw OperationError.badUserInteractionState(.missingCurrentWorkspace) }
            guard let location = currentWorkspace.location else { throw OperationError.badUserInteractionState(.missingCurrentWorkspaceLocation) }
            func getContainerFolderURL(fileID: FileID2) -> NSURL {
                let path = currentWorkspace.files.resolvePathFor(fileID)
                let url = location.appending(path)
                return url
            }
            let allFileIDsToShow = currentWorkspace.window.navigatorPane.file.selection.getHighlightOrItems()
            // All selections should be lazy collection, and evaluating for existence of first element must be O(1).
            guard allFileIDsToShow.isEmpty == false else { throw OperationError.badUserInteractionState(.missingCurrentWorkspaceSelection) }
            let containerFolderURLs = allFileIDsToShow.map(getContainerFolderURL)
            return driver.run(PlatformCommand.OpenFileInFinder(containerFolderURLs))

        case .FileShowInTerminal:
            MARK_unimplemented()

        case .ProductRun:
            guard let workspaceID = userInteractionState.currentWorkspaceID else { throw OperationError.badUserInteractionState(.missingCurrentWorkspace) }
            guard let workspaceLocationURL = userInteractionState.workspaces[workspaceID]?.location else { throw OperationError.badUserInteractionState(.missingCurrentWorkspaceLocation) }
            let executableURL = workspaceLocationURL
                .URLByAppendingPathComponent("target", isDirectory: true)
                .URLByAppendingPathComponent("debug", isDirectory: true)
                .URLByAppendingPathComponent("exec1", isDirectory: false)
            // TODO: add target somewhere else.
            return driver.operation.debug.addTarget(executableURL: executableURL).continueOnSuccessWithTask { [driver] debugTargetID in
                return driver.operation.userInteraction.dispatch(workspaceID) { workspaceState in
                    workspaceState.currentDebugTarget = debugTargetID
                }.continueOnSuccessWithTask {
                    return driver.operation.debug.launchTarget(debugTargetID, workingDirectoryURL: workspaceLocationURL)
                }
            }

        case .ProductBuild:
            guard let currentWorkspaceLocation = userInteractionState.currentWorkspace?.location else { throw OperationError.badUserInteractionState(.missingCurrentWorkspaceLocation) }
            return driver.operation.cargo.dispatch(CargoCommand.Build(currentWorkspaceLocation))

        case .ProductClean:
            guard let currentWorkspaceLocation = userInteractionState.currentWorkspace?.location else { throw OperationError.badUserInteractionState(.missingCurrentWorkspaceLocation) }
            return driver.operation.cargo.dispatch(CargoCommand.Clean(currentWorkspaceLocation))

            //        case .ProductRun:
            //        case .ProductStop:

        case .ProductStop:
            return driver.operation.userInteraction.dispatchToCurrentWorkspace { workspaceState in
                guard let debugTargetID = workspaceState.currentDebugTarget else { throw OperationError.badUserInteractionState(.missingCurrentDebugTarget) }
                return debugTargetID
                }.continueOnSuccessWithTask { [driver] debugTargetID in
                    return driver.operation.debug.haltTarget(debugTargetID)
            }

        default:
            MARK_unimplemented()
        }
    }
}
private extension OperationService {
    private func executeFileNavigatorMenuCommand(command: FileNavigatorMenuCommand, with userInteractionState: UserInteractionState) throws -> Task<()> {
        assertNonMainThread()
        switch command {
        case .showInFinder:
            return driver.operation.executeMenuCommand(.main(.FileShowInFinder))

        case .showInTerminal:
            return driver.operation.executeMenuCommand(.main(.FileShowInTerminal))

        case .createNewFolder:
            return driver.operation.executeMenuCommand(.main(.FileNewFolder))

        case .createNewFile:
            return driver.operation.executeMenuCommand(.main(.FileNewFile))
            
        case .delete:
            return driver.operation.executeMenuCommand(.main(.FileDelete))
        }
    }
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private extension WorkspaceState {
    func queryFile(superfileID: FileID2, containsSubfileWithName subfileName: String) -> Bool {
        return files[superfileID].subfileIDs.contains { files[$0].name == subfileName }
    }
}







