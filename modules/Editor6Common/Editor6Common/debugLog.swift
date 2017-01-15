//
//  debugLog.swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/01/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation


public func debugLog<A>(_ a: @autoclosure () -> A) {
    assert({
        debugLogImpl(["\(a())"])
        return true
        }())
}
public func debugLog<A,B>(_ a: @autoclosure () -> A, _ b: @autoclosure () -> B) {
    assert({
        debugLogImpl(["\(a())", "\(a())"])
        return true
        }())
}
public func debugLog<A,B,C>(_ a: @autoclosure () -> A, _ b: @autoclosure () -> B, _ c: @autoclosure () -> C) {
    assert({
        debugLogImpl(["\(a())", "\(b())", "\(c())"])
        return true
        }())
}
public func debugLog<A,B,C,D>(_ a: @autoclosure () -> A, _ b: @autoclosure () -> B, _ c: @autoclosure () -> C, _ d: @autoclosure () -> D) {
    assert({
        debugLogImpl(["\(a())", "\(b())", "\(c())", "\(d())"])
        return true
        }())
}

private func debugLogImpl(_ values: [String]) {
    let a = values.joined(separator: ", ")
    NSLog("%@", a)
}


