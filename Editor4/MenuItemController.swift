//
//  MenuItemController.swift
//  Editor3
//
//  Created by Hoon H. on 2016/04/18.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

final class MenuItemController: DriverAccessible {

    let id: MainMenuItemID
    let item: NSMenuItem
    private let delegate = MenuItemDelegate()

    var subcontrollers: [MenuItemController] {
        willSet {
            item.submenu?.removeAllItems()
            item.submenu = nil
        }
        didSet {
            let m = NSMenu(title: id.getLabel())
            m.autoenablesItems = false
            for s in subcontrollers {
                m.addItem(s.item)
                item.submenu = m
            }
        }
    }

    init(code: MainMenuItemID) {
        self.id = code
        switch code {
        case .Separator:
            item = NSMenuItem.separatorItem()
            subcontrollers = []

        default:
            item = NSMenuItem()
            subcontrollers = []
            item.enabled = false
            item.title = code.getLabel()
            item.keyEquivalentModifierMask = Int(bitPattern: code.getKeyModifiersAndEquivalentPair().keyModifier.rawValue)
            item.keyEquivalent = code.getKeyModifiersAndEquivalentPair().keyEquivalent
            item.target = delegate
            item.action = #selector(MenuItemDelegate.EDITOR_onClick(_:))
        }
    }
    var enabled: Bool {
        get {
            return item.enabled
        }
        set {
            item.enabled = newValue
        }
    }
}
//private extension MainMenuItemID {
//    private func makeItemController() -> MenuItemController {
//        return MenuItemController(code: self)
//    }
//}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private final class MenuItemDelegate: NSObject, DriverAccessible {
    var mainMenuItemID: MainMenuItemID?
    @objc
    private func EDITOR_onClick(_: AnyObject?) {
        guard let mainMenuItemID = mainMenuItemID else {
            reportErrorToDevelopers("A menu item clicked but has not bound ID.")
            return
        }
        dispatch(Action.Menu(mainMenuItemID))
    }
}


















