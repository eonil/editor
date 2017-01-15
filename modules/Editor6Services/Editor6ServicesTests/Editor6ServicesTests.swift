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
    
}

extension Editor6ServicesTests {
    func waitForExpectations(timeout: TimeInterval) {
        waitForExpectations(timeout: timeout) { (_ e: Error?) in
            XCTAssert(e == nil, "error: \(e!)")
        }
    }
}
