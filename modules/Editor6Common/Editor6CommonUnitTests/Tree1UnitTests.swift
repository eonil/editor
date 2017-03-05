//
//  Tree1UnitTests.swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/03/06.
//  Copyright © 2017 Eonil. All rights reserved.
//

import XCTest
@testable import Editor6Common

class Tree1UnitTests: XCTestCase {

    func testInit1() {
        let t = Tree1<Int, String>(state: "AAA")
        XCTAssertEqual(t.root.state, "AAA")
    }
    func testInit2() {
        let id = 111
        let s = "AAA"
        let t = Tree1<Int, String>(root: (id, s))
        XCTAssertEqual(t.root.id, 111)
        XCTAssertEqual(t.root.state, "AAA")
        XCTAssertEqual(t[t.root.id], "AAA")
    }
    func testInsert1() {
        let id = 111
        let s = "AAA"
        var t = Tree1<Int, String>(root: (id, s))
        let id2 = 222
        let s2 = "BBB"
        let id2b = t.insert((id2, s2), at: 0, in: id)
        XCTAssertEqual(t.children(of: 111).count, 1)
        XCTAssertEqual(t.children(of: 111)[0], 222)
        XCTAssertEqual(t[222], "BBB")
        XCTAssertEqual(id2, id2b)
        XCTAssertEqual(t.children(of: 222).count, 0)
    }

}

extension Int: Tree1NodeKey {
}
