//
//  MARK_poorlyImplemented().swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/03/06.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

public func MARK_poorlyImplemented(_: @autoclosure () -> () = (), file: String = #file, line: Int = #line, function: String = #function) {
    debugLog("Poorly implemented. Skips for now... (\(file) (\(line)))", file, line, function)
    // report...
}
