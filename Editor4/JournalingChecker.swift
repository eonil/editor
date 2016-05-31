//
//  JournalingClearanceChecker.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation.NSThread
import EonilToolbox

/// Checks journaling system for proper clearing.
///
/// ## TL;DR
///
/// See `KeyJournalingDictionary` or `IndexJournalingArray` 
/// for usage.
///
/// ## How to Use This?
///
/// 1. Put an instance of this in a journal struct.
/// 2. Call `resetClearanceOfAllCheckers()` before state update.
/// 3. Call `setAsClean()` when the journal got cleared.
/// 4. Call `checkClearanceOfAllCheckers()` after you cleared all journals.
///
/// ## Why We Need This?
///
/// Journaling-array can append logs infinitely, and this
/// needs to be cleared at some point to prevent infinite growth.
/// Fortunately, we have perfect timing to do this -- driver looop.
///
/// On driver loop, driver will erase all the existing journal
/// after rendering. So renderer can use lossless logs from
/// last rendering and driver can keep reclaim memory for log
/// completely.
///
/// But if programmer forget to call clear method on a journal,
/// it will leak memory.  There must be a checker for this situation.
/// And this is the device.
///
/// By using this, we can ensure that *all the journals* are
/// properly cleared at some point.
///
/// ## How Does This Work?
///
/// Basically, this does one thing. Tells you whether the 
/// clearing method has been called or not.
///
/// - Note:
///     This presumes all journaling stuffs are running in main
///     thread. Any attempt to use this in non-main thread will
///     make a fatal-error.
///
/// - Note:
///     This does not provide the clearance magically. Programmers
///     are still responsible to clear all the journals. This just
///     helps to check leaking journals by programmer's mistake.
///
final class JournalingClearanceChecker {
    private static let lock = NSLock()
    private(set) static var allCheckers = WeakReferenceSet<JournalingClearanceChecker>()
    static func resetClearanceOfAllCheckers() {
        JournalingClearanceChecker.lock.lock()
        for c in allCheckers {
            c.isClean = false
        }
        JournalingClearanceChecker.lock.unlock()
    }
    static func checkClearanceOfAllCheckers() -> Bool {
        JournalingClearanceChecker.lock.lock()
        defer { JournalingClearanceChecker.lock.unlock() }
        for c in allCheckers {
            if c.isClean == false { return false }
        }
        return true
    }
    init() {
        JournalingClearanceChecker.lock.lock()
        JournalingClearanceChecker.allCheckers.insert(self)
        JournalingClearanceChecker.lock.unlock()
    }
    deinit {
        JournalingClearanceChecker.lock.lock()
        JournalingClearanceChecker.allCheckers.remove(self)
        JournalingClearanceChecker.lock.unlock()
    }
    private(set) var isClean = false
    func setAsClean() {
        JournalingClearanceChecker.lock.lock()
        isClean = true
        JournalingClearanceChecker.lock.unlock()
    }
}











