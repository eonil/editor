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
func MARK_unimplemented() -> Never  {
    fatalError("Unimplemented.")
}

///
/// Marks unimplemented area but continue.
///
func MARK_unimplementedButSkipForNow(_: @autoclosure () -> () = (), file n: String = #file, line i: Int = #line, function f: String = #function) {
    DEBUG_log("Unimplemented, but skipped for now.", file: n, line: i, function: f)
    // report...
}
