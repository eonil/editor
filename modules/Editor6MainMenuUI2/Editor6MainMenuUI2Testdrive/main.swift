//
//  AppDelegate.swift
//  Editor6MainMenuUI2Testdrive
//
//  Created by Hoon H. on 2016/11/05.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Cocoa
import Editor6MainMenuUI2

/// You SHOULD NOT use `@NSApplicationMain` 
/// to make your custom menu to work.
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {

    }
    func applicationWillTerminate(_ aNotification: Notification) {}
}

//func makeMainMenu() -> NSMenu {
//    let mainMenu            = NSMenu() // `title` really doesn't matter.
//    let mainAppMenuItem     = NSMenuItem(title: "Application", action: nil, keyEquivalent: "") // `title` really doesn't matter.
//    let mainFileMenuItem    = NSMenuItem(title: "File", action: nil, keyEquivalent: "")
//    mainMenu.addItem(mainAppMenuItem)
//    mainMenu.addItem(mainFileMenuItem)
//
////    let appMenu             = NSMenu() // `title` really doesn't matter.
////    mainAppMenuItem.submenu = appMenu
////
////    let appServicesMenu     = NSMenu()
////    NSApp.servicesMenu      = appServicesMenu
//
////    appMenu.addItem(withTitle: "About Me", action: nil, keyEquivalent: "")
////    appMenu.addItem(NSMenuItem.separator())
////    appMenu.addItem(withTitle: "Preferences...", action: nil, keyEquivalent: ",")
////    appMenu.addItem(NSMenuItem.separator())
////    appMenu.addItem(withTitle: "Hide Me", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
////    appMenu.addItem({ () -> NSMenuItem in
////        let m = NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
////        m.keyEquivalentModifierMask = [.command, .option]
////        return m
////        }())
////    appMenu.addItem(withTitle: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
////
////    appMenu.addItem(NSMenuItem.separator())
////    appMenu.addItem(withTitle: "Services", action: nil, keyEquivalent: "").submenu = appServicesMenu
////    appMenu.addItem(NSMenuItem.separator())
////    appMenu.addItem(withTitle: "Quit Me", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
//
//    let fileMenu = NSMenu(title: "File")
//    mainFileMenuItem.submenu = fileMenu
////    fileMenu.addItem(withTitle: "New...", action: #selector(NSDocumentController.newDocument(_:)), keyEquivalent: "n")
//
//    return mainMenu
//}

let mmc = MainMenuUI2Controller()
let del = AppDelegate()

var mmcs = MainMenuUI2State()
mmcs.availableItems = [
    .applicationQuit,
    .fileNewWorkspace,
    .productRun,
]
mmc.reload(mmcs)
mmc.delegate { action in
    print(action)
    switch action {
    case .click(let menuItemID):
        switch menuItemID {
        case .applicationQuit:
            NSApplication.shared().terminate(nil)
        default:
            break
        }
    }
}

/// Setting main menu MUST be done before you setting app delegate.
/// I don't know why.
NSApplication.shared().mainMenu = mmc.menu
//NSApplication.shared().mainMenu = makeMainMenu()
NSApplication.shared().delegate = del
NSApplication.shared().run()


