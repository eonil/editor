////
////  Tree2Walker.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/28.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//extension Tree2 {
//    ///
//    /// Returns an array by performing topological-sort.
//    ///
//    /// - Time Complexity: O(n)
//    ///
//    func stableTopologicalSorting() -> [(Key, Value)] {
//        var a = [(Key, Value)]()
//        walkDFS({ k, v in a.append((k, v)) })
//        return a
//    }
//    func walkDFS(_ f: (Key, Value) -> Void) {
//        guard let (k, _) = self[.root] else { return }
//        walkDFS(from: k, f)
//    }
//    private func walkDFS(from k: Key, _ f: (Key, Value) -> Void) {
//        let v = self[k]
//        f(k, v)
//        let cks = children(of: k)
//        for ck in (cks ?? []) {
//            walkDFS(from: ck, f)
//        }
//    }
//}

