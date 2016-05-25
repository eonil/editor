//
//  MemoizingLazyList.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// Lazily resolved list. Once resolved, the result is memoized so returns always same result.
///
struct MemoizingLazyList<Element> {
    let version = Version()
    private let rpkg = ResolutionPackage<Element>()

    var elements: [Element] {
        get {
            if rpkg.memo == nil {
                assert(rpkg.resolver != nil)
                rpkg.memo = rpkg.resolver?() ?? []
                rpkg.resolver = nil
            }
            assert(rpkg.memo != nil)
            return rpkg.memo ?? []
        }
    }
    init(_ resolver: () -> [Element]) {
        rpkg.resolver = resolver
    }
}

private final class ResolutionPackage<T> {
    var resolver: (() -> [T])?
    var memo: [T]?
}



