//
//  MutableBox.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/25.
//  Copyright © 2017 Eonil. All rights reserved.
//

final class MutableBox<T> {
    var value: T
    init(_ v: T) {
        value = v
    }
}
