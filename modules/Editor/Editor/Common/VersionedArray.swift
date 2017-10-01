//
//  VersionedArray.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/29.
//Copyright © 2017 Eonil. All rights reserved.
//

import EonilToolbox

///
/// Generic array with state transition.
///
/// Use this;
/// - You need idempotent transition tracking support.
/// - You don't need high performance.
///
public struct VersionedArray<T> {
    public private(set) var version = Version()
    public var elements = [T]() {
        didSet {
            version.revise()
        }
    }
    public init(_ elements: [T] = []) {
        self.elements = elements
    }
}
