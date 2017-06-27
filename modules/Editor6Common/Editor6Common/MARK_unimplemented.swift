//
//  MARK_unimplemented.swift
//  Editor6Common
//
//  Created by Hoon H. on 2016/11/05.
//  Copyright © 2016 Eonil. All rights reserved.
//

///
/// Marks unimplemented area and crash.
///
public func MARK_unimplemented(_: @autoclosure () -> () = ()) -> Never  {
    fatalError("Unimplemented.")
}

///
/// Marks unimplemented area but continue.
///
public func MARK_unimplementedButSkipForNow(_: @autoclosure () -> () = (), file: String = #file, line: Int = #line, function: String = #function) {
    debugLog("Unimplemented, but skipped for now.", file, line, function)
//    report
}
