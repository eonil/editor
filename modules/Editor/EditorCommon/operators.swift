//
//  >>>.swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

infix operator >>> 

public func >>> <T,U> (_ a: T, _ b: (T) -> (U)) -> U {
    return b(a)
}

public func | <A,B,C> (_ f: @escaping (A) -> B, _ g: @escaping (B) -> (C)) -> ((A) -> C) {
    return { a in g(f(a)) }
}
