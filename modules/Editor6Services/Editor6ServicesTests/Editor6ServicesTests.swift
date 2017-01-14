//
//  Editor6ServicesTests.swift
//  Editor6ServicesTests
//
//  Created by Hoon H. on 2017/01/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Dispatch
import XCTest
import EonilGCDActor
@testable import Editor6Services

class Editor6ServicesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPcoGCDChannelClosing() {
        let ch = PcoGCDChannel<Int>()
        ch.close()
        XCTAssert(ch.isClosed)
    }

    func testPcoGCDChannelTransfer() {
        let exp = expectation(description: "ok")
        let sema = DispatchSemaphore(value: 0)
        let ch = PcoGCDChannel<Int>()
        GCDActor.spawn { (_ ss: GCDActorSelf) in
            ch.send(111)
            sema.signal()
        }
        GCDActor.spawn { (_ ss: GCDActorSelf) in
            ch.receive { s in
                XCTAssert(s == 111)
                exp.fulfill()
                sema.signal()
            }
        }
        sema.wait()
        sema.wait()
        waitForExpectations(timeout: 4) { (e: Error?) in
            XCTAssert(e == nil)
        }
    }
    func testPcoChannelMappedTransfer() {
        let exp = expectation(description: "ok")
        let sema = DispatchSemaphore(value: 0)
        let ch = PcoGCDChannel<Int>()
        let ch1 = ch.map({ "\($0)abc" })
        GCDActor.spawn { (_ ss: GCDActorSelf) in
            ch.send(111)
            sema.signal()
        }
        GCDActor.spawn { (_ ss: GCDActorSelf) in
            ch1.receive { s in
                XCTAssert(s == "111abc")
                exp.fulfill()
                sema.signal()
            }
        }
        sema.wait()
        sema.wait()
        waitForExpectations(timeout: 4) { (e: Error?) in
            XCTAssert(e == nil)
        }
    }
    func testPcoChannelBufferedMappedTransfered() {
        let exp = expectation(description: "ok")
        let sema = DispatchSemaphore(value: 0)
        let ch = PcoGCDChannel<Int>()
        let ch1 = ch.bufferedMap({ (_ s: Int) -> ([String]) in
            if s == 0 {
                return []
            }
            else {
                return ["aaa", "bbb", "ccc"]
            }
        })
        GCDActor.spawn { (_ ss: GCDActorSelf) in
            ch.send(111)
            sema.signal()
        }
        GCDActor.spawn { (_ ss: GCDActorSelf) in
            var counter = 0
            ch1.receive { s in
                switch counter {
                case 0:
                case 1:
                case 2.
                }
                XCTAssert(s == "111abc")
                exp.fulfill()
                sema.signal()
            }
        }
        sema.wait()
        sema.wait()
        waitForExpectations(timeout: 4) { (e: Error?) in
            XCTAssert(e == nil)
        }
    }

//    func test1() {
//        let sema = DispatchSemaphore(value: 0)
//        let (c1, e1) = Pco.spawn { (_ c: PcoAnyIncomingChannel<Int>, _ e: PcoAnyOutgoingChannel<Int>) in
//            c.receive { s in
//                print(s)
//            }
//            e.send(222)
//            e.close()
//        }
//        c1.send(111)
//        c1.close()
//        e1.receive { s in
//            print(s)
//        }
//        sema.wait()
//    }
//    func test1() {
//        let (c, e) = LineBashProcess.spawn()
//        c.send(.stdin("echo AAA"))
//        e.receive { s in
//            print(s)
//        }
//    }

}
