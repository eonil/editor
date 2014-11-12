//
//  EonilDispatchTests.swift
//  EonilDispatchTests
//
//  Created by Hoon H. on 11/12/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Cocoa
import XCTest
import EonilDispatch

class EonilDispatchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        XCTAssert(true, "Pass")
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
	

	func testSource1() {
		let	f1	=	FileDescriptor(path: "/Users/Eonil/Temp/aaa")
		let	q1	=	Queue.global(Queue.Priority.Background)
		let	f3	=	VNodeFlags.Attrib | VNodeFlags.Extend | VNodeFlags.Rename | VNodeFlags.Write
		let	s1	=	VNodeSource(file: f1, flag: f3, queue: q1)
		let	s2	=	Semaphore()
		
		s1.eventHandler	=	{
			println("EVENT!!")
//			s2.signal()
		}
		s1.cancelHandler	=	{
			println("CANCELLED!!")
			s2.signal()
		}
		s1.resume()
		s2.wait(Time.Forever)
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
	
}
