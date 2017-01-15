////
////  Editor6ServicesTests.swift
////  Editor6ServicesTests
////
////  Created by Hoon H. on 2017/01/15.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//import Dispatch
//import XCTest
//import EonilGCDActor
//@testable import Editor6Services
//
//class Editor6ServicesTests: XCTestCase {
//    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//
//    func testPcoGCDChannelClosing() {
//        let ch = PcoGCDChannel<Int>()
//        ch.send(nil)
//        XCTAssert(ch.isClosed)
//    }
//    func testPcoGCDChannelClosing1() {
//        let exp = expectation(description: "done")
//        let sema = DispatchSemaphore(value: 0)
//        let ch = PcoGCDChannel<Int>()
//        GCDActor.spawn { (_: GCDActorSelf) in
//            ch.send(nil)
//            sema.signal()
//        }
//        GCDActor.spawn { (_: GCDActorSelf) in
//            let s = ch.receive()
//            XCTAssert(s == nil)
//            let s1 = ch.receive()
//            XCTAssert(s1 == nil)
//            sema.signal()
//            exp.fulfill()
//        }
//        sema.wait()
//        sema.wait()
//        XCTAssert(ch.isClosed)
//        waitForExpectations(timeout: 5)
//    }
//    func testPcoGCDChannelClosing2() {
//        let exp = expectation(description: "done")
//        let sema = DispatchSemaphore(value: 0)
//        let ch = PcoGCDChannel<Int>()
//        GCDActor.spawn { (_ s: GCDActorSelf) in
//            ch.send(111)
//            s.sleep(for: 1)
//            ch.send(222)
//            s.sleep(for: 0.5)
//            ch.send(333)
//            ch.send(nil)
//            sema.signal()
//        }
//        GCDActor.spawn { (_ s: GCDActorSelf) in
//            s.sleep(for: 0.1)
//            let r1 = ch.receive()
//            s.sleep(for: 0.5)
//            let r2 = ch.receive()
//            s.sleep(for: 1)
//            let r3 = ch.receive()
//            let r4 = ch.receive()
//            XCTAssert(r1 == 111, "expected \(111), but actually = \(r1)")
//            XCTAssert(r2 == 222, "expected \(222), but actually = \(r2)")
//            XCTAssert(r3 == 333, "expected \(333), but actually = \(r3)")
//            XCTAssert(r4 == nil)
//            sema.signal()
//            exp.fulfill()
//        }
//        sema.wait()
//        sema.wait()
//        XCTAssert(ch.isClosed)
//        waitForExpectations(timeout: 5)
//    }
//    func testPcoGCDChannelClosing3() {
//        let exp = expectation(description: "done")
//        let sema = DispatchSemaphore(value: 0)
//        let ch = PcoGCDChannel<Int>()
//        let n = 4
//        GCDActor.spawn { (_ s: GCDActorSelf) in
//            for i in 0..<n {
//                let k = i
//                ch.send(k)
//                print("send: \(k)")
//            }
//            sema.signal()
//        }
//        GCDActor.spawn { (_ s: GCDActorSelf) in
//            for i in 0..<(n) {
//                let r = ch.receive()
//                XCTAssert(r == i, "expected \(i), but actually = \(r)")
//                print("recv: \(i)")
//            }
//            sema.signal()
//            exp.fulfill()
//        }
//        sema.wait()
//        sema.wait()
//        ch.send(nil)
//        XCTAssert(ch.receive() == nil)
//        XCTAssert(ch.isClosed)
//        waitForExpectations(timeout: 5)
//    }
//    func testPcoGCDChannelClosing4() {
//        let gcdq = DispatchQueue(label: "serialq")
//        let exp = expectation(description: "done")
//        let sendSema = DispatchSemaphore(value: 0)
//        let recvSema = DispatchSemaphore(value: 0)
//        let ch = PcoGCDChannel<Int>()
//        let itemUnitSize = 3
//        let sendActorCount = 2
//        let recvActorCount = 13
//        var a = [Int]()
//        for j in 0..<sendActorCount {
//            GCDActor.spawn { (_ s: GCDActorSelf) in
//                for i in 0..<itemUnitSize {
//                    let k = i * sendActorCount + j
//                    ch.send(k)
//                    print("send\(j): \(k)")
//                }
//                sendSema.signal()
//                print("send\(j) done.")
//            }
//        }
//        for j in 0..<recvActorCount {
//            GCDActor.spawn { (_ s: GCDActorSelf) in
//                print("recv\(j) start.")
//                var ks = [Int]()
//                for _ in 0..<itemUnitSize {
//                    print("going to recv\(j): ...")
//                    if let r = ch.receive() {
//                        print("recv\(j): \(r)")
//                        ks.append(r)
//                    }
//                }
//                XCTAssert(ks.sorted() == ks)
//                print("recv\(j) collected: \(ks.count).")
//                gcdq.async {
//                    a.append(contentsOf: ks)
//                    recvSema.signal()
//                    print("recv\(j) done.")
//                }
//            }
//        }
//        for _ in 0..<sendActorCount {
//            sendSema.wait()
//        }
//        ch.send(nil)
//        for _ in 0..<recvActorCount {
//            recvSema.wait()
//        }
//        XCTAssert(ch.receive() == nil)
//        XCTAssert(ch.isClosed)
//        gcdq.sync {
//            let b = a.sorted()
//            let c = Array(0..<(itemUnitSize * sendActorCount))
//            XCTAssert(b == c)
//        }
//        exp.fulfill()
//        waitForExpectations(timeout: 5)
//    }
//
////    func testPcoGCDChannelTransfer() {
////        let exp = expectation(description: "ok")
////        let sema = DispatchSemaphore(value: 0)
////        let ch = PcoGCDChannel<Int>()
////        GCDActor.spawn { (_ ss: GCDActorSelf) in
////            ch.send(111)
////            sema.signal()
////        }
////        GCDActor.spawn { (_ ss: GCDActorSelf) in
////            var first = true
////            for s in ch {
////                XCTAssert(first)
////                XCTAssert(s == 111)
////                exp.fulfill()
////                sema.signal()
////                first = false
////            }
////        }
////        sema.wait()
////        sema.wait()
////        waitForExpectations(timeout: 4) { (e: Error?) in
////            XCTAssert(e == nil)
////        }
////    }
////    func testPcoChannelMappedTransfer() {
////        let exp = expectation(description: "ok")
////        let sema = DispatchSemaphore(value: 0)
////        let ch = PcoGCDChannel<Int>()
////        let ch1 = ch.map({ "\($0)abc" })
////        GCDActor.spawn { (_ ss: GCDActorSelf) in
////            ch.send(111)
////            sema.signal()
////        }
////        GCDActor.spawn { (_ ss: GCDActorSelf) in
////            var first = true
////            for s in ch1 {
////                XCTAssert(first)
////                XCTAssert(s == "111abc")
////                exp.fulfill()
////                sema.signal()
////                first = false
////            }
////        }
////        sema.wait()
////        sema.wait()
////        waitForExpectations(timeout: 4) { (e: Error?) in
////            XCTAssert(e == nil)
////        }
////    }
////    func testPcoChannelBufferedMappedTransfered() {
////        let exp = expectation(description: "ok")
////        let sema = DispatchSemaphore(value: 0)
////        let ch = PcoGCDChannel<Int>()
////        let ch1 = ch.bufferedMap({ (_ s: Int) -> ([String]) in
////            if s == 0 {
////                return []
////            }
////            else {
////                return ["aaa", "bbb", "ccc"]
////            }
////        })
////        GCDActor.spawn { (_ ss: GCDActorSelf) in
////            ch.send(111)
////            sema.signal()
////        }
////        GCDActor.spawn { (_ ss: GCDActorSelf) in
////            var counter = 0
////            for s in ch1 {
////                switch counter {
////                case 0:
////                    XCTAssert(s == "aaa")
////                case 1:
////                    XCTAssert(s == "bbb")
////                case 2:
////                    XCTAssert(s == "ccc")
////                default:
////                    XCTFail()
////                }
////                counter += 1
////            }
////            XCTAssert(counter == 3)
////            exp.fulfill()
////            sema.signal()
////        }
////        sema.wait()
////        sema.wait()
////        waitForExpectations(timeout: 4) { (e: Error?) in
////            XCTAssert(e == nil)
////        }
////    }
//
////    func test1() {
////        let sema = DispatchSemaphore(value: 0)
////        let (c1, e1) = Pco.spawn { (_ c: PcoAnyIncomingChannel<Int>, _ e: PcoAnyOutgoingChannel<Int>) in
////            c.receive { s in
////                print(s)
////            }
////            e.send(222)
////            e.close()
////        }
////        c1.send(111)
////        c1.close()
////        e1.receive { s in
////            print(s)
////        }
////        sema.wait()
////    }
////    func test1() {
////        let (c, e) = LineBashProcess.spawn()
////        c.send(.stdin("echo AAA"))
////        e.receive { s in
////            print(s)
////        }
////    }
//
//}
//
//extension Editor6ServicesTests {
//    func waitForExpectations(timeout: TimeInterval) {
//        waitForExpectations(timeout: timeout) { (_ e: Error?) in
//            XCTAssert(e == nil, "error: \(e!)")
//        }
//    }
//}
