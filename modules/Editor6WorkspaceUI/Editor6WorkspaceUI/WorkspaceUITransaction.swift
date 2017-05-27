//
//  WorkspaceUITransaction.swift
//  Editor6WorkspaceUI
//
//  Created by Hoon H. on 2017/03/08.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

struct WorkspaceUITransaction {
    var from = WorkspaceUIState()
    var to = WorkspaceUIState()
    var by = [WorkspaceUIMutation]()
}

enum WorkspaceUIMutation {
    case ADHOC_any
}
