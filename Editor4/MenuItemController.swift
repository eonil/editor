//
//  MenuItemController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit

enum MenuItemTypeID {
    case Separator
    case Submenu(MenuSubmenuID)
    case MenuItem(MenuCommand)
}
private extension MenuItemTypeID {
    private func getTitle() -> String? {
        switch self {
        case .Separator:            return nil
        case .Submenu(let id):      return id.getLabel()
        case .MenuItem(let action): return action.getLabel()
        }
    }
}

final class MenuItemController: DriverAccessible {
    private let type: MenuItemTypeID
    let item: NSMenuItem
    private let delegate = MenuItemDelegate()

    var subcontrollers: [MenuItemController] {
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

    init(type: MenuItemTypeID) {
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
            item.keyEquivalentModifierMask = Int(bitPattern: command.getKeyModifiersAndKeyEquivalentPair().keyModifier.rawValue)
            item.keyEquivalent = command.getKeyModifiersAndKeyEquivalentPair().keyEquivalent
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



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private final class MenuItemDelegate: NSObject, DriverAccessible {
    var command: MenuCommand?
    @objc
    private func EDITOR_onClick(_: AnyObject?) {
        guard let command = command else {
            reportErrorToDevelopers("A menu item has been clicked but it has no bounded ID.")
            return
        }
        driver.run(UserOperationCommand.RunMenuItem(command))
    }
}


















