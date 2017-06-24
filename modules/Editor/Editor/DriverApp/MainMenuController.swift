//
//  MainMenuController.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit
import EonilSignet

final class MainMenuController: NSObject {
    let event = Relay<Event>()

    @IBOutlet var menu: NSMenu? {
        didSet {
            NSApplication.shared().mainMenu = menu
        }
    }

    override init() {
        super.init()
        let nib = NSNib(nibNamed: "MainMenu", bundle: Bundle(for: type(of: self)))!
        nib.instantiate(withOwner: self, topLevelObjects: nil)
    }
    deinit {
//        NSApplication.shared().mainMenu = nil
    }

    @IBAction private func makeRandomFiles(_: AnyObject?) {
        event.cast(.click(.testdriveMakeRandomFiles))
    }
}
extension MainMenuController {
    enum Event {
        case click(MainMenuItemID)
    }
}
