//
//  ContextMenuController.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/27.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit
//
//class ContextMenuController<Command> where Command: ContextMenuItemCommandProtocol {
//    let signal = Relay<Command>()
//    let menu = NSMenu()
//    private var mm = [Command: NSMenuItem]()
//
//    init() {
//        Command.makeMenuItems().forEach { m in
//            let m1 = DelegatedMenuItem()
//            m1.title = m.title
//            switch m {
//            case .command(let c):
//                m1.delegate = { [weak self] in self?.signal.cast(c) }
//                mm[c] = m1
//                menu.addItem(m1)
//            case .group(let title, let items):
//                m1.title = title
//
//            case .separator:
//            default:
//                break
//            }
//        }
//    }
//    func setCommandEnabled(_ command: Command, _ newState: Bool) {
//        mm[command]!.isEnabled = newState
//    }
//}

//enum MenuItemDef<Command> where Command: MenuItemCommandProtocol {
//    case command(Command)
//    case group(title: String, items: [ContextMenuItem<Command>])
//    case separator
//
//    var title: String {
//        switch self {
//        case .command(let c):       return c.title
//        case .group(let title, _):  return title
//        case .separator:            return ""
//        }
//    }
//    func makeMenuItem(_ delegate: @escaping (MenuItemDef<Command>) -> Void) -> (NSMenuItem, [Command: NSMenuItem]) {
//        switch m {
//        case .command(let c):
//            let m1 = DelegatedMenuItem()
//            m1.title = m.title
//            m1.delegate = { delegate(self) }
//            return (m1, [c: m1])
//        case .group(let title, let items):
//            let m1 = DelegatedMenuItem()
//            m1.title = m.title
//            m1.title = title
//            let sm = NSMenu()
//            sm.items = items.map({ $0.makeManuItem(delegate) })
//            m1.submenu = sm
//            return m1
//        case .separator:
//            return NSMenuItem.separator()
//        }
//    }
//}

//protocol MenuItemCommandProtocol: Hashable {
//    var title: String { get }
//}
