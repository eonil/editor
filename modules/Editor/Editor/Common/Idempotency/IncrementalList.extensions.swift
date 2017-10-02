////
////  IncrementalList.extensions.swift
////  Editor
////
////  Created by Hoon H. on 2017/09/30.
////Copyright © 2017 Eonil. All rights reserved.
////
//
//extension IncrementalList {
//
//}
//
//extension IncrementalListType {
//    typealias Change = IncrementalListChange<Element>
//
//    ///
//    /// Resolves changes to make `b` from `a`.
//    ///
//    /// This assumes `b` is derived from `a` by only one operation.
//    /// If it's impossible to derive `b` from `a` by only one operation,
//    /// this function returns error.
//    ///
//    /// - Warning:
//    ///     This function does not inspect element equality. Therefore,
//    ///     If `a` and `b`
//    ///
//    ///
//    private static func resolveChange(_ a: Self, _ b: Self) -> Result<Change, String> {
//        if a.count == b.count {
//            return .success(.none)
//        }
//        if a.count < b.count {
//            let appendedElements = Array(b[a.count..<b.count])
//            return .success(.append(appendedElements))
//        }
//        else {
//            guard b.count == 0 else { return .error("New state is not empty but has fewer elements. This is impossible in ") }
//            return .removeAll
//        }
//    }
//}
//
//enum IncrementalListChange<Element> {
//    case none
//    case append([Element])
//    case removeAll
//}
//
