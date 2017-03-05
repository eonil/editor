//
//  assertMainThread.swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/03/05.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

public func assertMainThread() {
    assert(Thread.isMainThread)
}
