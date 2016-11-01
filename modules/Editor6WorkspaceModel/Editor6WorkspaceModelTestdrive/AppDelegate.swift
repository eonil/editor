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
    private let bashcon = Bash1()

    private let driver = Driver()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        

//        // Insert code here to initialize your application
//        bashcon.writeInputLines(lines: [
//            "echo AAA",
//            ])
//        do {
//            check1()
//        }
        bashcon.delegate { (sender: Bash1, action: Bash1.Action) in
            print(action)
        }
        bashcon.dispatch(["cargo"])
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

