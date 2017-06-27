//
//  Function.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/25.
//  Copyright © 2017 Eonil. All rights reserved.
//

struct Function<I,O> {
    let implementation: (I) -> O
    init(_ impl: @escaping (I) -> O) {
        implementation = impl
    }
}

import Foundation
extension Function where O == Void {
    static func ignore() -> Function<I,O> {
        return Function { _ in }
    }
    static func inMainGCDQ(_ f: Function<I,O>) -> Function<I,O> {
        return Function { v in
            DispatchQueue.main.async { f.implementation(v) }
        }
    }
}
extension Function where I == FileHandle, O == Data {
    static func makeReader() -> Function<FileHandle,Data> {
        return Function<FileHandle,Data> { h in
            // The data MUST be copied in current GCDQ.
            let d = h.availableData
            // And it can be passed to any GCDQ.
            return d
        }
    }
}

func | <A,B,C> (_ a: Function<A,B>, _ b: Function<B,C>) -> Function<A,C> {
    return Function { value in
        return b.implementation(a.implementation(value))
    }
}
