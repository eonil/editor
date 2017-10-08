//
//  MARK_poorlyImplemented().swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/03/06.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

func MARK_poorlyImplemented(_: @autoclosure () -> () = (), file n: String = #file, line i: Int = #line, function f: String = #function) {
    DEBUG_log("Poorly implemented. Skips for now... (\(n) (\(i)))", file: n, line: i, function: f)
    // report...
}
