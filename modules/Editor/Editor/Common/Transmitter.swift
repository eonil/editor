////
////  Transmitter.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/18.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//final class Transmitter<Signal> {
//    private var observers = [ObjectIdentifier: (Signal) -> Void]()
//    weak var source: Transmitter<Signal>? {
//        willSet {
//            source?.removeObserver(self)
//        }
//        didSet {
//            source?.addObserver(self)
//        }
//    }
//
//    init() {
//    }
//    deinit {
//        source?.removeObserver(self)
//    }
//    func cast(_ s: Signal) {
//        for (_, f) in observers {
//            f(s)
//        }
//    }
//
//    private func addObserver(_ tx: Transmitter<Signal>) {
//        let id = ObjectIdentifier(tx)
//        observers[id] = { [weak tx] s in
//            guard let tx = tx else { return }
//            tx.cast(s)
//        }
//    }
//    private func removeObserver(_ tx: Transmitter<Signal>) {
//        let id = ObjectIdentifier(tx)
//        observers[id] = nil
//    }
//}
//
////private final class CycleDetector {
////    static let `default` = CycleDetector()
////    private var mapping = [ObjectIdentifier: ObjectIdentifier]()
////    func noteInit<T>(_ tx: Transmitter<T>) {
////
////    }
////    func noteDeinit<T>(_ tx: Transmitter<T>) {
////
////    }
////    func noteAddObserver<T>(_ parent: Transmitter<T>, _ child: Transmitter<T>) {
////        let pid = ObjectIdentifier(parent)
////        let cid = ObjectIdentifier(child)
////        mapp
////        mapping[pid] = cid
////    }
////    func noteRemoveObserver<T>(_ parent: Transmitter<T>, _ child: Transmitter<T>) {
////        let pid = ObjectIdentifier(parent)
////        let cid = ObjectIdentifier(child)
////        precondition(mapping[pid] == cid)
////        mapping[pid] = nil
////    }
////}
