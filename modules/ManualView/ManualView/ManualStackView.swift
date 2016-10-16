//
//  ManualStackView.swift
//  AutolayoutExcercise1
//
//  Created by Hoon H. on 2016/10/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

//public enum ManualStackViewSegment {
//    case compressablePlaceholder
//    case placeholder(CGSize)
//    case view(ManualView)
//}
public enum ManualStackViewAlignment {
    case fill
    case center
//    case clip
    case left
    case right
    case top
    case bottom
}

/// A segment.
///
/// Basically a segment try to occupy smallest region 
/// as little as possible.
///
/// A segment have multiple occupations.
///
/// - Holding size.
/// - filling proportion.
///
/// And treats them all required sizes. So it chooses maximum 
/// size in available occupations.
///
/// View's current size won't be considered because it changes
/// as a result of layout.
///
public struct ManualStackViewSegment {
    fileprivate var containedView = NSView?.none
    /// If view conforms `ManualFitting`, its `fittingSize` will be used
    /// before considering `holdingLength`.
    fileprivate var fitToView = false
    fileprivate var holdingLength = CGFloat(0)
    fileprivate var fillingProportion = CGFloat(0)
    /// View will be aligned within occupation frame resolved.
    public var alignment = ManualStackViewAlignment.fill
    public init() {}
    public init<V: ManualView>(fitting: V, alignment: ManualStackViewAlignment = .fill) where V: ManualFitting {
        self.containedView = fitting
        self.fitToView = true
        self.alignment = alignment
    }
    public init(view: NSView, holding length: CGFloat, alignment: ManualStackViewAlignment = .fill) {
        self.containedView = view
        self.holdingLength = length
        self.alignment = alignment
    }
    public init(view: NSView, filling proportion: CGFloat) {
        self.containedView = view
        self.fillingProportion = proportion
    }
    public init(holding length: CGFloat) {
        self.holdingLength = length
    }
    public init(filling proportion: CGFloat) {
        self.fillingProportion = proportion
    }
    public init(filling view: NSView) {
        self.containedView = view
        self.alignment = .fill
        self.fillingProportion = 1
    }
}
public struct ManualStackViewState {
    public var axis = ManualAxis.x
    public var segments = [ManualStackViewSegment]()
    public init() {}
    public init(axis: ManualAxis) {
        self.axis = axis
    }
    public init(axis: ManualAxis, segments: [ManualStackViewSegment]) {
        self.axis = axis
        self.segments = segments
    }
    public func spaced(_ space: CGFloat) -> ManualStackViewState {
        var copy = self
        copy.segments.removeAll(keepingCapacity: true)
        for s in segments.dropLast() {
            copy.segments.append(s)
            copy.segments.append(ManualStackViewSegment(holding: space))
        }
        if let l = segments.last {
            copy.segments.append(l)
        }
        return copy
    }
}
fileprivate extension ManualStackViewSegment {
    func getRigidOccupation(in axis: ManualAxis) -> CGFloat {
        guard fitToView else { return holdingLength }
        guard let v = containedView as? ManualFitting else { return holdingLength }
        return v.manual_fittingSize().length(in: axis)
    }
}
fileprivate extension ManualStackViewState {
    func getSegmentLengths(in budget: CGFloat) -> [CGFloat] {
        let rigidOccupations = segments.map({ $0.getRigidOccupation(in: axis) })
        let rigidOccupationSum = rigidOccupations.reduce(0, +)
        let softOccupationBudget = max(0, budget - rigidOccupationSum)
        let softProportionSum = segments.map({ $0.fillingProportion }).reduce(0, +)
        let softOccupations = segments.map({ (softProportionSum == 0 ? 0 : ($0.fillingProportion / softProportionSum)) * softOccupationBudget })
        precondition(rigidOccupations.count == softOccupations.count)
        let segmentOccupations = zip(rigidOccupations, softOccupations).map(Swift.max)
        return segmentOccupations
    }
    func getSegmentFrames(in bounds: CGRect) -> [CGRect] {
        let lengths = getSegmentLengths(in: bounds.size.length(in: axis))
        let frames = bounds.splitting(at: CGPoint(x: bounds.midX, y: bounds.midY), by: lengths, in: axis)
        return frames
    }
}
fileprivate extension CGRect {
    func splitting(at origin: CGPoint, by lengths: [CGFloat], in axis: ManualAxis) -> [CGRect] {
        var x = origin.x
        var y = origin.y
        var rects = [CGRect]()
        switch axis {
        case .x:
            let ww = lengths.reduce(0, +)
            let hh = height
            x -= ww / 2
            y -= hh / 2
            for len in lengths {
                let r = CGRect(x: x, y: y, width: len, height: hh)
                rects.append(r)
                x += len
            }
        case .y:
            let ww = width
            let hh = lengths.reduce(0, +)
            x -= ww / 2
            y -= hh / 2
            for len in lengths {
                let r = CGRect(x: x, y: y, width: ww, height: len)
                rects.append(r)
                y += len
            }
        }
        return rects
    }
}

public final class ManualStackView: ManualView, ManualFitting {
    private var localState = ManualStackViewState()
    public func reload(_ newState: ManualStackViewState) {
        let oldElementViews = Set(localState.segments.flatMap({ $0.containedView }))
        let newElementViews = Set(newState.segments.flatMap({ $0.containedView }))
        let removings = oldElementViews.subtracting(newElementViews)
        let addings = newElementViews.subtracting(oldElementViews)
        for v in removings {
            v.removeFromSuperview()
        }
        for v in addings {
            super.addSubview(v)
        }
        localState = newState
        manual_setNeedsLayout()
    }
    public override func manual_layoutSubviews() {
        super.manual_layoutSubviews()
        let frames = localState.getSegmentFrames(in: bounds)
        for i in 0..<frames.count {
            let segment = localState.segments[i]
            if let v = segment.containedView {
                let frame = frames[i]
                let viewSize = (v as? ManualFitting)?.manual_fittingSize() ?? frame.size
                let newFrame = frame.placed(size: viewSize, alignment: segment.alignment)
                v.frame = newFrame
            }
        }
    }
    public func manual_fittingSize() -> CGSize {
        let w = localState.segments.map({ $0.getRigidOccupation(in: localState.axis) }).reduce(0, +)
        let h = localState.segments.map({ $0.getRigidOccupation(in: localState.axis.perpendicular()) }).reduce(0, Swift.max)
        return CGSize(width: w, height: h)
    }
    @objc
    @available(*, unavailable)
    public override func addSubview(_ view: NSView) {
        super.addSubview(view)
    }
    @objc
    @available(*, unavailable)
    public override func addSubview(_ view: NSView, positioned place: NSWindowOrderingMode, relativeTo otherView: NSView?) {
        super.addSubview(view, positioned: place, relativeTo: otherView)
    }
    @objc
    @available(*, unavailable)
    public override var subviews: [NSView] {
        didSet {}
    }
    @objc
    @available(*, unavailable)
    public override func didAddSubview(_ subview: NSView) {
        super.didAddSubview(subview)
    }
    @objc
    @available(*, unavailable)
    public override func willRemoveSubview(_ subview: NSView) {
        super.willRemoveSubview(subview)
    }
}

public enum ManualAxis {
    case x
    case y
    func perpendicular() -> ManualAxis {
        switch self {
        case .x:    return .y
        case .y:    return .x
        }
    }
}

fileprivate extension CGSize {
    func length(in axis: ManualAxis) -> CGFloat {
        switch axis {
        case .x:    return width
        case .y:    return height
        }
    }
}

fileprivate extension EdgeInsets {
    func getSizeDelta(in axis: ManualAxis) -> CGFloat {
        switch axis {
        case .x:    return -(left + right)
        case .y:    return -(top + bottom)
        }
    }
}
fileprivate extension CGSize {
    func applied(_ edgeInsets: EdgeInsets) -> CGSize {
        return CGSize(width: width - (edgeInsets.left + edgeInsets.right),
                      height: height - (edgeInsets.top + edgeInsets.bottom))
    }
}

fileprivate extension CGRect {
    init(center: CGPoint, size: CGSize) {
        self = CGRect(x: center.x - size.width / 2,
                      y: center.y - size.height / 2,
                      width: size.width,
                      height: size.height)
    }
    var midPoint: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    func placed(size: CGSize, alignment: ManualStackViewAlignment) -> CGRect {
        func getMinXIfCentered() -> CGFloat {
            return midX - size.width / 2
        }
        func getMinYIfCentered() -> CGFloat {
            return midY - size.height / 2
        }
        switch alignment {
        case .fill:     return self
        case .center:   return CGRect(center: midPoint, size: size)
        case .left:     return CGRect(x: minX, y: getMinYIfCentered(), width: size.width, height: size.height)
        case .right:    return CGRect(x: maxX - size.width, y: getMinYIfCentered(), width: size.width, height: size.height)
        case .top:      return CGRect(x: getMinXIfCentered(), y: minY, width: size.width, height: size.height)
        case .bottom:   return CGRect(x: getMinXIfCentered(), y: maxY - size.height, width: size.width, height: size.height)
        }
    }
}














