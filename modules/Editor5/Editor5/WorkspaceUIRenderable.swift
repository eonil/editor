//
//  WorkspaceUIRenderable.swift
//  Editor5
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import Editor5Common

protocol WorkspaceUIRenderable {
    func reload(_ newState: WorkspaceUIState)
}
