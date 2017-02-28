////
////  DriverState.swift
////  Editor6
////
////  Created by Hoon H. on 2016/10/09.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import Editor6Common
//import Editor6MainMenuUI2
//import Editor6WorkspaceUI
//
///// Application central state repository.
/////
///// "Central" means this is application-wide shared data.
///// "Central" doesn't mean the `Driver` would manage all the states.
///// Each components owns and manages thier own state, and dispatches
///// back some to driver. Driver collects them for its needs. Usually
///// as parameters to derive central state.
/////
///// Main concern of driver state is managing main menu.
//struct DriverState {
//
//    fileprivate(set) var mainMenu = MainMenuUI2State()
//
//    /// `WorkspaceDocument` owns and manages the workspace state.
//    /// And workspace document dispatches its state back to `Driver` when
//    /// changed. These aggregated workspaces states works as parameters
//    /// to update driver local state.
//    fileprivate(set) var workspaceUIs = [WorkspaceID: (model: WorkspaceState, view: WorkspaceUIState)]()
//    fileprivate(set) var currentWorkspaceID = WorkspaceID?.none
//
//    init() {
//        mainMenu.availableItems = [
//            .applicationQuit,
//            .fileNewWorkspace,
//        ]
//    }
//}
//
//extension DriverState {
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
//}
//
////private extension WorkspaceNotification {
////    func toDriverMutation() -> DriverMutation {
////        
////    }
////}
//
//enum DriverMutation {
////    case workspaceUI(DictionaryMutation<WorkspaceID, (model: WorkspaceState, view: WorkspaceUIState)>)
//    case currentWorkspaceID(WorkspaceID?)
//    case mainMenu(MainMenuUI2State)
//}
