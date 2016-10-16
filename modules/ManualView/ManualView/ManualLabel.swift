//
//  ManualLabel.swift
//  AutolayoutExcercise1
//
//  Created by Hoon H. on 2016/10/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

/// High level utility/convenience class.
public final class ManualLabel: ManualView, ManualFitting {
    private let ctt = ManualCoreTextLineView()

    public func reload(_ newState: NSAttributedString) {
        let line = CTLineCreateWithAttributedString(newState)
        let options = CTLineBoundsOptions([
//            .useOpticalBounds,
//            .excludeTypographicShifts,
//            .excludeTypographicLeading,
            ])
        let state = ManualCoreTextLineViewState(line: line, boundOptions: options)
        ctt.reload(state)
        addSubview(ctt)
        Swift.print("\(self)")
    }
    public override func manual_layoutSubviews() {
        super.manual_layoutSubviews()
        ctt.frame = bounds
    }
    public func manual_fittingSize() -> CGSize {
        return ctt.manual_fittingSize()
    }
}

