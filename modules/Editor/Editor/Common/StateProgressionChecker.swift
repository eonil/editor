////
////  StateProgressionChecker.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/25.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//typealias SPC<S> = StateProgressionChecker<S> where S: Equatable
//
/////
///// Basically a checked FSM which stores state some external storage.
/////
//struct StateProgressionChecker<S> where S: Equatable {
//    private let check: (Transition) -> Bool
//    fileprivate init(_ validate: @escaping (Transition) -> Bool) {
//        check = validate
//    }
//    ///
//    /// Idempotent.
//    ///
//    /// - Parameter transition:
//    ///     Called only if state has been changed.
//    ///
//    /// - Returns:
//    ///     A transition object if state has been changed.
//    ///     `nil` otherwise.
//    ///
//    func set(_ from: inout S, to: S, transition: () -> Void = {}) {
//        assert(check((from, to)))
//        guard from != to else { return }
//        from = to
//        transition()
//    }
//}
//extension SPC {
//    typealias Transition = (from: S, to: S)
//}
//extension SPC {
//    init(_ rules: [Transition]) {
//        self.init(checkByRules(rules))
//    }
//    init(_ rule: Transition) {
//        self.init(checkByRules([rule]))
//    }
//    init(serial ss: [S], skippable: Bool) {
//        precondition(ss.count > 0)
//        func chk(_ t: Transition) -> Bool {
//            assert(ss.contains(t.from), "The state `\(t.from)` is not defined in ths FSM.")
//            assert(ss.contains(t.to), "The state `\(t.to)` is not defined in ths FSM.")
//            guard let i1 = ss.index(of: t.from) else { return false }
//            guard let i2 = ss.index(of: t.to) else { return false }
//            let dt = i2 - i1
//            let r: Bool
//            if skippable { r = (dt >= 0) }
//            else { r = (0...1).contains(dt) }
//            return r
//        }
//        self.init(chk)
//    }
//}
//extension Equatable {
//    ///
//    /// First and last state is always will be visited.
//    /// Others can be skipped freely.
//    ///
//    static func serial(_ ss: [Self]) -> SPC<Self> {
//        return SPC(serial: ss, skippable: true)
//    }
//}
//
//private func checkByRules<S>(_ rules: [SPC<S>.Transition]) -> (_ a: S, _ b: S) -> Bool where S: Equatable {
//    return { a, b in
//        for r in rules {
//            if r.from == a && r.to == b {
//                return true
//            }
//        }
//        return false
//    }
//}
