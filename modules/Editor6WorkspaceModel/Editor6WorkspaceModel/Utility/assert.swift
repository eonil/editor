//
//  assert.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/02.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

func assertMainThread() {
    assert(Thread.isMainThread)
}
