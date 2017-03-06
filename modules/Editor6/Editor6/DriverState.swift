//
//  DriverState.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import Editor6Common
import Editor6WorkspaceModel
import Editor6MainMenuUI2
import Editor6WorkspaceUI

///
/// Defines driver state.
///
/// Driver manages shared singleton stuffs.
/// For example, main-menu is managed by driver.
///
/// Driver does NOT manage any other states.
/// States for each repo will be managed by
/// `RepoController`.
/// 
struct DriverState {
    fileprivate(set) var mainMenuUIState = MainMenuUI2State()

    init() {
        mainMenuUIState.availableItems = [
            .applicationQuit,
            .fileNewRepo,
            .fileOpen,
        ]
    }
}

extension DriverState {
    mutating func apply(repoDocumentManagerEvent e: RepoDocumentManager.Event) {
        switch e {
        case .didAddDocument(let doc):
            MARK_unimplementedButSkipForNow()
        case .willRemoveDocument(let doc):
            MARK_unimplementedButSkipForNow()
        case .changeState(let doc):
            MARK_unimplementedButSkipForNow()
        case .changeCurrentDocument:
            MARK_unimplementedButSkipForNow()
        }


        mainMenuUIState.availableItems.formUnion([
            .productClean,
            .productBuild,
            ])
    }
    ///
    /// - Parameter s:
    ///     Can be `nil` because current repo can be `nil`...
    ///
    mutating func apply(currentRepoState s: RepoState?) {
        let hasCurrentRepo = (s != nil)
        let isStoredOnFileSystem = (s?.location != nil)
        let canUseBuildTools = isStoredOnFileSystem

        mainMenuUIState[.fileOpen].isEnabled        =   true

        mainMenuUIState[.fileSave].isEnabled        =   hasCurrentRepo && (isStoredOnFileSystem == false)
        mainMenuUIState[.fileSaveAs].isEnabled      =   hasCurrentRepo && (isStoredOnFileSystem == false)
        mainMenuUIState[.fileClose].isEnabled       =   false
        mainMenuUIState[.fileCloseRepo].isEnabled   =   hasCurrentRepo

        mainMenuUIState[.productClean].isEnabled    =   canUseBuildTools
        mainMenuUIState[.productBuild].isEnabled    =   canUseBuildTools
        mainMenuUIState[.productRun].isEnabled      =   canUseBuildTools
        mainMenuUIState[.productStop].isEnabled     =   canUseBuildTools
    }
//    mutating func apply(event: WorkspaceMessage) {
//        switch event {
//        case .initiate(let id):
//            workspaceUIs[id] = (WorkspaceState(), WorkspaceUIState())
//        case .renew(let id, let modelState, let viewState):
//            workspaceUIs[id] = (modelState, viewState)
//        case .terminate(let id):
//            workspaceUIs[id] = nil
//        case .becomeCurrent(let id):
//            currentWorkspaceID = id
//        case .resignCurrent(let id):
//            guard currentWorkspaceID == id else { reportFatalError() }
//            currentWorkspaceID = nil
//        }
//    }
}

//enum DriverMutation {
////    case workspaceUI(DictionaryMutation<WorkspaceID, (model: WorkspaceState, view: WorkspaceUIState)>)
//    case currentWorkspaceID(WorkspaceID?)
//    case mainMenu(MainMenuUI2State)
//}

private struct MenuItemState {
    var isEnabled = false
}
private extension MainMenuUI2State {
    subscript(_ menuItemID: MainMenuUI2ItemID) -> MenuItemState {
        get {
            var s = MenuItemState()
            s.isEnabled = availableItems.contains(menuItemID)
            return s
        }
        set {
            if newValue.isEnabled {
                availableItems.insert(menuItemID)
            }
            else {
                availableItems.remove(menuItemID)
            }
        }
    }
}








