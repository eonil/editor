//
//  Action.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/21.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

public enum SetAction<T: Hashable> {
    case insert(Set<T>)
    case remove(Set<T>)
}

public enum DictionaryAction<K: Hashable, V> {
    case set(K,V)
    case unset(K)
}

public enum ArrayAction<T> {
    case insert(Range<Int>, [T])
    case update(Range<Int>, [T])
    case delete(Range<Int>)
}
