//
//  WorkspaceUIState.swift
//  Editor6WorkspaceUI
//
//  Created by Hoon H. on 2016/10/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import Editor6FileTreeUI

public struct WorkspaceUIState {
    public var navigator = WorkspaceUINavigatorState()
    public init() {}
}

public struct WorkspaceUINavigatorState {
    public var files = FileNavigatorUIState()
    public var issues = Editor6CommonOutlineUIState()
    public var debug = Editor6CommonOutlineUIState()
}
