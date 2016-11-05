//
//  AppKit.NSMenuItem.TargetActionUtility.swift
//  Editor6Common
//
//  Created by Hoon H. on 2016/11/05.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import ObjectiveC

public extension NSMenuItem {
    /// Sent on target-action invocation.
    /// Calling this method will reset `target` and `action` property
    /// to some internal values.
    public func delegate(to newDelegate: @escaping () -> ()) {
        let newContext = Editor6Common_TargetActionContext()
        newContext.delegate = newDelegate
        target = newContext
        action = #selector(Editor6Common_TargetActionContext.editor6_onTargetAction(_:))
        objc_setAssociatedObject(newContext,
                                 Editor6Common_TargetActionContextIDPtr,
                                 newContext,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

/// Intentionally leaked.
private let Editor6Common_TargetActionContextIDPtr = UnsafeMutableRawPointer.allocate(bytes: 1, alignedTo: 1)

private final class Editor6Common_TargetActionContext: NSObject {
    var delegate: (() -> ())?
    @objc
    fileprivate func editor6_onTargetAction(_: NSObject) {
        delegate?()
    }
}
