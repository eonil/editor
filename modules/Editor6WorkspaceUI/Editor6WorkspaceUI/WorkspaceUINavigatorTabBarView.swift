//
//  WorkspaceUINavigatorTabBarView.swift
//  Editor6WorkspaceUI
//
//  Created by Hoon H. on 2016/10/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox
import ManualView
import Editor6Common

final class WorkspaceUINavigatorTabBarView: ManualView, ManualFitting {
    private typealias Button = WorkspaceUINavigatorTabBarButton
    private let stack = ManualStackView()
    private let fileButton = Button(label: "File")
    private let issueButton = Button(label: "Issues")
    private let debugButton = Button(label: "Debug")
    private var installer = ViewInstaller()

    private func getAllButtons() -> [Button] {
        return [
            fileButton,
            issueButton,
            debugButton,
        ]
    }
    override func manual_installSubviews() {
        super.manual_installSubviews()
        addSubview(stack)
        let GAP = CGFloat(4)
        stack.reload(ManualStackViewState(axis: .x, segments: [
            ManualStackViewSegment(fitting: fileButton),
            ManualStackViewSegment(holding: GAP),
            ManualStackViewSegment(fitting: issueButton),
            ManualStackViewSegment(holding: GAP),
            ManualStackViewSegment(fitting: debugButton),
            ]))
    }
    override func manual_layoutSubviews() {
        super.manual_layoutSubviews()
        stack.frame = bounds.resizedInY(by: -4)
    }
    func manual_fittingSize() -> CGSize {
        return stack.manual_fittingSize().added(height: 4)
    }
}

fileprivate final class WorkspaceUINavigatorTabBarButton: ManualView, ManualFitting {
    private let container = CALayer()
    private let text = ManualLabel()
    private let border = CAShapeLayer()
    private var installer = ViewInstaller()

    convenience init(label: String) {
        self.init()
        let a = label.attributed()
            .fontedWithSystemFontOf(size: .smallSystem)
            .foregroundColored(NSAttributedString.Color.black)
        text.reload(a)
    }
    fileprivate override func manual_installSubviews() {
        super.manual_installSubviews()
        addSubview(text)
        layer = container
        container.addSublayer(border)
    }
    fileprivate override func manual_layoutSubviews() {
        super.manual_layoutSubviews()
        text.frame = bounds
        border.cornerRadius = 4
        border.frame = bounds
        border.borderWidth = 1
        border.borderColor = NSColor.black.cgColor
    }
    fileprivate func manual_fittingSize() -> CGSize {
        return text.manual_fittingSize().added(width: 6).added(height: 4)
    }
}

