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
        let folder1 = t.rootID
        let folder2 = try t.append(FileState2(form: .Container, phase: .Normal, name: "folder2"), asSubnodeOf: t.rootID)
        let file3 = try t.append(FileState2(form: .Container, phase: .Normal, name: "file3"), asSubnodeOf: folder2)
        t.remove(file3)
        XCTAssert(t[folder1].subfileIDs.count == 1)
        XCTAssert(t[folder1].subfileIDs[0] == folder2)
        XCTAssert(t[folder2].subfileIDs.count == 0)
    }

    func test2() throws {
        var t = FileTree2(rootState: FileState2(form: FileForm.Container, phase: FilePhase.Normal, name: "folder1"))
        let folder1 = t.rootID
        let folder2 = try t.append(FileState2(form: .Container, phase: .Normal, name: "folder2"), asSubnodeOf: t.rootID)
        let file3 = try t.append(FileState2(form: .Container, phase: .Normal, name: "file3"), asSubnodeOf: folder2)
        t.remove(folder2)
        XCTAssert(t[folder1].subfileIDs.count == 0)
    }
}