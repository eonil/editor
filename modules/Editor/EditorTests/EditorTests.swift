//
//  EditorTests.swift
//  EditorTests
//
//  Created by Hoon H. on 2017/10/07.
//  Copyright © 2017 Eonil. All rights reserved.
//

import XCTest
@testable import Editor

class EditorTests: XCTestCase {

    func testIndexPathToNamePathResolution() {
        typealias T = ProjectFeature.FileTree
        typealias N = ProjectFeature.FileNode
        let t = T(node: .root, subtrees: [
            T(node: N(name: "AAA", kind: .folder)),
            T(node: N(name: "BBB", kind: .folder)),
            T(node: N(name: "CCC", kind: .folder)),
            ])
        XCTAssertEqual(t.namePath(at: [0]), ["AAA"])
        XCTAssertEqual(t.namePath(at: [1]), ["BBB"])
        XCTAssertEqual(t.namePath(at: [2]), ["CCC"])
    }
    func testIndexPathToNamePathResolution2() {
        typealias T = ProjectFeature.FileTree
        typealias N = ProjectFeature.FileNode
        let t = T(node: .root, subtrees: [
            T(node: N(name: "AAA", kind: .folder)),
            T(node: N(name: "BBB", kind: .folder), subtrees: [
                T(node: N(name: "CCC", kind: .folder)),
                ]),
            ])
        XCTAssertEqual(t.namePath(at: [0]), ["AAA"])
        XCTAssertEqual(t.namePath(at: [1]), ["BBB"])
        XCTAssertEqual(t.namePath(at: [1, 0]), ["BBB", "CCC"])
    }
    func testIndexPathToNamePathResolutionWithEmptyPaths() {
        typealias T = ProjectFeature.FileTree
        typealias N = ProjectFeature.FileNode
        let t = T(node: .root, subtrees: [])
        XCTAssertEqual(t.namePath(at: []), [])
    }

    func testNamePathToIndexPathResolution() {
        typealias T = ProjectFeature.FileTree
        typealias N = ProjectFeature.FileNode
        let t = T(node: .root, subtrees: [
            T(node: N(name: "AAA", kind: .folder)),
            T(node: N(name: "BBB", kind: .folder)),
            T(node: N(name: "CCC", kind: .folder)),
            ])
        XCTAssertEqual(t.indexPath(at: ["AAA"]), [0])
        XCTAssertEqual(t.indexPath(at: ["BBB"]), [1])
        XCTAssertEqual(t.indexPath(at: ["CCC"]), [2])
    }
    func testNamePathToIndexPathResolutionWithEmptyPaths() {
        typealias T = ProjectFeature.FileTree
        typealias N = ProjectFeature.FileNode
        let t = T(node: .root, subtrees: [])
        XCTAssertEqual(t.indexPath(at: []), [])
    }

    func testNamePathSplitFirstWith2Components() {
        typealias P = ProjectItemPath
        let p = P(["AAA", "BBB"])
        let (a, b) = p.splitFirst()
        XCTAssertEqual(a, "AAA")
        XCTAssertEqual(b, ["BBB"])
    }
    func testNamePathSplitLastWith2Components() {
        typealias P = ProjectItemPath
        let p = P(["AAA", "BBB"])
        let (a, b) = p.splitLast()
        XCTAssertEqual(a, ["AAA"])
        XCTAssertEqual(b, "BBB")
    }
}
