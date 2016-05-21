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
            logs.popFirst()
        }
        logs.append(log)
    }
    mutating func removeAll() {
        logs.removeAll()
        setAsClean()
    }

    ////////////////////////////////////////////////////////////////
    #if DEBUG
    private let journalingCheck = JournalingClearanceChecker()
    private func setAsClean() {
        journalingCheck.setAsClean()
    }
    #else
    private func setAsClean() {
        // Does nothing.
    }
    #endif
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
extension KeyMutation {
    var isInsert: Bool {
        get { switch self { case .Insert: return true; default: return false } }
    }
    var isUpdate: Bool {
        get { switch self { case .Update: return true; default: return false } }
    }
    var isDelete: Bool {
        get { switch self { case .Delete: return true; default: return false } }
    }
}









