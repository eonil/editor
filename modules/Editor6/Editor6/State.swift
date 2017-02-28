//
//  State.swift
//  Editor6
//
//  Created by Hoon H. on 2017/02/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilToolbox
import Editor6Common
import Editor6WorkspaceUI

struct State {
    var workspaces = [WorkspaceState]()
}

struct WorkspaceState {
    private(set) var version = Version()
    var workspaces = [WorkspaceUIPair]() { didSet { version.revise() } }
}

enum WorkspaceTransaction {
    case insert(WorkspaceUIPair)
    case update(WorkspaceUIPair)
    case delete(WorkspaceUIPair)
}

typealias WorkspaceUIPair = (WorkspaceUIID, WorkspaceUIState)
struct WorkspaceUIID: Hashable {
    private let oid = ObjectAddressID()
    var hashValue: Int {
        return oid.hashValue
    }
    static func == (_ a: WorkspaceUIID, _ b: WorkspaceUIID) -> Bool {
        return a.oid == b.oid
    }
}
