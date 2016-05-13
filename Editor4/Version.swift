//
//  Version.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// Instantiation produces different version value.
/// Copy produces equal version value.
public struct Version: Hashable, VersionType, RevisableVersionType {
    public init() {
    }
    public var hashValue: Int {
        get { return ObjectIdentifier(addressID).hashValue }
    }
    private var addressID = NonObjectiveCBase()
    /// Exists only for debugging convenience.
    /// Can be wrong in multi-threaded code... Don't care for now.
    private var revisionCountForDebuggingOnly = Int(0)
}
public extension Version {
    public mutating func revise() {
        self = revised()
    }
    public func revised() -> Version {
        var copy = self
        guard copy.revisionCountForDebuggingOnly < Int.max else { return Version() }
        copy.addressID = NonObjectiveCBase()
        copy.revisionCountForDebuggingOnly += 1
        return copy
    }
}
extension Version: CustomDebugStringConvertible {
    public var debugDescription: String {
        get {
            let id = String(format: "%x", ObjectIdentifier(addressID).uintValue)
            let rev = String(format: "%i", revisionCountForDebuggingOnly)
            return "(" + id + "/" + rev + ")"
        }
    }
}
public func == (a: Version, b: Version) -> Bool {
    return a.addressID === b.addressID
}















