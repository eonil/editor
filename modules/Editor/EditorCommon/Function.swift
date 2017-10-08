//
//  Function.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/25.
//  Copyright © 2017 Eonil. All rights reserved.
//

public struct Function<I,O> {
    public let implementation: (I) -> O
    public init(_ impl: @escaping (I) -> O) {
        implementation = impl
    }
}

import Foundation
public extension Function where O == Void {
    public static func ignore() -> Function<I,O> {
        return Function { _ in }
    }
    public static func inMainGCDQ(_ f: Function<I,O>) -> Function<I,O> {
        return Function { v in
            DispatchQueue.main.async { f.implementation(v) }
        }
    }
}
public extension Function where I == FileHandle, O == Data {
    public static func makeReader() -> Function<FileHandle,Data> {
        return Function<FileHandle,Data> { h in
            // The data MUST be copied in current GCDQ.
            let d = h.availableData
            // And it can be passed to any GCDQ.
            return d
        }
    }
}

public func | <A,B,C> (_ a: Function<A,B>, _ b: Function<B,C>) -> Function<A,C> {
    return Function { value in
        return b.implementation(a.implementation(value))
    }
}

