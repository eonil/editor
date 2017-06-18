//
//  Shell.swift
//  Editor6Shell
//
//  Created by Hoon H. on 2017/06/11.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Editor6Features
import Editor6MainMenuUI2
import AppKit

public final class AppShell: Shell {
    public override weak var features: Features? { didSet {} }
    public override init() {
        super.init()
    }
}

public class Shell {
    public weak var features: Features? {
        didSet {
            (features != nil ? startFeatures() : endFeatures())
        }
    }

    private let mainMenuUI = MainMenuUI2Controller()

    init() {
        NSApplication.shared().mainMenu = mainMenuUI.menu
    }
    deinit {
        NSApplication.shared().mainMenu = nil
    }

    private func startFeatures() {
        var s = MainMenuUI2State()
        s.availableItems.insert(.fileNewWorkspace)
        mainMenuUI.reload(s)
    }
    private func endFeatures() {
        let s = MainMenuUI2State()
        mainMenuUI.reload(s)
    }
}
