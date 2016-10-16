//
//  ManualTextField.swift
//  AutolayoutExcercise1
//
//  Created by Hoon H. on 2016/10/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

/// - Note:
///     This is an input field with predefined size. Cannot measure a fitting size.
///
public final class ManualTextField: ManualView {
    private let textField = NSTextField()
    public override func manual_installSubviews() {
        super.manual_installSubviews()
        addSubview(textField)
    }
    public override func manual_layoutSubviews() {
        super.manual_layoutSubviews()

        textField.frame = bounds
        textField.stringValue = "ldjn;dj;"
    }
}
