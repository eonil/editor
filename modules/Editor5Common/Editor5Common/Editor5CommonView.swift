//
//  Editor5CommonView.swift
//  Editor5Common
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

open class Editor5CommonView: NSView {
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
        super.autoresizesSubviews = false
        super.translatesAutoresizingMaskIntoConstraints = false
    }
    private func terminate() {
    }

    @objc
    @available(*,unavailable)
    open override var autoresizesSubviews: Bool {
        willSet {
            assert(newValue == false)
        }
    }
    @objc
    @available(*,unavailable)
    open override var translatesAutoresizingMaskIntoConstraints: Bool {
        willSet {
            assert(newValue == false)
        }
    }

    /// Intended to be overriden.
    open func editor5_layoutSubviews() {
    }

    @objc
    @available(*,unavailable)
    open override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
    }
    @objc
    @available(*,unavailable)
    open override func resize(withOldSuperviewSize oldSize: NSSize) {
        super.resize(withOldSuperviewSize: oldSize)
    }
    @objc
    @available(*,unavailable)
    open override func layout() {
        super.layout()
        if frame.size != lastSize {
            editor5_layoutSubviews()
            lastSize = frame.size
        }
    }
}
