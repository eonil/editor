//
//  MutableBox.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/25.
//  Copyright © 2017 Eonil. All rights reserved.
//

public final class MutableBox<T> {
    public var value: T
    public init(_ v: T) {
        value = v
    }
}
