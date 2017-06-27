//
//  MenuItem.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/27.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class CommandMenu<T>: NSMenu where T: Equatable {
    func setDelegateToAllNodes(_ signal: @escaping (T) -> Void) {
        applyToAllCommandMenuItems({ cmi, c in
            cmi.signal = { signal(c) }
        })
    }
    func setCommandEnabled(_ c: T, _ newState: Bool) {
        applyToAllCommandMenuItems({ cmi, cmd in
            guard c == cmd else { return }
            cmi.isEnabled = newState
        })
    }
    private func applyToAllCommandMenuItems(_ f: (CommandMenuItem<T>, T) -> Void) {
        for mi in items {
            guard let cmi = mi as? CommandMenuItem<T> else { continue }
            guard let c = cmi.command else { continue }
            f(cmi, c)
            (cmi.submenu as? CommandMenu<T>)?.applyToAllCommandMenuItems(f)
        }
    }
}
final class CommandMenuItem<T>: NSMenuItem {
    var command: T?
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
    convenience init(command c: T, title t: String) {
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
