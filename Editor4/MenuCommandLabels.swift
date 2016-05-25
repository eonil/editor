//
//  MenuCommandLabels.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

extension MenuCommand {
    func getLabel() -> String {
        switch self {
        case .Main(let command):                return command.getLabel()
        case .FileNavigator(let command):       return command.getLabel()
        }
    }
}
private extension MainMenuCommand {
    private func getLabel() -> String {
        switch self {
        case .FileNewWorkspace:                 return "Workspace..."
        case .FileNewFolder:                    return "Folder..."
        case .FileNewFile:                      return "File..."
        case .FileOpenWorkspace:                return "Workspace..."
        case .FileOpenClearWorkspaceHistory:    return "Clear Recent Workspaces"
        case .FileCloseFile:                    return "Close File"
        case .FileCloseWorkspace:               return "Close Workspace"
        case .FileDelete:                       return "Delete"
        case .FileShowInFinder:                 return "Show in Finder"
        case .FileShowInTerminal:               return "Show in Terminal"
        case .ViewEditor:                       return "Editor"
        case .ViewShowProjectNavigator:         return "Show File Navigator"
        case .ViewShowIssueNavigator:           return "Show Issue Navigator"
        case .ViewShowDebugNavigator:           return "Show Debug Navigator"
        case .ViewHideNavigator:                return "Hide Navigator"
        case .ViewConsole:                      return "Logs"
        case .ViewFullScreen:                   return "Toggle Full Screen"
        case .EditorShowCompletions:            return "Show Completions"
        case .ProductRun:                       return "Run"
        case .ProductBuild:                     return "Build"
        case .ProductClean:                     return "Clean"
        case .ProductStop:                      return "Stop"
        case .DebugPause:                       return "Pause"
        case .DebugResume:                      return "Resume"
        case .DebugHalt:                        return "Halt"
        case .DebugStepInto:                    return "Step Into"
        case .DebugStepOut:                     return "Step Out"
        case .DebugStepOver:                    return "Step Over"
        case .DebugClearConsole:                return "Clear Console"
        }
    }
}
private extension FileNavigatorMenuCommand {
    private func getLabel() -> String {
        switch self {
        case .ShowInFinder:     return "Show in Finder"
        case .ShowInTerminal:   return "Show in Terminal"
        case .CreateNewFolder:  return "Create New Folder"
        case .CreateNewFile:    return "Create New File"
        case .Delete:           return "Delete"
        }
    }
}






