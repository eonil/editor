//
//  ToolButtonStripView.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/07.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox

final class ToolButtonStripView: CommonView {
	var toolButtons: [CommonView] = [] {
		willSet {
            toolButtons.forEach({  $0.removeFromSuperview() })
		}
		didSet {
            toolButtons.forEach({ addSubview($0) })
            renderLayout()
		}
	}
	var interButtonGap: CGFloat = 0 {
        didSet {
            renderLayout()
		}
	}

    override func sizeThatFits(size: CGSize) -> CGSize {
        return getButtonMinimalSizes().minimalEnclosingSize(interButtonGap)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        renderLayout()
    }
}

private extension ToolButtonStripView {
    @nonobjc
    private func renderLayout() {
        let buttonSizes = getButtonMinimalSizes()
        let enclosingSize = buttonSizes.minimalEnclosingSize(interButtonGap)
        var p = bounds.midPoint - (enclosingSize / 2)
        for (buttonSize, button) in zip(buttonSizes, toolButtons) {
            let buttonFrame = CGRect(origin: p, size: buttonSize)
            button.frame = buttonFrame
            p.x += buttonSize.width
        }
	}
    @nonobjc
    private func getButtonMinimalSizes() -> [CGSize] {
        return toolButtons
            .map({ b in b.sizeThatFits(CGSize.zero) })
    }
}

private extension CollectionType where Generator.Element == CGSize {
    func minimalEnclosingSize(interButtonGap: CGFloat) -> CGSize {
        return reduce(CGSize.zero, combine: { a, b in
            CGSize(width: (a.width + interButtonGap + b.width), height: max(a.height, b.height))
        })
    }
}









