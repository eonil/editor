//
//  Mutation.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/29.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

public enum SetMutation<Element: Hashable> {
    case insert(Set<Element>)
    case delete(Set<Element>)
}
public enum ArrayMutation<Element> {
    case insert(Range<Int>, [Element])
    case update(Range<Int>, [Element])
    case delete(Range<Int>, [Element])
}
public enum DictionaryMutation<Key: Hashable, Value> {
    case insert([Key: Value])
    case update([Key: Value])
    case delete([Key: Value])
}




public extension Array {
    mutating func apply(mutation: ArrayMutation<Element>) {
        switch mutation {
        case .insert(let range, let elements):
            insert(contentsOf: elements, at: range.lowerBound)
        case .update(let range, let elements):
            replaceSubrange(range, with: elements)
        case .delete(let range, _):
            removeSubrange(range)
        }
    }
}
public extension Set {
    mutating func apply(mutation: SetMutation<Element>) {
        switch mutation {
        case .insert(let subset):
            for e in subset {
                assert(self.contains(e) == false)
                insert(e)
            }
        case .delete(let subset):
            for e in subset {
                assert(self.contains(e) == true)
                remove(e)
            }
        }
    }
}
public extension Dictionary {
    mutating func apply(mutation: DictionaryMutation<Key,Value>) {
        switch mutation {
        case .insert(let subset):
            for (k,v) in subset {
                assert(self[k] == nil)
                self[k] = v
            }
        case .update(let subset):
            for (k,v) in subset {
                assert(self[k] != nil)
                self[k] = v
            }
        case .delete(let subset):
            for (k,_) in subset {
                assert(self[k] != nil)

                self[k] = nil
            }
        }
    }
}
