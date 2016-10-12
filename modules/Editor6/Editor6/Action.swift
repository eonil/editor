//
//  Action.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/08.
//  Copyright © 2016 Eonil. All rights reserved.
//

enum Action {
    case operation(OperationAction)
    case workspace(WorkspaceDocumentEvent)
}
//
///// An action that can be sent from the menu.
//enum MenuUIAction {
//    case execute(DriverCommand)
////    case execute(WorkspaceCommand, WorkspaceDocument)
//}
