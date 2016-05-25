//
//  Promise.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/23.
//  Copyright © 2016 Eonil. All rights reserved.
//

final class Promise<T> {
    private(set) var value: T?
    func set(value: T) {
        self.value = value
    }
}