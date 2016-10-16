//
//  ManualTextLine.swift
//  AutolayoutExcercise1
//
//  Created by Hoon H. on 2016/10/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import CoreGraphics
import CoreText

public struct ManualCoreTextLineViewState {
    public var line = CTLine?.none
    public var boundOptions = CTLineBoundsOptions([])
    public var fitToPointGrid = true
    fileprivate var cachedTextBounds = CGRect?.none
    public init() {}
    public init(line: CTLine, boundOptions: CTLineBoundsOptions = []) {
        self.line = line
        self.boundOptions = boundOptions
    }
}

/// A `ManuaView` which draws a `CTLine`.
public final class ManualCoreTextLineView: ManualView {
    fileprivate var localState = ManualCoreTextLineViewState()
    func reload(_ newState: CTLine?) {
        var newCopy = localState
        newCopy.line = newState
        reload(newCopy)
    }
    func reload(_ newState: ManualCoreTextLineViewState) {
        localState = newState
        setNeedsDisplay(bounds)
    }
    fileprivate func resolveBoundsAndCacheIfPossibleAndNeeded() {
        if localState.cachedTextBounds == nil {
            if let line = localState.line {
                let textBounds = CTLineGetBoundsWithOptions(line, localState.boundOptions)
                localState.cachedTextBounds = textBounds
            }
        }
    }

    @objc
    @available(*,unavailable)
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard let line = localState.line else { return }
        guard let ctx = NSGraphicsContext.current()?.cgContext else { return }
        resolveBoundsAndCacheIfPossibleAndNeeded()
        guard let textBounds = localState.cachedTextBounds else { return }
        var p = bounds.origin
        p.x += textBounds.origin.x
        p.y -= textBounds.origin.y
        if localState.fitToPointGrid {
            let dx = (bounds.size.width - textBounds.size.width) / 2
            let dy = (bounds.size.height - textBounds.size.height) / 2
            p.x += dx
            p.y += dy
        }
        ctx.textPosition = p
        CTLineDraw(line, ctx)
    }
    public override func manual_layoutSubviews() {
        super.manual_layoutSubviews()
    }
}

extension ManualCoreTextLineView: ManualFitting {
    public func manual_fittingSize() -> CGSize {
        resolveBoundsAndCacheIfPossibleAndNeeded()
        guard let textBounds = localState.cachedTextBounds else { return CGSize.zero }
        let occupyingSize = CGSize(width: textBounds.maxX - textBounds.minX,
                                   height: textBounds.maxY - textBounds.minY)
        let finalSize = localState.fitToPointGrid ? occupyingSize.fittingToPointGrid() : occupyingSize
        return finalSize
    }
}

fileprivate extension CGSize {
    func fittingToPointGrid() -> CGSize {
        return CGSize(width: width.ceiling(),
                      height: height.ceiling())
    }
}
fileprivate extension CGFloat {
    func ceiling() -> CGFloat {
        return ceil(self)
    }
}









