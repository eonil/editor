//
//  ReactiveLoop.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/25.
//  Copyright © 2017 Eonil. All rights reserved.
//

public final class ReactiveLoop {
    private let impl = ManualLoop2()
    fileprivate let watch = Relay<()>()
    public init() {
        watch.delegate = { [weak self] _ in self?.signal() }
    }
    public var step: (() -> Void)? {
        get { return impl.step }
        set { impl.step = newValue }
    }
    public func signal() {
        impl.signal()
    }
}

public func += (_ a: Relay<()>, _ b: ReactiveLoop) {
    a += b.watch
}
public func -= (_ a: Relay<()>, _ b: ReactiveLoop) {
    a -= b.watch
}

public func ADHOC_add(_ a: Relay<()>, _ b: ReactiveLoop) {
    a += b.watch
}
public func ADHOC_remove(_ a: Relay<()>, _ b: ReactiveLoop) {
    a -= b.watch
}
