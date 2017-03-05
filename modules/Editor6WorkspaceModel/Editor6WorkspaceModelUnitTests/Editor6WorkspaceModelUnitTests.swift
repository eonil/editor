//
//  Editor6WorkspaceModelUnitTests.swift
//  Editor6WorkspaceModelUnitTests
//
//  Created by Hoon H. on 2017/03/05.
//  Copyright © 2017 Eonil. All rights reserved.
//

import XCTest
import Editor6Common
@testable import Editor6WorkspaceModel

class Editor6WorkspaceModelUnitTests: XCTestCase {

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
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testBashCC() {
        let exp = expectation(description: "BashCC")
        let bashsp = ADHOC_TextLineBashSubprocess()
        final class Context {
            var isRunning = true
        }
        let ctx = Context()
        let flow = Flow2<AnyObject>()
        flow.context = ctx
        
        bashsp.delegate { [weak self] in
            switch $0 {
            case .stdout(let lines):
                print(lines)
            case .stderr(let lines):
                break
            case .term(let exitCode):
                ctx.isRunning = false
                flow.signal()
            }
        }

        flow.execute { _ in
            bashsp.queue(.launch)
            bashsp.queue(.stdin(lines: [
                "env",
//                "\"cc\" \"-m64\" \"-L\" \"/Users/Eonil/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/x86_64-apple-darwin/lib\" \"/Users/Eonil/Workshop/Temp/a7/target/debug/a7.0.o\" \"-o\" \"/Users/Eonil/Workshop/Temp/a7/target/debug/a7\" \"-Wl,-dead_strip\" \"-nodefaultlibs\" \"-L\" \"/Users/Eonil/Workshop/Temp/a7/target/debug/deps\" \"-L\" \"/Users/Eonil/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/x86_64-apple-darwin/lib\" \"/Users/Eonil/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/x86_64-apple-darwin/lib/libstd-f5a209a9.rlib\" \"/Users/Eonil/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/x86_64-apple-darwin/lib/libpanic_unwind-f5a209a9.rlib\" \"/Users/Eonil/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/x86_64-apple-darwin/lib/libunwind-f5a209a9.rlib\" \"/Users/Eonil/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/x86_64-apple-darwin/lib/librand-f5a209a9.rlib\" \"/Users/Eonil/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/x86_64-apple-darwin/lib/libcollections-f5a209a9.rlib\" \"/Users/Eonil/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/x86_64-apple-darwin/lib/librustc_unicode-f5a209a9.rlib\" \"/Users/Eonil/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/x86_64-apple-darwin/lib/liballoc-f5a209a9.rlib\" \"/Users/Eonil/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/x86_64-apple-darwin/lib/liballoc_jemalloc-f5a209a9.rlib\" \"/Users/Eonil/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/x86_64-apple-darwin/lib/liblibc-f5a209a9.rlib\" \"/Users/Eonil/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/x86_64-apple-darwin/lib/libcore-f5a209a9.rlib\" \"/Users/Eonil/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/x86_64-apple-darwin/lib/libcompiler_builtins-f5a209a9.rlib\" \"-l\" \"System\" \"-l\" \"pthread\" \"-l\" \"c\" \"-l\" \"m\"",
                "cc --version",
                "exit",
                ]))
        }
        flow.wait { _ in
            return ctx.isRunning
        }
        flow.execute { _ in
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) { (e: Error?) in
            XCTAssertNil(e)
        }
    }
    func testCargoBuild1() {
        let exp = expectation(description: "CargoBuild1")
        let cargo = CargoModel()
        let flow = Flow2<CargoModel>()
        flow.context = cargo

        cargo.delegate { e in
            print(e)
            switch e {
            case .error(let e1):
                switch e1 {
                case .nonZeroExit(_):
                    XCTFail()
                default:
                    break
                }
            default:
                break
            }
            flow.signal()
        }
        flow.execute { _ in
            let dirpath = NSTemporaryDirectory()
            let u = URL(fileURLWithPath: dirpath).appendingPathComponent("ttt1")
            try? FileManager.default.removeItem(at: u)
            try! FileManager.default.createDirectory(at: u, withIntermediateDirectories: true, attributes: nil)
            cargo.queue(.init(u))
            cargo.queue(.build(u))
        }
        flow.wait { _ in
            return cargo.state.phase == .busy
        }
        flow.execute { _ in
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) { (e: Error?) in
            XCTAssertNil(e)
        }
    }

}
