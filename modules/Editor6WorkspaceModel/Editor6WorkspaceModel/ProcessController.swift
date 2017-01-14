//
//  ProcessController.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/11/28.
//  Copyright © 2016 Eonil. All rights reserved.
//

final class ProcessController {
    private let lock = NSLock()
    private var _canContinue = true

    init() {
    }
    private(set) var canContinue: Bool {
        get {
            let r: Bool
            lock.lock()
            r = _canContinue
            lock.unlock()
            return r
        }
        set {
            lock.lock()
            _canContinue = newValue
            lock.unlock()
        }
    }
    func cancelAsSoonAsPossible() {
        canContinue = false
    }
}
