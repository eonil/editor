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
	private var	_isRunningCase	=	false

    override func setUp() {
        super.setUp()
	assert(_isRunningCase == false)
	_isRunningCase	=	true
	_mockPlatform	=	MockPlatformWithPseudoFileSystem()
	Platform.initiate(_mockPlatform!)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
	assert(_isRunningCase == true)
        // Put teardown code here. This method is called after the invocation of each test method in the class.
	Platform.terminate()
	_mockPlatform	=	nil
	_isRunningCase	=	false
        super.tearDown()
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

	func test101_Snapshot_101_Storing() {
		let	db	=	WorkspaceItemTreeDatabase()
		//	Root already exist.
		db.insertItemAtPath(WorkspaceItemPath(parts: ["src"]))
		db.insertItemAtPath(WorkspaceItemPath(parts: ["src", "main.rs"]))
		db.insertSubitemAtPath(WorkspaceItemPath(parts: ["src"]),
			at	:	0,
			to	:	WorkspaceItemPath(parts: []))
		db.insertSubitemAtPath(WorkspaceItemPath(parts: ["src", "main.rs"]),
			at	:	0,
			to	:	WorkspaceItemPath(parts: ["src"]))

		let	s	=	db.snapshot()
		let	s1	=	[
			"editor://workspace/",
			"editor://workspace/src",
			"editor://workspace/src/main.rs",
			].joinWithSeparator("\n")
		assert(s == s1)
	}
	func test101_Snapshot_102_Restoration() {
		let	s	=	[
			"editor://workspace/",
			"editor://workspace/src",
			"editor://workspace/src/main.rs",
		].joinWithSeparator("\n")
		let	db	=	try! WorkspaceItemTreeDatabase(snapshot: s, repairAutomatically: false)
		assert(db.count == 3)
		assert(db.containsItemForPath(WorkspaceItemPath(parts: [])) == true)
		assert(db.containsItemForPath(WorkspaceItemPath(parts: ["src"])) == true)
		assert(db.containsItemForPath(WorkspaceItemPath(parts: ["src", "main.rs"])) == true)
		assert(db.allSubitemsOfItemAtPath(WorkspaceItemPath(parts: [])) == [
			WorkspaceItemPath(parts: ["src"]),
			])
		assert(db.allSubitemsOfItemAtPath(WorkspaceItemPath(parts: ["src"])) == [
			WorkspaceItemPath(parts: ["src", "main.rs"]),
			])
	}

	func test1() {
		let	mkp	=	MockPlatformWithPseudoFileSystem()
		let	db	=	WorkspaceItemTreeDatabase()
		//	Root already exist.
		db.insertItemAtPath(WorkspaceItemPath(parts: ["src"]))
		db.insertItemAtPath(WorkspaceItemPath(parts: ["src", "main.rs"]))
		db.insertSubitemAtPath(WorkspaceItemPath(parts: ["src"]),
			at	:	0,
			to	:	WorkspaceItemPath(parts: []))
		db.insertSubitemAtPath(WorkspaceItemPath(parts: ["src", "main.rs"]),
			at	:	0,
			to	:	WorkspaceItemPath(parts: ["src"]))

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


	func test201_FileTreeRestoration_001() {
		let	exp	=	expectationWithDescription("Test Completion Marker")

		let	db	=	WorkspaceItemTreeDatabase()
		//	Root already exist.
		assert(db.count == 1)

		let	s	=	db.snapshot()
		let	d	=	s.dataUsingEncoding(NSUTF8StringEncoding)!
		_mockPlatform!.fileContentMappings[NSURL(fileURLWithPath: "~/Documents/EditorTest/test1/Workspace.EditorFileList")]	=	d

		///

		let	app	=	ApplicationModel()
		app.run()
		app.openWorkspaceAtURL(NSURL(fileURLWithPath: "~/Documents/EditorTest/test1"))
		app.reselectCurrentWorkspace(app.workspaces.array.first!)
		assert(app.defaultWorkspace.value != nil)

		let	workspace	=	app.defaultWorkspace.value!
		assert(workspace.location.value != nil)
		assert(workspace.location.value == NSURL(fileURLWithPath: "~/Documents/EditorTest/test1"))
		assert(workspace.file.root.value != nil)

		workspace.file.restoring.queue() { [app] in
			let	root		=	workspace.file.root.value!
			assert(root.subnodes.array.count == 0)

			assert(root._isInstalled == true)
			app.closeWorkspace(workspace)
			workspace.file.storing.queue() { [app, weak root] in
				assert(root == nil)
				app.halt()
				exp.fulfill()
			}

		}

		waitForExpectationsWithTimeout(_DEFAULT_TIMEOUT) { (error: NSError?) -> Void in
			assert(error == nil)
		}
	}

	func test201_FileTreeRestoration_002() {
		let	exp	=	expectationWithDescription("Test Completion Marker")

		let	db	=	WorkspaceItemTreeDatabase()
		//	Root already exist.
		db.insertItemAtPath(WorkspaceItemPath(parts: ["src"]))
		db.insertItemAtPath(WorkspaceItemPath(parts: ["src", "main.rs"]))
		db.insertSubitemAtPath(WorkspaceItemPath(parts: ["src"]),
			at	:	0,
			to	:	WorkspaceItemPath(parts: []))
		db.insertSubitemAtPath(WorkspaceItemPath(parts: ["src", "main.rs"]),
			at	:	0,
			to	:	WorkspaceItemPath(parts: ["src"]))
		assert(db.count == 3)

		let	s	=	db.snapshot()
		let	d	=	s.dataUsingEncoding(NSUTF8StringEncoding)!
		_mockPlatform!.fileContentMappings[NSURL(fileURLWithPath: "~/Documents/EditorTest/test1/Workspace.EditorFileList")]	=	d

		///

		let	app	=	ApplicationModel()
		app.run()
		app.openWorkspaceAtURL(NSURL(fileURLWithPath: "~/Documents/EditorTest/test1"))
		app.reselectCurrentWorkspace(app.workspaces.array.first!)
		assert(app.defaultWorkspace.value != nil)

		let	workspace	=	app.defaultWorkspace.value!
		assert(workspace.location.value != nil)
		assert(workspace.location.value == NSURL(fileURLWithPath: "~/Documents/EditorTest/test1"))
		assert(workspace.file.root.value != nil)

		workspace.file.restoring.queue() { [app] in
			let	root		=	workspace.file.root.value!
			assert(root.subnodes.array.count == 1)
			assert(root.subnodes.array[0].path.value != nil)
			assert(root.subnodes.array[0].path.value == WorkspaceItemPath(parts: ["src"]))

			assert(root.subnodes.array[0].subnodes.array.count == 1)
			assert(root.subnodes.array[0].subnodes.array[0].path.value == WorkspaceItemPath(parts: ["src", "main.rs"]))

			app.closeWorkspace(workspace)
			workspace.file.storing.queue() { [app, weak root] in
				app.halt()
				exp.fulfill()
			}

		}

		waitForExpectationsWithTimeout(_DEFAULT_TIMEOUT) { (error: NSError?) -> Void in
			assert(error == nil)
		}
	}
}

private let	_DEFAULT_TIMEOUT	=	10 as NSTimeInterval































public func delay(duration: NSTimeInterval, function: ()->()) {
	assert(NSThread.isMainThread())

	let	delta	=	Int64(NSTimeInterval(NSEC_PER_SEC) * duration)
	let	when	=	dispatch_time(DISPATCH_TIME_NOW, delta)
	dispatch_after(when, dispatch_get_main_queue(), function)
}









