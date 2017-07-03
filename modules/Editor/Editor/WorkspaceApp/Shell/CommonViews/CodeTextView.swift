//
//  CodeTextView.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/30.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

@IBDesignable
final class CodeTextView: CommonNIBBasedView {

    @IBOutlet weak var textView: NSTextView?

    override init(frame frameRect: NSRect) {
        super.init("CodeTextView", Bundle(for: type(of: self)))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func didLoadContentView() {
        super.didLoadContentView()
        let sz = NSFont.systemFontSize()
        textView?.font = NSFont.userFixedPitchFont(ofSize: sz)
        textView?.string = "OK"
    }
}
