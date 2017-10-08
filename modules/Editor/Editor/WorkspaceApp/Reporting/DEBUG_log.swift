//
//  Debug.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/08.
//Copyright © 2017 Eonil. All rights reserved.
//

func DEBUG_log<A>(_ a: @autoclosure () -> A, file n: String = #file, line i: Int = #line, function f: String = #function) {
    assert({
        DEBUG_logImpl(["\(a())"], file: n, line: i, function: f)
        return true
        }())
}
//public func DEBUG_log<A,B>(_ a: @autoclosure () -> A, _ b: @autoclosure () -> B, file: String = #file, line: Int = #line, function: String = #function) {
//    assert({
//        DEBUG_logImpl(["\(a())", "\(a())"], file, line, function)
//        return true
//        }())
//}
//public func DEBUG_log<A,B,C>(_ a: @autoclosure () -> A, _ b: @autoclosure () -> B, _ c: @autoclosure () -> C, file: String = #file, line: Int = #line, function: String = #function) {
//    assert({
//        DEBUG_logImpl(["\(a())", "\(b())", "\(c())"], file, line, function)
//        return true
//        }())
//}
//public func DEBUG_log<A,B,C,D>(_ a: @autoclosure () -> A, _ b: @autoclosure () -> B, _ c: @autoclosure () -> C, _ d: @autoclosure () -> D, file: String = #file, line: Int = #line, function: String = #function) {
//    assert({
//        DEBUG_logImpl(["\(a())", "\(b())", "\(c())", "\(d())"], file, line, function)
//        return true
//        }())
//}
func DEBUG_log<T: AnyObject>(withAddressOf object: @autoclosure () -> T, message: @autoclosure () -> String = "", file n: String = #file, line i: Int = #line, function f: String = #function) {
    assert({
        let id = ObjectIdentifier(object())
        let s = String(Int(bitPattern: id), radix: 16)
        DEBUG_logImpl(["\(s): \(message())"], file: n, line: i, function: f)
        return true
        }())
}

import Foundation
private func DEBUG_logImpl(_ values: [String], file: String, line: Int, function: String) {
    let a = values.joined(separator: ", ")
    //    NSLog("%@", a)
    let n = URL(fileURLWithPath: file).lastPathComponent
    NSLog("\(n) (\(line)): %@", a)
}


