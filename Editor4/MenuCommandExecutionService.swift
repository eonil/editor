//
//  MenuCommandExecutionService.swift
//  Editor4
//
//  Created by Hoon H. on 2016/06/26.
//  Copyright © 2016 Eonil. All rights reserved.
//

import BoltsSwift

/// Executes menu commands.
final class MenuCommandExecutionService: DriverAccessible {
    /// - Returns:
    ///     A task completes when the command execution completes.
    ///     Completion timing of a command is defined differently 
    ///     for each command.
    ///
    /// Almost every menu command need to read from
    func dispatch(command: MenuCommand) -> Task<()> {
        // TODO: Consider using v-sync.
        return driver.userInteraction.query().continueOnSuccessWithTask { [weak self] state in
            guard let S = self else { return Task.cancelledTask() }
            return S.dispatchWithUserInteractionState(state, command: command)
        }
    }
    /// Runs in main thread.
    private func dispatchWithUserInteractionState(state: UserInteractionState, command: MenuCommand) -> Task<()> {
        // TODO: Consider using v-sync.
        do {
            switch command {
            case .main(let subcommand):
                return try run(state: state, command: subcommand)
            case .fileNavigator(let subcommand):
                return try run(state: state, command: subcommand)
            }
        }
        catch let error {
            return Task(error: error)
        }
    }
}

extension MenuCommandExecutionService {
    private func run(state state: UserInteractionState, command: MainMenuCommand) throws -> Task<()> {
        assertMainThread()
        switch command {
        case .FileNewWorkspace:
            var u1: NSURL?
            return DialogueUtility.runFolderSaveDialogue().continueOnSuccessWithTask(continuation: { [driver] (u: NSURL) -> Task<()> in
                assert(u.fileURL)
                guard u.fileURL else { return Task(error: UserOperationError.BadFileURL) }
                u1 = u
                return driver.cargo.dispatch(CargoCommand.New(u))

            }).continueWithTask(Executor.MainThread, continuation: { [driver] (task: Task<()>) -> Task<()> in
                let workspaceID = WorkspaceID()
                driver.userInteraction.dispatch(.Workspace(workspaceID, .Open))
                driver.userInteraction.dispatch(.Workspace(workspaceID, .Reconfigure(location: u1)))
                return task
            })

        case .FileNewFolder:
            guard let workspaceID = state.currentWorkspaceID else { throw UserOperationError.MissingCurrentWorkspace }
            guard let workspace = state.currentWorkspace else { throw UserOperationError.MissingCurrentWorkspace }
            guard let currentFileID = workspace.window.navigatorPane.file.selection.getHighlightOrCurrent() else { throw UserOperationError.MissingCurrentFile }
            let currentFilePath = workspace.files.resolvePathFor(currentFileID)
            guard let newFolderName = (0..<128)
                .map({ "(new folder" + $0.description + ")" })
                .filter({ workspace.queryFile(currentFileID, containsSubfileWithName: $0) == false })
                .first else { throw UserOperationError.File(FileUserOperationError.CannotMakeNameForNewFolder) }
            guard let u = workspace.location?.appending(currentFilePath) else { throw UserOperationError.File(FileUserOperationError.BadPath(currentFilePath)) }
            let u1 = u.URLByAppendingPathComponent(newFolderName)
            return driver.run(PlatformCommand.CreateDirectoryWithIntermediateDirectories(u1)).continueOnSuccessWithTask { [driver] () -> Task<()> in
                return driver.userInteraction.dispatch(.Workspace(workspaceID, .File(.CreateFolderAndStartEditingName(container: currentFileID, index: 0, name: newFolderName))))
            }.continueOnSuccessWithTask { [driver] () -> Task<()> in
                guard let newWorkspaceState = state.workspaces[workspaceID] else { throw UserOperationError.MissingCurrentWorkspace }
                return driver.run(PlatformCommand.StoreWorkspace(newWorkspaceState))
            }

        case .FileNewFile:
            guard let workspaceID = state.currentWorkspaceID else { throw UserOperationError.MissingCurrentWorkspace }
            guard let workspace = state.currentWorkspace else { throw UserOperationError.MissingCurrentWorkspace }
            guard let currentFileID = workspace.window.navigatorPane.file.selection.getHighlightOrCurrent() else { throw UserOperationError.MissingCurrentFile }
            let currentFilePath = workspace.files.resolvePathFor(currentFileID)
            guard let newFileName = (0..<128)
                .map({ "(new file" + $0.description + ")" })
                .filter({ workspace.queryFile(currentFileID, containsSubfileWithName: $0) == false })
                .first else { throw UserOperationError.File(FileUserOperationError.CannotMakeNameForNewFolder) }
            guard let u = workspace.location?.appending(currentFilePath) else { throw UserOperationError.File(FileUserOperationError.BadPath(currentFilePath)) }
            let u1 = u.URLByAppendingPathComponent(newFileName)
            return driver.run(PlatformCommand.CreateDataFileWithIntermediateDirectories(u1)).continueOnSuccessWithTask { [driver] () -> Task<()> in
                return driver.userInteraction.dispatch(.Workspace(workspaceID, .File(.CreateFileAndStartEditingName(container: currentFileID, index: 0, name: newFileName))))
            }.continueOnSuccessWithTask { [driver] () -> Task<()> in
                guard let newWorkspaceState = state.workspaces[workspaceID] else { throw UserOperationError.MissingCurrentWorkspace }
                return driver.run(PlatformCommand.StoreWorkspace(newWorkspaceState))
            }


        case .FileOpenWorkspace:
            var u1: NSURL?
            return DialogueUtility.runFolderOpenDialogue().continueOnSuccessWithTask { [driver] (u: NSURL) -> Task<()> in
                assert(u.fileURL)
                guard u.fileURL else { return Task(error: UserOperationError.BadFileURL) }
                u1 = u
                return Task(())
                }.continueOnSuccessWithTask { [driver] () -> Task<()> in
                    guard let u1 = u1 else { return Task(()) }
                    let workspaceID = WorkspaceID()
                    driver.userInteraction.dispatch(.Workspace(workspaceID, .Open))
                    driver.userInteraction.dispatch(.Workspace(workspaceID, .SetCurrent))
                    driver.userInteraction.dispatch(.Workspace(workspaceID, .Reconfigure(location: u1)))
                    return driver.run(PlatformCommand.RestoreWorkspace(workspaceID, location: u1))
                }

        case .FileCloseWorkspace:
            guard let workspaceID = state.currentWorkspaceID else { throw UserOperationError.MissingCurrentWorkspace }
            return driver.userInteraction.dispatch(UserAction.Workspace(workspaceID, WorkspaceAction.Close))

        case .FileDelete:
            guard let workspaceID = state.currentWorkspaceID else { throw UserOperationError.MissingCurrentWorkspace }
            guard let workspace = state.currentWorkspace else { throw UserOperationError.MissingCurrentWorkspace }
            guard let location = workspace.location else { throw UserOperationError.MissingCurrentWorkspaceLocation }
            let fileSequenceToDelete = workspace.window.navigatorPane.file.selection.getHighlightOrItems()
            let uniqueFileIDs = Set(fileSequenceToDelete)
            let us = uniqueFileIDs.map { (fileID: FileID2) -> NSURL in
                let p = workspace.files.resolvePathFor(fileID)
                let u = location.appending(p)
                return u
            }
            return driver.run(PlatformCommand.DeleteFileSubtrees(us)).continueOnSuccessWithTask { [driver] () -> Task<()> in
                return driver.userInteraction.dispatch(UserAction.Workspace(workspaceID, WorkspaceAction.File(FileAction.DeleteFiles(uniqueFileIDs))))
            }.continueOnSuccessWithTask { [driver] () -> Task<()> in
                guard let newWorkspaceState = state.workspaces[workspaceID] else { throw UserOperationError.MissingCurrentWorkspace }
                return driver.run(PlatformCommand.StoreWorkspace(newWorkspaceState))
            }

        case .FileShowInFinder:
            guard let currentWorkspace = state.currentWorkspace else { throw UserOperationError.MissingCurrentWorkspace }
            guard let location = currentWorkspace.location else { throw UserOperationError.MissingCurrentWorkspaceLocation }
            func getContainerFolderURL(fileID: FileID2) -> NSURL {
                let path = currentWorkspace.files.resolvePathFor(fileID)
                let url = location.appending(path)
                return url
            }
            let allFileIDsToShow = currentWorkspace.window.navigatorPane.file.selection.getHighlightOrItems()
            // All selections should be lazy collection, and evaluating for existence of first element must be O(1).
            guard allFileIDsToShow.isEmpty == false else { throw UserOperationError.NoSelectedFile }
            let containerFolderURLs = allFileIDsToShow.map(getContainerFolderURL)
            return driver.run(PlatformCommand.OpenFileInFinder(containerFolderURLs))

        case .FileShowInTerminal:
            MARK_unimplemented()

        case .ProductRun:
            guard let workspaceID = state.currentWorkspaceID else { throw UserOperationError.MissingCurrentWorkspace }
            guard let workspaceLocationURL = state.workspaces[workspaceID]?.location else { throw UserOperationError.MissingCurrentWorkspaceLocation }
            let executableURL = workspaceLocationURL
                .URLByAppendingPathComponent("target", isDirectory: true)
                .URLByAppendingPathComponent("debug", isDirectory: true)
                .URLByAppendingPathComponent("exec1", isDirectory: false)
            return driver.debug.addTarget(executableURL: executableURL).continueOnSuccessWith { [driver] (debugTargetID: DebugTargetID) -> () in
                return driver.debug.launchTarget(debugTargetID, workingDirectoryURL: workspaceLocationURL)
            }

        case .ProductBuild:
            guard let currentWorkspaceLocation = state.currentWorkspace?.location else { throw UserOperationError.MissingCurrentWorkspaceLocation }
            return driver.cargo.dispatch(CargoCommand.Build(currentWorkspaceLocation))

        case .ProductClean:
            guard let currentWorkspaceLocation = state.currentWorkspace?.location else { throw UserOperationError.MissingCurrentWorkspaceLocation }
            return driver.cargo.dispatch(CargoCommand.Clean(currentWorkspaceLocation))

            //        case .ProductRun:
            //        case .ProductStop:

        default:
            MARK_unimplemented()
        }
    }
    private func run(state state: UserInteractionState, command: FileNavigatorMenuCommand) throws -> Task<()> {
        assertMainThread()
        switch command {
        case .showInFinder:
            return driver.menuExecution.dispatch(.main(.FileShowInFinder))

        case .showInTerminal:
            return driver.menuExecution.dispatch(.main(.FileShowInTerminal))

        case .createNewFolder:
            return driver.menuExecution.dispatch(.main(.FileNewFolder))

        case .createNewFile:
            return driver.menuExecution.dispatch(.main(.FileNewFile))
            
        case .delete:
            return driver.menuExecution.dispatch(.main(.FileDelete))
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

