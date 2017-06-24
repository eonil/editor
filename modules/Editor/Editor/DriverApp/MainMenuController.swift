////
////  MainMenuController.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/15.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//import AppKit
//import EonilSignet
//
//final class MainMenuController: NSObject {
//    let event = Relay<Event>()
//
//    @IBOutlet var menu: NSMenu? {
//        didSet {
//            NSApplication.shared().mainMenu = menu
//        }
//    }
//
//    override init() {
//        super.init()
//        let nib = NSNib(nibNamed: "MainMenu", bundle: Bundle(for: type(of: self)))!
//        nib.instantiate(withOwner: self, topLevelObjects: nil)
//    }
//    deinit {
////        NSApplication.shared().mainMenu = nil
//    }
//
//    @IBAction private func makeRandomFiles(_: AnyObject?) {
//        event.cast(.click(.testdriveMakeRandomFiles))
//    }
//    @IBAction private func fileNewWorkspace(_: AnyObject?) {
//        event.cast(.click(.fileNewWorkspace))
//    }
//    @IBAction private func fileNewFolder(_: AnyObject?) {
//        event.cast(.click(.fileNewFolder))
//    }
//    @IBAction private func fileNewFile(_: AnyObject?) {
//        event.cast(.click(.fileNewFile))
//    }
//}
//extension MainMenuController {
//    enum Event {
//        case click(MainMenuItemID)
//    }
//}
