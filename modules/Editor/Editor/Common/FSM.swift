//
//  FSM.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/25.
//  Copyright © 2017 Eonil. All rights reserved.
//

///
/// State progression checking Finite State Machine.
///
struct FSM<S> where S: Equatable {
    private(set) var current: S
    private let check: (Transition) -> Bool
    fileprivate init(_ validate: @escaping (Transition) -> Bool, _ initial: S) {
        check = validate
        current = initial
    }
    ///
    /// Idempotent.
    ///
    /// - Parameter transition:
    ///     Called only if state has been changed.
    ///
    /// - Returns:
    ///     A transition object if state has been changed.
    ///     `nil` otherwise.
    ///
    mutating func set(to s: S, transition: () -> Void = {}) {
        assert(check((current, s)))
        guard current != s else { return }
        current = s
        transition()
    } 
}
extension FSM {
    typealias Transition = (from: S, to: S)
}
extension FSM {
    init(_ rules: [Transition], _ initial: S) {
        self.init(checkByRules(rules), initial)
    }
    init(_ rule: Transition, _ initial: S) {
        self.init(checkByRules([rule]), initial)
    }
    init(serial ss: [S], skippable: Bool) {
        precondition(ss.count > 0)
        func chk(_ t: Transition) -> Bool {
            assert(ss.contains(t.from), "The state `\(t.from)` is not defined in ths FSM.")
            assert(ss.contains(t.to), "The state `\(t.to)` is not defined in ths FSM.")
            guard let i1 = ss.index(of: t.from) else { return false }
            guard let i2 = ss.index(of: t.to) else { return false }
            let dt = i2 - i1
            let r: Bool
            if skippable { r = (dt >= 0) }
            else { r = (0...1).contains(dt) }
            return r
        }
        self.init(chk, ss[0])
    }
}
extension Equatable {
    ///
    /// First and last state is always will be visited.
    /// Others can be skipped freely.
    ///
    static func serial(_ ss: [Self]) -> FSM<Self> {
        return FSM(serial: ss, skippable: true)
    }
}

private func checkByRules<S>(_ rules: [FSM<S>.Transition]) -> (_ a: S, _ b: S) -> Bool where S: Equatable {
    return { a, b in
        for r in rules {
            if r.from == a && r.to == b {
                return true
            }
        }
        return false
    }
}
