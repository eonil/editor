//
//  Version.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// Instantiation produces different version value.
/// Copy produces equal version value.
public struct Version: Hashable, VersionType {
    public init() {
    }
    public var hashValue: Int {
        get { return ObjectIdentifier(dummy).hashValue }
    }
    private var dummy = NonObjectiveCBase()
}
public func == (a: Version, b: Version) -> Bool {
    return a.dummy === b.dummy
}
public protocol VersionedStateType {
    var version: Version { get }
}