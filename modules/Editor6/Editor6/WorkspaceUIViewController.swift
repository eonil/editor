////
////  WorkspaceUIViewController.swift
////  Editor6
////
////  Created by Hoon H. on 2016/10/09.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//import EonilToolbox
//import Editor6Common
//
//final class WorkspaceUIViewController: Editor6CommonViewController {
//    private let outerSplit = NSSplitViewController()
//    private let fileNavigator = FileNavigatorUIViewController()
//    private let innerSplit = NSSplitViewController()
//    private let inspector = InspectorUIViewController()
//    private var installer = ViewInstaller()
//
//    func reload(state: WorkspaceUIState) {
//        
//    
//
//    private func render() {
//        installer.installIfNeeded {
//            outerSplit.view.wantsLayer = true
//            view.addSubview(outerSplit.view)
//            addChildViewController(outerSplit)
//            outerSplit.splitViewItems = [
//                NSSplitViewItem(sidebarWithViewController: fileNavigator),
//                NSSplitViewItem(contentListWithViewController: innerSplit),
//                NSSplitViewItem(sidebarWithViewController: inspector),
//            ]
////            outerSplit.splitViewItems[0].minimumThickness = 100
////            outerSplit.splitViewItems[0].isCollapsed = false
//        }
//        outerSplit.view.frame = view.bounds
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        render()
//    }
//    override func viewDidLayout() {
//        super.viewDidLayout()
//        render()
//    }
//}
