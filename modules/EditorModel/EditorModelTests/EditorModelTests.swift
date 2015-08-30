//
//  EditorModelTests.swift
//  EditorModelTests
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import XCTest
@testable import EditorModel

class EditorModelTests: XCTestCase {

	private var	_mockPlatform	:	MockPlatformWithPseudoFileSystem?

    override func setUp() {
        super.setUp()
	_mockPlatform	=	MockPlatformWithPseudoFileSystem()
	Platform.initiate(_mockPlatform!)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
	Platform.terminate()
	_mockPlatform	=	nil
        super.tearDown()
    }

	func test1() {
		let	db	=	WorkspaceItemTreeDatabase()
		db.insertItemAtPath(WorkspaceItemPath(parts: ["src"]))
		db.insertItemAtPath(WorkspaceItemPath(parts: ["src/main.rs"]))
		let	s	=	db.snapshot()
		let	d	=	s.dataUsingEncoding(NSUTF8StringEncoding)!
		_mockPlatform!.fileContentMappings[NSURL(fileURLWithPath: "~/Documents/EditorTest/test1/Workspace.EditorFileList")]	=	d

		///
		
		let	m	=	ApplicationModel()
		m.run()
		m.openWorkspaceAtURL(NSURL(fileURLWithPath: "~/Documents/EditorTest/test1"))
		m.reselectCurrentWorkspace(m.workspaces.array.first!)
		m.closeWorkspace(m.workspaces.array.first!)
		m.halt()
	}
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
