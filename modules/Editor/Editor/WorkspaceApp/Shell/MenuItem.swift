//
//  MenuItem.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/27.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class CommandMenu<Command>: NSMenu where Command: Hashable {
    func setDelegateToAllNodes(_ signal: @escaping (Command) -> Void) {
        applyToAllCommandMenuItems({ cmi, c in
            cmi.signal = { signal(c) }
        })
    }
//    /// O(n) where n is total number of nodes in menu tree.
//    func setCommandEnabled(_ f: @autoclosure (Command) -> Bool) {
//        applyToAllCommandMenuItems({ cmi, cmd in
//            cmi.isEnabled = f(cmd)
//        })
//    }
//    func setCommandEnabled(_ c: Command, _ newState: Bool) {
//        applyToAllCommandMenuItems({ cmi, cmd in
//            guard c == cmd else { return }
//            cmi.isEnabled = newState
//        })
//    }
    func resetEnabledCommands(_ set: Set<Command>) {
        applyToAllCommandMenuItems({ cmi, cmd in
            cmi.isEnabled = set.contains(cmd)
        })
    }


    private func applyToAllCommandMenuItems(_ f: (CommandMenuItem<Command>, Command) -> Void) {
        for mi in items {
            guard let cmi = mi as? CommandMenuItem<Command> else { continue }
            guard let c = cmi.command else { continue }
            f(cmi, c)
            (cmi.submenu as? CommandMenu<Command>)?.applyToAllCommandMenuItems(f)
        }
    }
}
final class CommandMenuItem<Command>: NSMenuItem {
    var command: Command?
    var signal: (() -> Void)? {
        didSet {
            if signal != nil {
                target = self
                action = #selector(onAction(_:))
            }
            else {
                target = nil
                action = nil
            }
        }
    }
    @objc
    private func onAction(_: NSObject?) {
        signal?()
    }
}
extension CommandMenuItem {
    convenience init(command c: Command, title t: String) {
        self.init(title: t, action: nil, keyEquivalent: "")
        command = c
        isEnabled = false
    }
}
extension NSMenu {
    func setItems(_ newMenuItems: [NSMenuItem]) {
        removeAllItems()
        newMenuItems.forEach({ addItem($0) })
    }
}
extension NSMenuItem {
    static func group(_ title: String, _ subitems: [NSMenuItem]) -> NSMenuItem {
        let m = NSMenuItem()
        let m1 = NSMenu()
        m.title = title
        m.menu = m1
        m1.setItems(subitems)
        return m
    }
}
