//
//  main.swift
//  Editor6UnitTestdrive
//
//  Created by Hoon H. on 2017/01/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
@testable import Editor6Services

func XCTAssert(_ cond: Bool, _ msg: String = "") {
    precondition(cond, msg)
}

func measureDuration(_ f: () -> ()) -> TimeInterval {
    let startTimepoint = Date()
    f()
    let endTimepoint = Date()
    let duration = endTimepoint.timeIntervalSince(startTimepoint)
    return duration
}


_ = {
    let cond1 = NSCondition()
    let cond2 = NSCondition()
    let ch = PcoThreadChannel<Int>()
    Thread.detachNewThread {
        ch.send(111)
        cond1.lock()
        cond1.signal()
        cond1.unlock()
        print("Thread 1 finished.")
    }
    Thread.detachNewThread {
        let r = ch.receive()
        XCTAssert(r == 111)
        cond2.lock()
        cond2.signal()
        cond2.unlock()
        print("Thread 2 finished.")
    }
    cond1.lock()
    cond1.wait()
    cond1.unlock()
    cond2.lock()
    cond2.wait()
    cond2.unlock()
    print("All finished.")
    print("OK.")
}()
_ = {
    let w1 = PcoSignalWaiter()
    let w2 = PcoSignalWaiter()
    let ch = PcoThreadChannel<Int>()
    Thread.detachNewThread {
        ch.send(111)
        w1.signal()
        print("Thread 1 finished.")
    }
    Thread.detachNewThread {
        let r = ch.receive()
        XCTAssert(r == 111)
        w2.signal()
        print("Thread 2 finished.")
    }
    w1.wait()
    w2.wait()
    print("All finished.")
    print("OK.")
}()
_ = {
    let w1 = PcoSignalWaiter()
    let w2 = PcoSignalWaiter()
    let ch = PcoThreadChannel<Int>()
    Thread.detachNewThread {
        Thread.sleep(forTimeInterval: 0.5)
        ch.send(111)
        w1.signal()
        print("Thread 1 finished.")
    }
    Thread.detachNewThread {
        let r = ch.receive()
        XCTAssert(r == 111)
        w2.signal()
        print("Thread 2 finished.")
    }
    w1.wait()
    w2.wait()
    print("All finished.")
    print("OK.")
}()
_ = {
    let w1 = PcoSignalWaiter()
    let w2 = PcoSignalWaiter()
    let ch = PcoThreadChannel<Int>()
    Thread.detachNewThread {
        let d1 = measureDuration {
            ch.send(111)
        }
        XCTAssert(d1 > 0.9, "Expected alsmot 1.0, but actually \(d1).")
        w1.signal()
        print("Thread 1 finished.")
    }
    Thread.detachNewThread {
        Thread.sleep(forTimeInterval: 1)
        let r = ch.receive()
        XCTAssert(r == 111)
        w2.signal()
        print("Thread 2 finished.")
    }
    w1.wait()
    w2.wait()
    print("All finished.")
    print("OK.")
}()
