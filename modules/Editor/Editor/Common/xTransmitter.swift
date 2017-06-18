////
////  Transmitter.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/18.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//private final class Relay<Signal> {
//    private var observers = Set<Weak<Relay<Signal>>>()
//    fileprivate func addObserver(_ relay: Relay<Signal>) {
//        observers.insert(Weak(relay))
//    }
//    fileprivate func removeObserver(_ relay: Relay<Signal>) {
//        observers.remove(Weak(relay))
//    }
//    func cast(_ s: Signal) {
//        for o in observers {
//            o.object?.cast(s)
//        }
//    }
//}
//extension Relay {
//    struct Observer {
//        weak var reference: Relay<Signal>?
//        var 
//    }
//}
//
//class Transmitter<Signal> {
//    fileprivate let coreImpl = Relay<Signal>()
//}
//
/////
///// A buffering transmitter cannot merge multiple sources
///// due to semantic unclarity.
/////
//class BufferingTransmitter<Signal>: Transmitter<Signal> {
//    weak var source: Transmitter<Signal>? {
//        didSet {
//
//        }
//    }
//    var delegate: ((Signal) -> Void)?
//    private let relay = Relay<Signal>()
//    private let cap: Int
//    private var buffer: [Signal]
//
//    fileprivate init(bufferCapacity: Int = Int.max) {
//        cap = bufferCapacity
//    }
//    func cast(_ s: Signal) {
//        buffer.append(s)
//    }
//    private func step() {
//        while true {
//            guard let s = buffer.removeFirstIfAvailable() else { return }
//            relay.cast(s)
//        }
//    }
//}
//
/////
///// MergingTransmitter cannot perform buffering due to
///// semantic unclarity.
/////
//class MergingTransmitter<Signal>: Transmitter<Signal> {
//    var sources = [Weak<Transmitter<Signal>>]() {
//        didSet {
//
//        }
//    }
//    func addSource(_ s: Transmitter<Signal>) {
//
//    }
//    func removeSource(_ s: Transmitter<Signal>) {
//
//    }
//}
//
//
//
