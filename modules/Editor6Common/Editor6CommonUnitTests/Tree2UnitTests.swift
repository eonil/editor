//
//  Tree2UnitTests.swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

import XCTest
import Editor6Common

class Tree2UnitTests: XCTestCase {
    func testBasics1() {
        typealias TT = Tree2<Int,String>
        let rt = TT.IndexPath.root
        var tt = TT()
        XCTAssertEqual(tt.count, 0)
        XCTAssertTrue(tt[.root] == nil)

        tt[rt] = (100, "AAA")
        XCTAssertEqual(tt.count, 1)
        XCTAssertTrue(tt[.root] != nil)
        XCTAssertEqual(tt[.root]!.0, 100)
        XCTAssertEqual(tt[.root]!.1, "AAA")

        tt[rt.appendingLastComponent(0)] = (200, "BBB")
        XCTAssertEqual(tt.count, 2)
        XCTAssertEqual(tt[makeIndexPath([])]!.0, 100)
        XCTAssertEqual(tt[makeIndexPath([])]!.1, "AAA")
        XCTAssertTrue(tt[makeIndexPath([0])] != nil)
        XCTAssertEqual(tt[makeIndexPath([0])]!.0, 200)
        XCTAssertEqual(tt[makeIndexPath([0])]!.1, "BBB")

        tt[rt.appendingLastComponent(0).appendingLastComponent(0)] = (300, "CCC")
        XCTAssertEqual(tt.count, 3)
        XCTAssertEqual(tt[makeIndexPath([])]!.0, 100)
        XCTAssertEqual(tt[makeIndexPath([])]!.1, "AAA")
        XCTAssertEqual(tt[makeIndexPath([0])]!.0, 200)
        XCTAssertEqual(tt[makeIndexPath([0])]!.1, "BBB")
        XCTAssertEqual(tt[makeIndexPath([0, 0])]!.0, 300)
        XCTAssertEqual(tt[makeIndexPath([0, 0])]!.1, "CCC")

        tt[makeIndexPath([0, 0])] = nil
        XCTAssertEqual(tt.count, 2)
        XCTAssertEqual(tt[makeIndexPath([])]!.0, 100)
        XCTAssertEqual(tt[makeIndexPath([])]!.1, "AAA")
        XCTAssertEqual(tt[makeIndexPath([0])]!.0, 200)
        XCTAssertEqual(tt[makeIndexPath([0])]!.1, "BBB")

        tt[makeIndexPath([0])] = nil
        XCTAssertEqual(tt.count, 1)
        XCTAssertEqual(tt[makeIndexPath([])]!.0, 100)
        XCTAssertEqual(tt[makeIndexPath([])]!.1, "AAA")

        tt[makeIndexPath([])] = nil
        XCTAssertEqual(tt.count, 0)
    }
    func testBasics2() {
        typealias TT = Tree2<Int,String>
        var tt = TT()
        XCTAssertEqual(tt.count, 0)
        XCTAssertTrue(tt[.root] == nil)

        tt[makeIndexPath([])] = (100, "AAA")
        tt[makeIndexPath([0])] = (200, "BBB")
        tt[makeIndexPath([0, 0])] = (300, "CCC")

        tt[makeIndexPath([0])] = nil
        XCTAssertEqual(tt.count, 1)
        XCTAssertEqual(tt[makeIndexPath([])]!.0, 100)
        XCTAssertEqual(tt[makeIndexPath([])]!.1, "AAA")

        tt[makeIndexPath([])] = nil
        XCTAssertEqual(tt.count, 0)
    }
    func testBasics3() {
        typealias TT = Tree2<Int,String>
        var tt = TT()
        XCTAssertEqual(tt.count, 0)
        XCTAssertTrue(tt[.root] == nil)

        tt[makeIndexPath([])] = (100, "AAA")
        tt[makeIndexPath([0])] = (200, "BBB")
        tt[makeIndexPath([0, 0])] = (300, "CCC")

        tt[makeIndexPath([])] = nil
        XCTAssertEqual(tt.count, 0)
    }
    func tesMultipleChildren() {
        typealias TT = Tree2<Int,String>
        var tt = TT()
        XCTAssertEqual(tt.count, 0)
        XCTAssertTrue(tt[.root] == nil)

        tt[makeIndexPath([])] = (100, "AAA")
        tt[makeIndexPath([0])] = (200, "BBB0")
        tt[makeIndexPath([1])] = (200, "BBB1")
        tt[makeIndexPath([2])] = (200, "BBB2")
        tt[makeIndexPath([1, 0])] = (300, "CCC0")
        tt[makeIndexPath([1, 1])] = (300, "CCC1")
        tt[makeIndexPath([1, 2])] = (300, "CCC2")
        XCTAssertEqual(tt.count, 7)
        XCTAssertEqual(tt[makeIndexPath([1, 2])]!.0, 100)
        XCTAssertEqual(tt[makeIndexPath([1, 2])]!.1, "AAA")

        tt[makeIndexPath([])] = nil
        XCTAssertEqual(tt.count, 0)
    }
}

private func makeIndexPath<K,V>(_ components: [Int]) -> Tree2<K,V>.IndexPath {
    return Tree2<K,V>.IndexPath(components: components)
}

