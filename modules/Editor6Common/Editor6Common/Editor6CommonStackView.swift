//
//  Editor6CommonStackView.swift
//  Editor6Common
//
//  Created by Hoon H. on 2016/10/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

public final class Editor6CommonStackView: NSStackView {
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        init2()
    }
    public required init?(coder: NSCoder) {
        fatalError()
    }
    @objc
    @available(*,unavailable)
    public override var autoresizesSubviews: Bool {
        willSet { assert(newValue == true) }
    }
//    @objc
//    @available(*,unavailable)
//    public override var autoresizingMask: NSAutoresizingMaskOptions {
//        willSet { assert(newValue == makeFreeformAutoresizingMask()) }
//    }
    @objc
    @available(*,unavailable)
    public override var translatesAutoresizingMaskIntoConstraints: Bool {
        willSet { assert(newValue == false) }
    }
//    public override func addArrangedSubview(_ view: NSView) {
//        super.addArrangedSubview(view)
//    }
    @available(*,unavailable)
    public override func addSubview(_ view: NSView) {
        super.addSubview(view)
    }

    private func init2() {
        super.autoresizesSubviews = true
//        super.autoresizingMask = makeFreeformAutoresizingMask()
        super.translatesAutoresizingMaskIntoConstraints = false
    }
}

//private func makeFreeformAutoresizingMask() -> NSAutoresizingMaskOptions {
//    return [
//        .viewWidthSizable,
//        .viewHeightSizable,
//        .viewMinXMargin,
//        .viewMaxXMargin,
//        .viewMinYMargin,
//        .viewMaxYMargin
//    ]
//}
