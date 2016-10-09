//
//  AppDelegate.swift
//  Editor5FileTreeUITestdrive
//
//  Created by Hoon H. on 2016/10/08.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSOutlineViewDataSource {
    @IBOutlet weak var window: NSWindow!
    private let testdrive = TestdriveViewController()
    func applicationDidFinishLaunching(_ notification: Notification) {
        window.contentViewController = testdrive
        window.setContentSize(NSSize(width: 500, height: 500))
    }
}












//@NSApplicationMain
//class AppDelegate: NSObject, NSApplicationDelegate, NSOutlineViewDataSource {
//
//    @IBOutlet weak var window: NSWindow!
//
//
//    private let scroll = NSScrollView()
//    private let outline = NSOutlineView()
//    var state1 =
//
//    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        window.contentView = scroll
//        scroll.documentView = outline
//        outline.dataSource = self
//        outline.setFrameSize(NSSize(width: 500, height: 500))
//        outline.addTableColumn(NSTableColumn(identifier: "A"))
////        outline.translatesAutoresizingMaskIntoConstraints = false
////        window.contentView?.addConstraint(NSLayoutConstraint(item: outline,
////                                                             attribute: NSLayoutAttribute.width,
////                                                             relatedBy: NSLayoutRelation.equal,
////                                                             toItem: window.contentView,
////                                                             attribute: NSLayoutAttribute.width,
////                                                             multiplier: 1,
////                                                             constant: 0))
////        window.contentView?.addConstraint(NSLayoutConstraint(item: outline,
////                                                             attribute: NSLayoutAttribute.height,
////                                                             relatedBy: NSLayoutRelation.equal,
////                                                             toItem: window.contentView,
////                                                             attribute: NSLayoutAttribute.height,
////                                                             multiplier: 1,
////                                                             constant: 0))
////        window.contentView?.addConstraint(NSLayoutConstraint(item: outline,
////                                                             attribute: NSLayoutAttribute.centerX,
////                                                             relatedBy: NSLayoutRelation.equal,
////                                                             toItem: window.contentView,
////                                                             attribute: NSLayoutAttribute.centerX,
////                                                             multiplier: 1,
////                                                             constant: 0))
////        window.contentView?.addConstraint(NSLayoutConstraint(item: outline,
////                                                             attribute: NSLayoutAttribute.centerY,
////                                                             relatedBy: NSLayoutRelation.equal,
////                                                             toItem: window.contentView,
////                                                             attribute: NSLayoutAttribute.centerY,
////                                                             multiplier: 1,
////                                                             constant: 0))
//    }
//
//    func applicationWillTerminate(_ aNotification: Notification) {
//        // Insert code here to tear down your application
//    }
//
////    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
////        return 10
////    }
////    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
////        let item1 = item as? String ?? ""
////        return item1 + "/\(index)"
////    }
////    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
////        return true
////    }
////    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
////        return "\(item)"
////    }
//
//    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
//        return 10
//    }
//    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
//    }
//    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
//        return true
//    }
//    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
//        return "\(item)"
//    }
//}
//
//
//
//
//
//
//
//
//
//
