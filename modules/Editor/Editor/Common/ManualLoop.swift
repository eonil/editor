//
//  ManualLoop.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/24.
//  Copyright © 2017 Eonil. All rights reserved.
//

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
final class ManualLoop {
    var step: (() -> Void)?
    private var isStepping = false
    private var scheduledSteppingCount = 0

    init() {
    }
    convenience init(_ s: @escaping () -> Void) {
        self.init()
        step = s
    }

    ///
    /// Let the loop iterate eventually.
    ///
    func signal() {
        //
        // Provide re-entrancy.
        //
        guard let s = step else { return }
        guard isStepping == false else {
            scheduledSteppingCount += 1
            return
        }
        scheduledSteppingCount += 1
        while scheduledSteppingCount > 0 {
            isStepping = true
            s()
            isStepping = false
            scheduledSteppingCount -= 1
        }
    }
}
