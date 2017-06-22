////
////  OutlineViewController.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/21.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//import AppKit
//
//final class OutlineViewController: NSObject, NSOutlineViewDataSource {
//    typealias NodeProtocol = OutlineViewNodeProtocol
//    
//    var node: NodeProtocol?
//    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
//        if let item = item {
//            let parent = item as! NodeProtocol
//            return parent.numberOfSubnodes
//        }
//        else {
//            return 1
//        }
//    }
//    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
//        let me = item as! NodeProtocol
//        return me.isExpandable
//    }
//    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
//        let parent = item as! NodeProtocol
//        return parent.subnode(at: index)
//    }
//}
//extension OutlineViewController {
//}
