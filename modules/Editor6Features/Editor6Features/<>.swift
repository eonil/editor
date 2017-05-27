//
//  <>.swift
//  Editor6Features
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Editor6Common

infix operator >>>

func >>> <V,V1,E> (_ a: Result<V,E>, _ b: (V) -> Result<V1,E>) -> Result<V1,E> {
    return a.combine(b)
}
func | <V,V1,E> (_ a: Result<V,E>, _ b: (V) -> Result<V1,E>) -> Result<V1,E> {
    return a.combine(b)
}

