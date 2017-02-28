////
////  WorkspaceMessage.swift
////  Editor6
////
////  Created by Hoon H. on 2016/10/08.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import Editor6WorkspaceUI
//
///// Message will be sent from a workspace.
///// 
///// For now, the only receiver is the driver.
///// Workspace usually processes almost everything
///// internally, and dispatch message only for stuffs
///// that must be shared.
/////
//enum WorkspaceMessage {
//    case initiate(WorkspaceID)
//    /// Notifies renewal of the state back to upper object.
//    /// 
//    /// Don't be confused. This is just a parameter being 
//    /// sent to driver. This could feel very wild design,
//    /// but I think this is efficient.
//    ///
//    case renew(WorkspaceID, WorkspaceState, WorkspaceUIState)
//    case terminate(WorkspaceID)
//
//    case becomeCurrent(WorkspaceID)
//    case resignCurrent(WorkspaceID)
//}
