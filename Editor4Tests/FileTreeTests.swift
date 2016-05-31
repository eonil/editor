//
//  FileTreeTests.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/26.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import XCTest
@testable import Editor4

class FileTreeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test1() throws {
        var t = FileTree2(rootState: FileState2(form: FileForm.Container, phase: FilePhase.Normal, name: "folder1"))
        let folder1ID = t.rootID
        let folder2ID = try t.append(FileState2(form: .Container, phase: .Normal, name: "folder2"), asSubnodeOf: folder1ID)
        let file3ID = try t.append(FileState2(form: .Container, phase: .Normal, name: "file3"), asSubnodeOf: folder2ID)
        t.remove(file3ID)
        XCTAssert(t[folder1ID].subfileIDs.count == 1)
        XCTAssert(t[folder1ID].subfileIDs[0] == folder2ID)
        XCTAssert(t[folder2ID].subfileIDs.count == 0)
    }

    func test2() throws {
        var t = FileTree2(rootState: FileState2(form: FileForm.Container, phase: FilePhase.Normal, name: "folder1"))
        let folder1ID = t.rootID
        let folder2ID = try t.append(FileState2(form: .Container, phase: .Normal, name: "folder2"), asSubnodeOf: folder1ID)
        t.remove(folder2ID)
        XCTAssert(t[folder1ID].subfileIDs.count == 0)
    }

    func testFileRename() throws {
        var t = FileTree2(rootState: FileState2(form: FileForm.Container, phase: FilePhase.Normal, name: "folder1"))
        let folder1ID = t.rootID
        let folder2ID = try t.append(FileState2(form: .Container, phase: .Normal, name: "folder2"), asSubnodeOf: folder1ID)
        let file3ID = try t.append(FileState2(form: .Container, phase: .Normal, name: "file3"), asSubnodeOf: folder2ID)
        let priorVersion = t.version
        try t.rename(file3ID, to: "file3-b")
        XCTAssert(t[file3ID].name == "file3-b")
        XCTAssert(t.journal.logs.count >= 1)
        XCTAssert(t.journal.logs.last!.operation.isUpdate == true)
        XCTAssert(t.journal.logs.last!.operation.key == file3ID)
        XCTAssert(t.journal.logs.last!.version == priorVersion)
    }
}














