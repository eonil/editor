//
//  EditorWorkspaceNavigationFeatureTests.swift
//  EditorWorkspaceNavigationFeatureTests
//
//  Created by Hoon H. on 2015/02/21.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import XCTest
import EditorWorkspaceNavigationFeature

class EditorWorkspaceNavigationFeatureTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}


extension EditorWorkspaceNavigationFeatureTests {
	func testRepo1() {
		let	r1	=	WorkspaceRepository(name: "Repo 1")
		let	n1	=	r1.root.createChildNodeForName("Node 1", kind: WorkspaceNodeKind.Folder)
		n1.rename("N2")
	}
	func testRepo2() {
		let	r1	=	WorkspaceRepository(name: "Repo 1")
		let	n1	=	r1.root.createChildNodeForName("N1", kind: WorkspaceNodeKind.Folder)
		let	n2	=	n1.createChildNodeForName("N2", kind: WorkspaceNodeKind.Folder)
		n2.move(toParentNode: r1.root, atIndex: 1, asName: "X1")
		XCTAssert(r1.root.children.count == 2)
		XCTAssert(r1.root.children[0] === n1)
		XCTAssert(r1.root.children[1] === n2)
		XCTAssert(r1.root.children[0].children.count == 0)
		XCTAssert(r1.root.children[1].children.count == 0)
		
		r1.root.deleteChildNodeAtIndex(0)
		XCTAssert(r1.root.children.count == 1)
		XCTAssert(r1.root.children[0] === n2)
		
		r1.root.deleteChildNodeAtIndex(0)
		XCTAssert(r1.root.children.count == 0)
	}
}



