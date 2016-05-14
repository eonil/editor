//
//  KeyJournal.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/14.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// A journal is a record of mutation
/// performed by `operation` on state of `version`
struct KeyJournal<Key: Hashable> {
    typealias Log = (version: Version, operation: KeyMutation<Key>)
    let capacityLimit: Int
    /// All the log items must be sequential.
    private(set) var logs = Array<Log>()
    init(capacityLimit: Int) {
        self.capacityLimit = capacityLimit
    }
    mutating func append(log: Log) {
        while logs.count >= capacityLimit {
            logs.tryRemoveFirst()
        }
        logs.append(log)
    }
    mutating func removeAll() {
        logs.removeAll()
    }
}

enum KeyMutation<Key: Hashable> {
    case Insert(Key)
    case Update(Key)
    case Delete(Key)

    private func getKey() -> Key {
        switch self {
        case .Insert(let key):  return key
        case .Update(let key):  return key
        case .Delete(let key):  return key
        }
    }
}

