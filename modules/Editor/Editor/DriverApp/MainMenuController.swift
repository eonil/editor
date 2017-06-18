//
//  MainMenuController.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class MainMenuController: NSObject {
    @IBOutlet var menu: NSMenu? {
        didSet {
            NSApplication.shared().mainMenu = menu
        }
    }

    deinit {
        NSApplication.shared().mainMenu = nil
    }
}
