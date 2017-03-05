//
//  AppDelegate.swift
//  Editor6WorkspaceModelTestdrive
//
//  Created by Hoon H. on 2016/10/18.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Cocoa
import Editor6Common
@testable import Editor6WorkspaceModel

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

//    private let flow = Flow2<AppDelegate>()
//    private let bash = ADHOC_TextLineBashSubprocess()
//    private let cargo = CargoModel()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        flow.context = self
//        flow.execute { ss in
//            ss.bash.queue(.launch)
//            ss.bash.queue(.stdin(lines: [
//                "set -e",
//                "echo CHK",
//                "cd ~/",
//                "rm -rf ~/Workshop/Temp/a2",
//                "mkdir ~/Workshop/Temp/a2",
//                "mkdir ~/Workshop/Temp/a2/src",
//                "echo TEST1 > ~/Workshop/Temp/a2/src/main.rs",
//                "exit",
//                ]))
//            ss.bash.delegate { e in
//                switch e {
//                case .stdout(let lines):
//                    print(lines)
//                case .stderr(let lines):
//                    print(lines)
//                    fatalError()
//                case .term(let exitCode):
//                    precondition(exitCode == 0)
//                    ss.flow.signal()
//                }
//            }
//        }
//        flow.wait { ss in
//            return ss.bash.phase != .terminated
//        }
//        flow.execute { ss in
//
//        }
//        flow.execute { ss in
//            let u = URL(fileURLWithPath: "/Users/Eonil/Workshop/Temp/a2")
//            ss.cargo.queue(.init(u))
//            ss.cargo.queue(.build(u))
//            ss.cargo.delegate { e in
//                switch e {
//                case .phase:
//                    print(ss.cargo.state)
//                case .issue(let i):
//                    print(i)
//                case .error(let e):
//                    print(e)
//                }
//            }
//        }
        b()
        a()
    }

//    private func check1() {
//        if let lines = try! bashcon.readOutputLines() {
//            if lines.count > 0 {
//                Swift.print(lines)
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in self?.check1() }
//    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}



private func b() {
    let bashsp = ADHOC_TextLineBashSubprocess()
    final class Context {
        var isRunning = true
    }
    let ctx = Context()
    let flow = Flow2<AnyObject>()
    flow.context = ctx

    bashsp.delegate {
        print($0)
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
//            "exit",
            ]))
    }
    flow.wait { _ in
        return ctx.isRunning
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) { [bashsp, flow, ctx] in
        debugLog("AAAAA \(bashsp)")
    }
}


private func a() {
    let cargo = CargoModel()
    let flow = Flow2<CargoModel>()
    flow.context = cargo

    cargo.delegate { e in
        print(e)
        switch e {
        case .error(let e1):
            switch e1 {
            case .nonZeroExit(_):
                fatalError()
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
}
