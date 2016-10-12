//
//  WorkspaceDocumentEvent.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/08.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

enum WorkspaceDocumentEvent {
    case initiate(Workspace)
    /// Notifies renewal of the state back to upper object.
    /// 
    /// Don't be confused. This is just a parameter being 
    /// sent to driver. This could feel very wild design,
    /// but I think this is efficient.
    ///
    case renew(Workspace)
    case terminate(Workspace)

    case becomeCurrent(WorkspaceID)
    case resignCurrent(WorkspaceID)
}
