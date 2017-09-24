//
//  CodeTextView2.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit
import SnapKit

final class CodeTextView2: NSView {
    private let scrollView = NSScrollView()
    private let textView = NSTextView()

    private func install() {
        addSubview(scrollView)
        scrollView.hasHorizontalScroller = true
        scrollView.hasVerticalScroller = true
        scrollView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        scrollView.documentView = textView
        textView.isEditable = false
        textView.isAutomaticDataDetectionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isHorizontallyResizable = true
        textView.isVerticallyResizable = true


        textView.textContainer?.widthTracksTextView = false
        textView.textContainer?.heightTracksTextView = false
        textView.textContainer?.containerSize = CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude)
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        install()
    }
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        install()
    }

    var string = "" {
        didSet {
            let f = NSFont.userFixedPitchFont(ofSize: NSFont.systemFontSize) ?? .default
//            let f = NSFont(name: "Menlo", size: NSFont.systemFontSize()) ?? .default
            let s = NSAttributedString(string: string, attributes: [
                NSAttributedStringKey.font: f,
                ])
            guard let r = textView.textStorage?.wholeRange else { return }
            textView.textStorage?.deleteCharacters(in: r)
            textView.textStorage?.append(s)
            textView.string = string
        }
    }
}

private extension NSTextStorage {
    var wholeRange: NSRange {
        return NSRange(location: 0, length: length)
    }
}

private extension NSFont {
    static var `default`: NSFont {
        return NSFont.systemFont(ofSize: NSFont.systemFontSize)
    }
}
