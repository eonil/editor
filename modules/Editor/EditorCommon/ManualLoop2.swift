//
//  AsyncManualLoop.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/29.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Dispatch
import EonilToolbox

///
/// A manually advancing loop device.
///
/// 1. Set `step`.
/// 2. Call `signal` when you want to advance the loop.
/// 3. You also can call `signal` in `step` function.
/// 4. `signal` take care of re-entrancy. `signal` call
///    Can be deferred if current stepping is not done
///    yet.
///
/// - You SHOULD NOT assume calling timing of `step`
///   function. It can be called at any time regardless
///   of call timing of `signal` function.
///
///
/// A manually advancing loop device.
///
/// 1. Set `step`.
/// 2. Call `signal` when you want to advance the loop.
/// 3. You also can call `signal` in `step` function.
/// 4. `signal` take care of re-entrancy. `signal` call
///    Can be deferred if current stepping is not done
///    yet.
///
/// - You SHOULD NOT assume calling timing of `step`
///   function. It can be called at any time regardless
///   of call timing of `signal` function.
///
public final class ManualLoop2 {
    public var step: (() -> Void)?
    private var isStepping = false
    private var isScheduled = false

    public init() {
    }
    public convenience init(_ s: @escaping () -> Void) {
        self.init()
        step = s
    }

    ///
    /// Let the loop iterate eventually.
    ///
    public func signal() {
        assertMainThread()
        //
        // Provide re-entrancy.
        //
        guard let s = step else { return }
        guard isStepping == false else {
            guard isScheduled == false else { return }
            isScheduled = true
            DispatchQueue.main.async(
                group: nil,
                qos: DispatchQoS.userInteractive,
                flags: [],
                execute: { [weak self] in self?.signal() })
            return
        }
        isScheduled = false
        isStepping = true
        s()
        isStepping = false
    }
}

private final class DisplayWatch {
    weak var owner: ManualLoop2?
    convenience init(with o: ManualLoop2) {
        self.init()
        owner = o
    }
    init() {
        try! DisplayLinkUtility.installMainScreenHandler(id: ObjectIdentifier(self)) { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.processDisplaySignal()
            }
        }
    }
    deinit {
        DisplayLinkUtility.deinstallMainScreenHandler(id: ObjectIdentifier(self))
    }
    private func processDisplaySignal() {
        assertMainThread()
        owner?.signal()
    }
}
