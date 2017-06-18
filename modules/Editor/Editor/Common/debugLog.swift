//
//  DEBUG_log.swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/01/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation


public func DEBUG_log<A>(_ a: @autoclosure () -> A, file: String = #file, line: Int = #line, function: String = #function) {
    assert({
        DEBUG_logImpl(["\(a())"], file, line, function)
        return true
        }())
}
public func DEBUG_log<A,B>(_ a: @autoclosure () -> A, _ b: @autoclosure () -> B, file: String = #file, line: Int = #line, function: String = #function) {
    assert({
        DEBUG_logImpl(["\(a())", "\(a())"], file, line, function)
        return true
        }())
}
public func DEBUG_log<A,B,C>(_ a: @autoclosure () -> A, _ b: @autoclosure () -> B, _ c: @autoclosure () -> C, file: String = #file, line: Int = #line, function: String = #function) {
    assert({
        DEBUG_logImpl(["\(a())", "\(b())", "\(c())"], file, line, function)
        return true
        }())
}
public func DEBUG_log<A,B,C,D>(_ a: @autoclosure () -> A, _ b: @autoclosure () -> B, _ c: @autoclosure () -> C, _ d: @autoclosure () -> D, file: String = #file, line: Int = #line, function: String = #function) {
    assert({
        DEBUG_logImpl(["\(a())", "\(b())", "\(c())", "\(d())"], file, line, function)
        return true
        }())
}
public func DEBUG_log<T: AnyObject>(withAddressOf object: @autoclosure () -> T, message: @autoclosure () -> String = "", file: String = #file, line: Int = #line, function: String = #function) {
    assert({
        let id = ObjectIdentifier(object())
        let s = String(Int(bitPattern: id), radix: 16)
        DEBUG_logImpl(["\(s): \(message())"], file, line, function)
        return true
        }())
}


private func DEBUG_logImpl(_ values: @autoclosure () -> [String], _ file: String, _ line: Int, _ fuction: String) {
    let a = values().joined(separator: ", ")
//    NSLog("%@", a)
    let n = URL(fileURLWithPath: file).lastPathComponent
    NSLog("\(n) (\(line)): %@", a)
}


