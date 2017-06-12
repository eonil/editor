//
//  DriverShell.swift
//  Editor6Shell
//
//  Created by Hoon H. on 2017/06/11.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Editor6Features
import Editor6MainMenuUI2
import AppKit

public final class AppDriverShell: DriverShell {
    public override weak var features: DriverFeatures? { didSet {} }
    public override init() {
        super.init()
    }
}

public class DriverShell {
    public weak var features: DriverFeatures? {
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

    }
    private func endFeatures() {

    }
}
