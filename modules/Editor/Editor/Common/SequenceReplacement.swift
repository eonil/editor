//
//  SequenceReplacement.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/27.
//Copyright © 2017 Eonil. All rights reserved.
//

///
/// EXPERIMENTAL
///
/// Requires `beforeFirst != afterLast`.
///
protocol IdempotentListKey: Comparable {
    static var beforeFirst: Self { get }
    static var afterLast: Self { get }
}

///
/// EXPERIMENTAL
///
/// Always requires `lazyKeys.sorted() == lazyKeys`.
///
struct IdempotentList<K,V> where K: IdempotentListKey {
    private(set) var items = [(key: K, value: V)]()
    ///
    /// O(1) at best.
    /// O(n) at worst where n = count(existing items) + count(new items)
    ///
    mutating func replace(_ replacement: IdempotentListReplacement<K,V>) {
        assert(lazyKeys.sorted() == lazyKeys)
        precondition(items.isEmpty == false, "You cannot perform partial replacement operation on an empty list.")
        func findIndexOf(_ k: K) -> Int? {
            if k == K.beforeFirst { return 0 }
            if items.first?.key == k { return 1 }
            if items.last?.key == k { return items.count - 1 }
            if k == K.afterLast { return items.count }
            return items.lazy.map({ k, _ in k }).index(of: k)
        }
        guard let i0 = findIndexOf(replacement.range.lowerBound) else { fatalError() }
        guard let i1 = findIndexOf(replacement.range.upperBound) else { fatalError() }
        items.replaceSubrange((i0+1)..<i1, with: replacement.items)
        assert(lazyKeys.sorted() == lazyKeys)
    }
    private var lazyKeys: [K] {
        return Array(items.lazy.map({ k, _ in k }))
    }
}

///
/// Requires `selection.lowerBound != selection.upperBound`.
///
struct IdempotentListReplacement<K,V> where K: IdempotentListKey {
    var range: Range<K>
    var items: [(key: K, value: V)]
    init(range: Range<K>, items: [(K,V)]) {
        precondition(K.beforeFirst != K.afterLast)
        precondition(range.lowerBound != range.upperBound)
        precondition(range.lowerBound <= range.upperBound)
        self.range = range
        self.items = items
    }
}



//struct IdempotentListTransaction<T> {
//    var before: [T]
//    var changes: [Change]
//    var after: [T]
//    enum Change {
//        case insert(Range<Int>)
//        case update(Range<Int>)
//        case delete(Range<Int>)
//    }
//}


