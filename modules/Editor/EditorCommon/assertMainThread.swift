//
//  assertMainThread.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/18.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

public func assertMainThread() {
    assert(Thread.isMainThread)
}
