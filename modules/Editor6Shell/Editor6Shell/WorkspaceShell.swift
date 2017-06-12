//
//  WorkspaceShell.swift
//  Editor6Shell
//
//  Created by Hoon H. on 2017/06/11.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Editor6Features
import Editor6WorkspaceUI

public final class AppWorkspaceShell: WorkspaceShell {
    public override weak var features: WorkspaceFeatures? { didSet {} }
    public override init() {
        super.init()
    }
}
public class WorkspaceShell {
    private let workspaceUI = WorkspaceUIWindowController()
    weak var features: WorkspaceFeatures? {
        didSet {
            (features != nil ? startFeature() : endFeature())
        }
    }

    public var windowController: NSWindowController {
        return workspaceUI
    }

    private func startFeature() {

    }
    private func endFeature() {
        
    }
}
