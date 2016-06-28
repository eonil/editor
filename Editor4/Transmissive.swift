//
//  Transmissive.swift
//  Editor4
//
//  Created by Hoon H. on 2016/06/27.
//  Copyright © 2016 Eonil. All rights reserved.
//

enum Transmissive<T> {
    case none
    case some
    case full(T)
}

enum Progressive<P,T> {
    case none
    case some(P)
    case full(T)
}
