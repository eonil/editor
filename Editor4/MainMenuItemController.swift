//
//  MainMenuItemController.swift
//  Editor3
//
//  Created by Hoon H. on 2016/04/18.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

enum MainMenuItemTypeID {
    case Separator
    case Submenu(MainMenuSubmenuID)
    case MenuItem(MainMenuCommand)
}
private extension MainMenuItemTypeID {
    private func getTitle() -> String? {
        switch self {
        case .Separator:            return nil
        case .Submenu(let id):      return id.getLabel()
        case .MenuItem(let transaction): return transaction.getLabel()
        }
    }
}

final class MainMenuItemController: DriverAccessible {

    private let type: MainMenuItemTypeID
    let item: NSMenuItem
    private let delegate = MenuItemDelegate()

    var subcontrollers: [MainMenuItemController] {
        willSet {
            item.submenu?.removeAllItems()
            item.submenu = nil
        }
        didSet {
            assert(type.getTitle() != nil)
            let m = NSMenu(title: type.getTitle() ?? "")
            m.autoenablesItems = false
            for s in subcontrollers {
                m.addItem(s.item)
                item.submenu = m
            }
        }
    }

    init(type: MainMenuItemTypeID) {
        self.type = type
        switch type {
        case .Separator:
            item = NSMenuItem.separatorItem()
            subcontrollers = []

        case .Submenu(let id):
            item = NSMenuItem()
            subcontrollers = []
            item.enabled = false
            item.title = id.getLabel()

        case .MenuItem(let command):
            item = NSMenuItem()
            subcontrollers = []
            item.enabled = false
            item.title = command.getLabel()
            item.keyEquivalentModifierMask = Int(bitPattern: command.getKeyModifiersAndEquivalentPair().keyModifier.rawValue)
            item.keyEquivalent = command.getKeyModifiersAndEquivalentPair().keyEquivalent
            item.target = delegate
            item.action = #selector(MenuItemDelegate.EDITOR_onClick(_:))
            delegate.command = command
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
//private extension MainMenuTransaction {
//    private func makeItemController() -> MenuItemController {
//        return MenuItemController(code: self)
//    }
//}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private final class MenuItemDelegate: NSObject, DriverAccessible {
    var command: MainMenuCommand?
    @objc
    private func EDITOR_onClick(_: AnyObject?) {
        guard let command = command else {
            reportErrorToDevelopers("A menu item has been clicked but it has no bounded ID.")
            return
        }
        dispatch(Command.MainMenu(command))
    }
}


















