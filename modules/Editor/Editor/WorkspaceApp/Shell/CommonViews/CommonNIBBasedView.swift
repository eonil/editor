//
//  CommonNIBBasedView.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/30.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit


///
/// A view which loads an NIB at `init`.
///
/// This class intended to be subclassed.
///
/// - This object loads an NIB and configures itself by NIB
///   at `init`.
/// - No more configuration operation after `init`.
/// - NIB file with same name of class of this object will
///   be selected. "class" here means final concrete subclass.
/// Class name will be resolved by calling `NSStringFromClass` 
/// function.
///
///
/// - "current class" means class of current instance.
///
/// - NIB will be selected from same bundle which defines 
///   the final class.
/// - Top level object with no owner will be abandoned.
///
/// - This class support use in IB.
///
@IBDesignable
class CommonNIBBasedView: NSView {
    @IBOutlet
    weak var contentView: NSView?

    ///
    /// Designated initializer to instantiate this class
    /// with NIB loading. Other initializers won't load
    /// NIBs.
    ///
    init(_ nibName: String, _ nibBundle: Bundle) {
        super.init(frame: .zero)
        loadNIB(nibName, nibBundle)
    }
    ///
    /// Designated initializer.
    /// This initializer does not load NIB.
    /// But provided for overriding point.
    ///
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    ///
    /// Designated initializer.
    /// This initializer does not load NIB.
    ///
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func loadNIB(_ nibName: String, _ nibBundle: Bundle) {
        let nib = AUDIT_unwrap(NSNib(nibNamed: nibName, bundle: nibBundle))
        let r = nib.instantiate(withOwner: self, topLevelObjects: nil)
        AUDIT_check(r)
        if let cv = contentView {
            addSubview(cv)
            cv.pinToFillSuperview()
        }
        didLoadContentView()
    }

    func didLoadContentView() {

    }
}
extension CommonNIBBasedView {
    final class func makeWithInferredNIB() -> Self {
        let nibName = NSStringFromClass(self)
        let nibBundle = Bundle(for: self)
        return .init(nibName, nibBundle)
    }
}
