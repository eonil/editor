//
//  NSView.extension.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/30.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

extension NSView {
    func pinToFillSuperview() {
        let a = self
        let b = AUDIT_unwrap(superview)
        a.translatesAutoresizingMaskIntoConstraints = false
        a.leftAnchor    .constraint(equalTo: b.leftAnchor)  .isActive = true
        a.rightAnchor   .constraint(equalTo: b.rightAnchor) .isActive = true
        a.topAnchor     .constraint(equalTo: b.topAnchor)   .isActive = true
        a.bottomAnchor  .constraint(equalTo: b.bottomAnchor).isActive = true
    }
}
