//
//  AppDelegate.swift
//  Editor6WorkspaceModelTestdrive
//
//  Created by Hoon H. on 2016/10/18.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Cocoa
@testable import Editor6WorkspaceModel

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    private let flow = Flow2<AppDelegate>()
    private let bash = ADHOC_TextLineBashSubprocess()
    private let cargo = CargoModel()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        flow.context = self
        flow.execute { ss in
            ss.bash.queue(.launch)
            ss.bash.queue(.stdin(lines: [
                "set -e",
                "echo CHK",
                "cd ~/",
                "rm -rf ~/Workshop/Temp/a2",
                "mkdir ~/Workshop/Temp/a2",
                "mkdir ~/Workshop/Temp/a2/src",
                "echo TEST1 > ~/Workshop/Temp/a2/src/main.rs",
                "exit",
                ]))
            ss.bash.delegate { e in
                switch e {
                case .stdout(let lines):
                    print(lines)
                case .stderr(let lines):
                    print(lines)
                    fatalError()
                case .term(let exitCode):
                    precondition(exitCode == 0)
                    ss.flow.signal()
                }
            }
        }
        flow.wait { ss in
            return ss.bash.phase != .terminated
        }
        flow.execute { ss in

        }
        flow.execute { ss in
            let u = URL(fileURLWithPath: "/Users/Eonil/Workshop/Temp/a2")
            ss.cargo.queue(.init(u))
            ss.cargo.queue(.build(u))
            ss.cargo.delegate { e in
                switch e {
                case .phase:
                    print(ss.cargo.state)
                case .issue(let i):
                    print(i)
                case .error(let e):
                    print(e)
                }
            }
        }
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

