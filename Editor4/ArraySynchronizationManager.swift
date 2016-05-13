//
//  ArraySynchronizationManager.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/13.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

protocol SynchronizableElementType {
    associatedtype SourceType: VersioningStateType
    mutating func syncFrom(source: SourceType)
}
struct ArraySynchronizationManager<Element: SynchronizableElementType> {
    private var latestSourceArrayVersion: Version?
    private(set) var array = [Element]()
}






protocol DefaultInitializableType {
    init()
}
protocol IdentifiableType {
    associatedtype Identity: Hashable
    func identify() -> Identity
}
extension ArraySynchronizationManager where
Element: DefaultInitializableType,
Element: IdentifiableType,
Element.SourceType: IdentifiableType,
Element.Identity == Element.SourceType.Identity {

    /// Performs synchronization with any possible optimizations.
    ///
    /// 1. If current version is equal to source array version, this is no-op.
    /// 2. If source array has journal with current version,
    ///    journaling logs will be replayed on this array from there.
    /// 3. If no proper version journal could be found,
    ///    this will perform full-resync, which means recreation of all elements.
    ///
    mutating func syncFrom<A: IndexJournalingArrayType where A.Generator.Element == Element.SourceType, A.Index == Int>(sourceArray: A) {
        // Check and skip if possible.
        guard latestSourceArrayVersion != sourceArray.version else {
            // Nothing to do.
            return
        }

        switch syncUsingJournalFrom(sourceArray) {
        case .OK:
            break

        case .CancelBecauseJournalUnavailableForCurrentVersion:
            resyncAllFrom(sourceArray)
        }
    }

    private mutating func syncUsingJournalFrom<A: IndexJournalingArrayType where A.Generator.Element == Element.SourceType, A.Index == Int>(sourceArray: A) -> SyncUsingJournalResult {
        var journalAvailable = false

        // Sync partially using journal if possible.
        for log in sourceArray.journal.logs {
            if log.version == latestSourceArrayVersion {
                journalAvailable = true
            }
            if journalAvailable {
                switch log.operation {
                case .Insert(let index):
                    // Sync to latest version, and duplicated call will be ignored by version comparison.
                    var newElement = Element()
                    newElement.syncFrom(sourceArray[index])
                    array.insert(newElement, atIndex: index)

                case .Update(let index):
                    array[index].syncFrom(sourceArray[index])

                case .Delete(let index):
                    array.removeAtIndex(index)
                }
            }
        }

        if journalAvailable == false {
            // In this case, no mutation should be performed.
            return .CancelBecauseJournalUnavailableForCurrentVersion
        }

        latestSourceArrayVersion = sourceArray.version
        return .OK
    }
    private mutating func resyncAllFrom<A: IndexJournalingArrayType where A.Generator.Element == Element.SourceType, A.Index == Int>(sourceArray: A) {
        // Sync fully at worst case.
        var reusables = Dictionary<Element.SourceType.Identity, Element>()
        for r in array {
            let id = r.identify()
            reusables[id] = r
        }
        array = []
        array.reserveCapacity(sourceArray.count)
        for s in sourceArray {
            let id = s.identify()
            var e = reusables[id] ?? Element()
            e.syncFrom(s)
            array.append(e)
        }
        latestSourceArrayVersion = sourceArray.version
    }
}

private enum SyncUsingJournalResult {
    case OK
    case CancelBecauseJournalUnavailableForCurrentVersion
}









































//extension ArraySynchronizationManager {
//    mutating func syncFrom(sourceArray: IndexJournalingArray<Element.SourceType>, @noescape produce: Element.SourceType->Element) {
//        syncFrom(sourceArray, produce: produce, prepareFullSync: { _ in })
//    }
//    /// Performs synchronization with any possible optimizations.
//    ///
//    /// 1. If current version is equal to source array version, this is no-op.
//    /// 2. If source array has journal with current version,
//    ///    journaling logs will be replayed on this array from there.
//    /// 3. If no proper version journal could be found,
//    ///    this will perform full-resync, which means recreation of all elements.
//    ///
//    /// - Parameter prepareFullSync:
//    ///     You can take some old instances to re-use them.
//    ///     This is required because some Cocoa components pointer equality
//    ///     to work properly.
//    mutating func syncFrom(sourceArray: IndexJournalingArray<Element.SourceType>, @noescape produce: Element.SourceType->Element, @noescape prepareFullSync: (reusableInstances: [Element])->()) {
//        // Check and skip if possible.
//        guard latestSourceArrayVersion != sourceArray.version else {
//            // Nothing to do.
//            return
//        }
//
//        var journalAvailable = false
//
//        // Sync partially using journal if possible.
//        for log in sourceArray.journal.logs {
//            if log.version == latestSourceArrayVersion {
//                journalAvailable = true
//            }
//            if journalAvailable {
//                switch log.operation {
//                case .Insert(let index):
//                    // Sync to latest version, and duplicated call will be ignored by version comparison.
//                    var newElement = produce(sourceArray[index])
//                    newElement.syncFrom(sourceArray[index])
//                    array.insert(newElement, atIndex: index)
//
//                case .Update(let index):
//                    array[index].syncFrom(sourceArray[index])
//
//                case .Delete(let index):
//                    array.removeAtIndex(index)
//                }
//            }
//        }
//
//        // Sync fully at worst case.
//        if journalAvailable == false {
//            prepareFullSync(reusableInstances: array)
//            array = []
//            array.reserveCapacity(sourceArray.count)
//            for s in sourceArray {
//                var e = produce(s)
//                e.syncFrom(s)
//                array.append(e)
//            }
//        }
//
//        latestSourceArrayVersion = sourceArray.version
//    }
//    mutating func syncFrom(sourceArray: Array<Element.SourceType>, @noescape produce: Element.SourceType->Element, @noescape prepareFullSync: (reusableInstances: [Element])->()) {
//        // Sync fully at worst case.
//        prepareFullSync(reusableInstances: array)
//        array = []
//        array.reserveCapacity(sourceArray.count)
//        for s in sourceArray {
//            var e = produce(s)
//            e.syncFrom(s)
//            array.append(e)
//        }
//        latestSourceArrayVersion?.revise()
//    }
//}