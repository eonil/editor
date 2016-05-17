//
//  NSTaskTests.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/17.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import XCTest

class NSTaskTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test1() {
        let (t, ps) = makeTaskWithPipes()
        t.standardOutput = ps.1
        t.launchPath = "/bin/bash"
        t.arguments = ["-c", "echo AAA;"]
        t.launch()
        let output = ps.1.fileHandleForReading.readDataToEndOfFile()
        let output1 = NSString(data: output, encoding: NSUTF8StringEncoding)!
        XCTAssert(output1 == "AAA\n")
    }
    func test2() {
        let (t, ps) = makeTaskWithPipes()
        t.standardOutput = ps.1
        t.launchPath = "/bin/bash"
        t.arguments = ["--login", "-s"]
        t.launch()
        ps.0.fileHandleForWriting.writeData("echo AAA;\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        ps.0.fileHandleForWriting.writeData("exit 0;\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        t.waitUntilExit()
        let output = ps.1.fileHandleForReading.readDataToEndOfFile()
        let output1 = NSString(data: output, encoding: NSUTF8StringEncoding)!
        XCTAssert(output1 == "AAA\n")
    }
}

/// - Returns:
///     Tuple of task and pipes. Pipes are `(in, out, error)`.
private func makeTaskWithPipes() -> (task: NSTask, pipes: (NSPipe, NSPipe, NSPipe)) {
    let ps = (NSPipe(), NSPipe(), NSPipe())
    let t = NSTask()
    t.standardInput = ps.0
    t.standardOutput = ps.1
    t.standardError = ps.2
    return (t, ps)
}










