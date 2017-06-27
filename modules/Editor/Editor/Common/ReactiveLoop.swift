//
//  ReactiveLoop.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/25.
//  Copyright © 2017 Eonil. All rights reserved.
//

///
///
///
final class ReactiveLoop {
    private let impl = ManualLoop()
    fileprivate let watch = Relay<()>()
    init() {
        watch.delegate = { [weak self] in self?.signal() }
    }
    var step: (() -> Void)? {
        get { return impl.step }
        set { impl.step = newValue }
    }
    func signal() {
        impl.signal()
    }
}

func += (_ a: Relay<()>, _ b: ReactiveLoop) {
    a += b.watch
}
func -= (_ a: Relay<()>, _ b: ReactiveLoop) {
    a -= b.watch
}

