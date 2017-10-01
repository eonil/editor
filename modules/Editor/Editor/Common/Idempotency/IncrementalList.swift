//
//  IncrementalList.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/29.
//  Copyright © 2017 Eonil. All rights reserved.
//

///
/// A list which only can be appended. (append == insert at last)
///
/// No random-insert, update or delete is supported.
///
/// - Note:
///     It's very easy and cheap to resolve diff in incremental list. (= O(1))
///     Therefore incremental-list does not define changes informations.
///
struct IncrementalList<Element>: IncrementalListType {
    private var raw = [Element]()
    var count: Int {
        return raw.count
    }
    subscript(_ index: Int) -> Element {
        get { return raw[index] }
    }
    subscript(bounds: Range<Int>) -> ArraySlice<Element> {
        return raw[bounds]
    }
    mutating func append<S>(contentsOf newElements: S) where S: Sequence, S.Element == Element {
        raw.append(contentsOf: newElements)
    }
    mutating func removeAll() {
        raw.removeAll()
    }
}

struct FilteredIncrementalList<Element>: IncrementalListType {
    private let filterf: (Element) -> Bool
    private var raw = IncrementalList<Element>()
    init(_ filter: @escaping (Element) -> Bool) {
        filterf = filter
    }
    var count: Int {
        return raw.count
    }
    subscript(_ index: Int) -> Element {
        get { return raw[index] }
    }
    subscript(bounds: Range<Int>) -> ArraySlice<Element> {
        return raw[bounds]
    }
    mutating func append<S>(contentsOf newElements: S) where S: Sequence, S.Element == Element {
        let filteredNewElements = newElements.filter(filterf)
        raw.append(contentsOf: filteredNewElements)
    }
    mutating func removeAll() {
        raw.removeAll()
    }
}
