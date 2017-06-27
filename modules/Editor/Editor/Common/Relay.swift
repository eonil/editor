//
//  Relay.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/24.
//  Copyright © 2017 Eonil. All rights reserved.
//

///
/// State-less signal delivery.
///
/// A relay can accept signals from multiple origins.
/// A relay can send signals to multiple destinations.
///
public class Relay<T> {
    public var delegate: ((T) -> Void)?
    private weak var origin: Relay<T>?
    private var destinations = [Weak<Relay<T>>]()

    public init() {}
    deinit {
        // `source` could be already been dead at this point.
        origin?.remove(destination: self)
    }
    public func cast(_ signal: T) {
        delegate?(signal)
        // A receptor MUST be alive if it is still in the list.
        destinations.forEach({ $0.deref!.cast(signal) })
    }
    ///
    /// Attach a destination `Relay`.
    ///
    fileprivate func add(destination r: Relay<T>) {
        destinations.append(Weak(r))
    }
    ///
    /// Detach a destination `Relay`.
    ///
    fileprivate func remove(destination r: Relay<T>) {
        // A receptor MUST be alive if it is still in the list.
        assert(destinations.contains(where: { $0.deref! === r }) == true)
        destinations = destinations.filter({ $0.deref! !== r })
    }
}

public func += <T> (_ a: Relay<T>, _ b: Relay<T>) {
    a.add(destination: b)
}

public func -= <T> (_ a: Relay<T>, _ b: Relay<T>) {
    a.remove(destination: b)
}
