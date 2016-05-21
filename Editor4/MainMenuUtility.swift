//
//  MainMenuUtility.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/01.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit

struct MainMenuUtility {
    static func instantiateApplicaitonMenu() -> NSMenu {
        // TODO: Make application menu items to dispatch proper actions.
        let appName = NSBundle.mainBundle().infoDictionary![kCFBundleNameKey as String] as! String
        let appMenu = NSMenu()
        let appServicesMenu = NSMenu()
        NSApp.servicesMenu = appServicesMenu
        appMenu.addItemWithTitle("About \(appName)", action: nil, keyEquivalent: "")
        appMenu.addItem(NSMenuItem.separatorItem())
        appMenu.addItemWithTitle("Preferences...", action: nil, keyEquivalent: ",")
        appMenu.addItem(NSMenuItem.separatorItem())
        appMenu.addItemWithTitle("Hide \(appName)", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
        appMenu.addItem({ ()->NSMenuItem in
            let m	=	NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
            m.keyEquivalentModifierMask	=	Int(NSEventModifierFlags([.CommandKeyMask, .AlternateKeyMask]).rawValue)
            return	m
            }())
        appMenu.addItemWithTitle("Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
        appMenu.addItem(NSMenuItem.separatorItem())
        appMenu.addItemWithTitle("Services", action: nil, keyEquivalent: "")!.submenu = appServicesMenu
        appMenu.addItem(NSMenuItem.separatorItem())
        appMenu.addItemWithTitle("Quit \(appName)", action: #selector(NSApplication.terminate), keyEquivalent: "q")
        return appMenu
    }
}