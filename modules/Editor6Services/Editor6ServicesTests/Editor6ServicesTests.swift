//
//  Editor6ServicesTests.swift
//  Editor6ServicesTests
//
//  Created by Hoon H. on 2017/01/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Dispatch
import XCTest
import EonilPco
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

    func testCargoInit() {
        let DIR_NAME = "____test_project1"
        print(LineBashProcess.run("pwd"))
        print(LineBashProcess.run("rmdir ./\(DIR_NAME)"))
        print(LineBashProcess.run("mkdir ./\(DIR_NAME)"))
        print(LineBashProcess.run(
            "cd ./\(DIR_NAME)",
            "pwd",
            "cargo init",
            "cargo build",
            "open ."
            ))
    }
    func testLineBash1() {
        let exp = expectation(description: "done")
        let (cch, ech) = LineBashProcess.spawn()
        Thread.detachNewThread {
            cch.send(.stdin("pwd"))
            cch.send(LineBashProcess.Command.stdin("echo AAA"))
            cch.send(LineBashProcess.Command.stdin("exit"))
            let pwd = ech.receive()!
            print(pwd)
            for e in ech {
                switch e {
                case .stdout(let line):
                    XCTAssert(line == "AAA")
                default:
                    break
                }
            }
            cch.send(nil)
            exp.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
}

extension Editor6ServicesTests {
    func waitForExpectations(timeout: TimeInterval) {
        waitForExpectations(timeout: timeout) { (_ e: Error?) in
            XCTAssert(e == nil, "error: \(e!)")
        }
    }
}
