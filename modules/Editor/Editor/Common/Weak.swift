//
//  Weak.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/16.
//  Copyright © 2017 Eonil. All rights reserved.
//

///
/// Provides read-only weak value.
///
struct Weak<T> where T: AnyObject {
    private(set) weak var deref: T?
    init(_ ref: T) {
        deref = ref
    }
}

/////
///// Provides read-only weak value.
/////
//struct Weak<T>: Hashable where T: AnyObject {
//    private weak var o: T?
//    var object: T? {
//        return o
//    }
//    init(_ object: T) {
//        o = object
//    }
//    var hashValue: Int {
//        guard let o = o else { return 0 }
//        return ObjectIdentifier(o).hashValue
//    }
//    static func == (_ a: Weak<T>, _ b: Weak<T>) -> Bool {
//        return a.object === b.object
//    }
//}
//
