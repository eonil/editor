//
//  debugLog.swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/01/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation


public func debugLog<A>(_ a: @autoclosure () -> A, file: String = #file, line: Int = #line, function: String = #function) {
    assert({
        debugLogImpl(["\(a())"], file, line, function)
        return true
        }())
}
public func debugLog<A,B>(_ a: @autoclosure () -> A, _ b: @autoclosure () -> B, file: String = #file, line: Int = #line, function: String = #function) {
    assert({
        debugLogImpl(["\(a())", "\(a())"], file, line, function)
        return true
        }())
}
public func debugLog<A,B,C>(_ a: @autoclosure () -> A, _ b: @autoclosure () -> B, _ c: @autoclosure () -> C, file: String = #file, line: Int = #line, function: String = #function) {
    assert({
        debugLogImpl(["\(a())", "\(b())", "\(c())"], file, line, function)
        return true
        }())
}
public func debugLog<A,B,C,D>(_ a: @autoclosure () -> A, _ b: @autoclosure () -> B, _ c: @autoclosure () -> C, _ d: @autoclosure () -> D, file: String = #file, line: Int = #line, function: String = #function) {
    assert({
        debugLogImpl(["\(a())", "\(b())", "\(c())", "\(d())"], file, line, function)
        return true
        }())
}
public func debugLog<T: AnyObject>(withAddressOf object: @autoclosure () -> T, message: @autoclosure () -> String = "", file: String = #file, line: Int = #line, function: String = #function) {
    assert({
        let id = ObjectIdentifier(object())
        let s = String(Int(bitPattern: id), radix: 16)
        debugLogImpl(["\(s): \(message())"], file, line, function)
        return true
        }())
}


private func debugLogImpl(_ values: @autoclosure () -> [String], _ file: String, _ line: Int, _ fuction: String) {
    let a = values().joined(separator: ", ")
//    NSLog("%@", a)
    NSLog("\(file) (\(line)): %@", a)
}


