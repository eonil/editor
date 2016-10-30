//
//  WorkspaceModel.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/17.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import Flow

/// `WorkspaceModel` is an independent actor.
/// This manages non-UI stuffs. 
/// Soley interacts with `Driver`.
///
public final class WorkspaceModel {
    private var delegate = ((WorkspaceNotification) -> ())?.none
    private var local = Local()

    public let debug = DebugModel()

    public init() {
        debug.delegate { [weak self] in self?.process($0) }
//        cargo.delegate { [weak self] in self?.process($0) }
//        debug.delegate { [weak self] (n: DebugNotification) in
//        }
    }
    public func delegate(to newDelegate: @escaping (WorkspaceNotification) -> ()) {
        delegate = newDelegate
    }

    private func process(_ n: DebugNotification) {
        switch n {
        case .apply(let t):
            let from1 = local.state
            local.state.debug = t.to
            let to1 = local.state
            let by1 = t.by.map(WorkspaceMutation.debug)
            let t1 = ModelTransaction<WorkspaceState>(from: from1, to: to1, by: by1)
            delegate?(.apply(t1))
        case .queue(let continuation):
            delegate?(.queue(continuation))
        }
    }
}

fileprivate struct Local {
//    private let files =
    let debug = DebugModel()
    let cargo = Cargo()
    let rls = RustLanguageServer()
    var state = WorkspaceState()
}

private extension CargoError {
    func toIssue() -> Issue {
        return Issue(source: .cargo, description: localizedDescription)
    }
}
