//
//  Method.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/25.
//  Copyright © 2017 Eonil. All rights reserved.
//

///
/// I'm still in doubt of usefulness of this feature.
///
struct Method<T,I,O> {
    private let impl: (T) -> (I) -> (O)
    init(_ implementation: @escaping (T) -> (I) -> (O)) {
        impl = implementation
    }
    func bind(_ parameter: I) -> ((T) -> (O)) {
        return { [impl] instance in
            return impl(instance)(parameter)
        }
    }
}

