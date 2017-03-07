//
//  Tree1Mutation.swift
//  Editor6Common
//
//  Created by Hoon H. on 2016/11/03.
//  Copyright © 2016 Eonil. All rights reserved.
//

public enum Tree1Mutation<TKey, TValue> {
    case insert([(id: TKey, state: TValue, at: Int, in: TKey)])
    case update([(id: TKey, state: TValue)])
    case delete([(id: TKey, state: TValue, at: Int, in: TKey)])
}
