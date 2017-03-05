//
//  Editor6CommonView.swift
//  Editor6Common
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

///
/// - Note:
///     Supports both of manual and auto layout.
///
open class Editor6CommonView: NSView {
    private var lastSize = CGSize.zero

    @objc
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initiate()
    }
    @objc
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initiate()
    }
    deinit {
        terminate()
    }

    private func initiate() {
        super.autoresizesSubviews = true
        super.translatesAutoresizingMaskIntoConstraints = false
        editor6_installSubviews()
        let cs = editor6_makeIgnorableConstraints()
        for c in cs {
            c.priority = NSLayoutPriorityRequired - 1
            c.isActive = true
        }
    }
    private func terminate() {
    }

    @objc
    @available(*,unavailable)
    open override var autoresizesSubviews: Bool {
        willSet {
            assert(newValue == true)
        }
    }
    @objc
    @available(*,unavailable)
    open override var translatesAutoresizingMaskIntoConstraints: Bool {
        willSet {
            assert(newValue == false)
        }
    }

    ///
    /// - Note:
    ///     Intended to be overriden for manual layout.
    ///
    ///
    open func editor6_installSubviews() {
    }

    ///
    /// - Note:
    ///     Intended to be overriden for manual layout.
    ///
    ///
    open func editor6_layoutSubviews() {
    }
    ///
    /// - Note:
    ///     Intended to be overriden for auto layout.
    ///
    open func editor6_makeIgnorableConstraints() -> [NSLayoutConstraint] {
        return []
    }

    @objc
    @available(*,unavailable)
    open override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        editor6_layoutSubviews()
    }
    @objc
    @available(*,unavailable)
    open override func resize(withOldSuperviewSize oldSize: NSSize) {
        super.resize(withOldSuperviewSize: oldSize)
//        editor6_layoutSubviews()
    }

//    @objc
//    @available(*,unavailable)
//    open override func layout() {
//        // https://developer.apple.com/library/content////releasenotes/AppKit/RN-AppKit/index.html#10_12Layout
////        super.layout()
//        editor6_layoutSubviews()
////        needsLayout = true
//        if frame.size != lastSize {
//            editor6_layoutSubviews()
//            lastSize = frame.size
//        }
//    }
}
