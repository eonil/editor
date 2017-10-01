//
//  IncrementalListType.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/29.
//Copyright © 2017 Eonil. All rights reserved.
//

protocol IncrementalListType {
    associatedtype Element
    var count: Int { get }
    subscript(_ index: Int) -> Element { get }
    subscript(bounds: Range<Int>) -> ArraySlice<Element> { get }
    mutating func append<S>(contentsOf newElements: S) where S: Sequence, S.Element == Element
    mutating func removeAll()
}
