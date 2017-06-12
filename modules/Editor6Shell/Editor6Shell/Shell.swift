//
//  Shell.swift
//  Editor6Shell
//
//  Created by Hoon H. on 2017/06/11.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Editor6Features

public final class AppShell: Shell {
    public override init() {
        super.init()
    }
}

public class Shell {
    public weak var features: WorkspaceFeatures?
}
