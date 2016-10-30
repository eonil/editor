//
//  Driver.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import Editor6WorkspaceModel

final class Driver {
    private let wsm = WorkspaceModel()
    init() {
        wsm.debug.addTarget(executable: URL(fileURLWithPath: "")).step { [weak self] (newTargetID: DebugTargetID) -> () in
            guard let s = self else { return }
            print(newTargetID)
        }
    }
}
