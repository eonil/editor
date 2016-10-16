//
//  ManualView.swift
//  AutolayoutExcercise1
//
//  Created by Hoon H. on 2016/10/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

/// A `NSWindow` which is compatible with `ManualView`.
open class ManualWindow: NSWindow {}

/// Removes all shit abstractions.
/// - Note:
///     You cannot use this view as a `NSWindow.contentView`.
open class ManualView: NSView {
    private var localState = LocalState()
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        init2()
    }
    public required init?(coder: NSCoder) {
        fatalError("IB/SB shit.")
    }
    private final func init2() {
        super.wantsLayer = true
        super.autoresizesSubviews = true
        super.autoresizingMask = []
        // Setting this to `false` cuases MISSING CONSTRAINT warning...
        // I don't know how to avoid it.
        super.translatesAutoresizingMaskIntoConstraints = true
        // Installing subviews in `layout` makes program unstable.
        // Avoid it.
        manual_installSubviews()
    }


    // Intended to be overriden.
    open func manual_layoutSubviews() {
    }
    /// Guaranteed to be called only once in this view's lifetime.
    open func manual_installSubviews() {
    }
    public final func manual_setNeedsLayout() {
        super.needsLayout = true
    }
    public final func manual_layoutIfNeeded() {
        super.layoutSubtreeIfNeeded()
    }
    open override func addSubview(_ view: NSView) {
        localState.assertAddingSubview()
        super.addSubview(view)
    }
    open override func addSubview(_ view: NSView, positioned place: NSWindowOrderingMode, relativeTo otherView: NSView?) {
        localState.assertAddingSubview()
        super.addSubview(view, positioned: place, relativeTo: otherView)
    }
    open override func draw(_ dirtyRect: NSRect) {
        localState.assertDrawing()
        super.draw(dirtyRect)
    }


    // MARK: Legacy shit.
    @objc
    @available(*,unavailable,message: "Legacy shit.")
    open override var wantsLayer: Bool {
        willSet { assert(newValue == true) }
    }
    @objc
    @available(*,unavailable,message: "Legacy shit.")
    open override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
    }
    @objc
    @available(*,unavailable,message: "Legacy shit.")
    open override func setFrameOrigin(_ newOrigin: NSPoint) {
        super.setFrameOrigin(newOrigin)
    }
    @objc
    @available(*,unavailable,message: "Legacy shit.")
    open override func setBoundsSize(_ newSize: NSSize) {
        super.setBoundsSize(newSize)
    }
    @objc
    @available(*,unavailable,message: "Legacy shit.")
    open override func setBoundsOrigin(_ newOrigin: NSPoint) {
        super.setBoundsOrigin(newOrigin)
    }
    @objc
    @available(*,unavailable,message: "Legacy shit.")
    open override var autoresizesSubviews: Bool {
        willSet { precondition(newValue == true) }
    }
    @objc
    @available(*,unavailable,message: "Legacy shit.")
    open override var autoresizingMask: NSAutoresizingMaskOptions {
        willSet { precondition(newValue == []) }
    }
    @objc
    @available(*,unavailable,message: "Legacy shit.")
    open override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
    }
    @objc
    @available(*,unavailable,message: "Legacy shit.")
    open override func resize(withOldSuperviewSize oldSize: NSSize) {
        super.resize(withOldSuperviewSize: oldSize)
    }

    // MARK: - Autolayout shit.

    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func layout() {
        localState.isPerformingLayout = true
        super.layout()
        manual_layoutSubviews()
        manual_setNeedsLayout()
        localState.isPerformingLayout = false
//        if self is ManualLabel {
//            Swift.print("\(self)")
//        }
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override var needsLayout: Bool {
        didSet {}
    }

    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override var fittingSize: NSSize {
        return super.fittingSize
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override var intrinsicContentSize: NSSize {
        return super.intrinsicContentSize
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func alignmentRect(forFrame frame: NSRect) -> NSRect {
        return super.alignmentRect(forFrame: frame)
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func frame(forAlignmentRect alignmentRect: NSRect) -> NSRect {
        return super.frame(forAlignmentRect: alignmentRect)
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override var alignmentRectInsets: EdgeInsets {
        return super.alignmentRectInsets
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override var baselineOffsetFromBottom: CGFloat {
        return super.baselineOffsetFromBottom
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override var firstBaselineOffsetFromTop: CGFloat {
        return super.firstBaselineOffsetFromTop
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override var lastBaselineOffsetFromBottom: CGFloat {
        return super.lastBaselineOffsetFromBottom
    }

    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func addLayoutGuide(_ guide: NSLayoutGuide) {
        super.addLayoutGuide(guide)
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override var layoutGuides: [NSLayoutGuide] {
        get { return super.layoutGuides }
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func removeLayoutGuide(_ guide: NSLayoutGuide) {
        super.removeLayoutGuide(guide)
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func contentHuggingPriority(for orientation: NSLayoutConstraintOrientation) -> NSLayoutPriority {
        return super.contentHuggingPriority(for: orientation)
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func setContentHuggingPriority(_ priority: NSLayoutPriority, for orientation: NSLayoutConstraintOrientation) {
        super.setContentHuggingPriority(priority, for: orientation)
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func contentCompressionResistancePriority(for orientation: NSLayoutConstraintOrientation) -> NSLayoutPriority {
        return super.contentCompressionResistancePriority(for: orientation)
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func setContentCompressionResistancePriority(_ priority: NSLayoutPriority, for orientation: NSLayoutConstraintOrientation) {
        super.setContentCompressionResistancePriority(priority, for: orientation)
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func addConstraint(_ constraint: NSLayoutConstraint) {
        super.addConstraint(constraint)
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func addConstraints(_ constraints: [NSLayoutConstraint]) {
        super.addConstraints(constraints)
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func removeConstraint(_ constraint: NSLayoutConstraint) {
        super.removeConstraint(constraint)
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func removeConstraints(_ constraints: [NSLayoutConstraint]) {
        super.removeConstraints(constraints)
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override var constraints: [NSLayoutConstraint] {
        get { return super.constraints }
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func constraintsAffectingLayout(for orientation: NSLayoutConstraintOrientation) -> [NSLayoutConstraint] {
        return super.constraintsAffectingLayout(for: orientation)
    }

    /// Use `manual_layoutIfNeeded()` instead of.
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func layoutSubtreeIfNeeded() {
        super.layoutSubtreeIfNeeded()
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func updateConstraintsForSubtreeIfNeeded() {
        super.updateConstraintsForSubtreeIfNeeded()
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func updateConstraints() {
        super.updateConstraints()
    }

    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override class func requiresConstraintBasedLayout() -> Bool {
        return super.requiresConstraintBasedLayout()
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override var translatesAutoresizingMaskIntoConstraints: Bool {
        willSet { precondition(newValue == true) }
    }

    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override var hasAmbiguousLayout: Bool {
        get { return super.hasAmbiguousLayout }
    }
    @objc
    @available(*,unavailable,message: "Autolayout shit.")
    open override func exerciseAmbiguityInLayout() {
        super.exerciseAmbiguityInLayout()
    }
}

public protocol ManualFitting {
    /// Final image can be drawn out of this size a bit.
    func manual_fittingSize() -> CGSize
}

fileprivate struct LocalState {
    var isPerformingLayout = false
    func assertAddingSubview() {
        assert(isPerformingLayout == false, "You cannot add subviews while performing layout.")
    }
    func assertDrawing() {
        assert(isPerformingLayout == false, "You cannot draw while performing layout.")
    }
}











