//
//  MidLevelFeatureTests.swift
//  EonilSQLite3 - OSX - Tests
//
//  Created by Hoon H. on 11/3/14.
//
//

import Foundation
import XCTest
import EonilSQLite3




extension Connection {
	func allArraysByExecuting(code:String) -> [[Value]] {
		let	s	=	prepare(code)
		let	x	=	s.execute()
		return	x.allArrays()
	}
}

class MidLevelFeatureTests: XCTestCase {
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	
	func testCustomQuery1() {
		let	conn1	=	Connection(location: Connection.Location.Memory, editable: true)
		conn1.allArraysByExecuting("CREATE TABLE T1 (k1 INTEGER PRIMARY KEY, v1, v2, v3);")
		conn1.allArraysByExecuting("INSERT INTO T1 (k1, v1, v2, v3) VALUES (111, 42, 'Here be dragons.', NULL);")
		
		for (_, row) in enumerate(conn1.allArraysByExecuting("SELECT * FROM T1")) {
			XCTAssert(row[0] == 111)
			XCTAssert(row[1] == 42)
			XCTAssert(row[2] == "Here be dragons.")
			XCTAssert(row[3] == nil)
		}
	}
	
	
}





























