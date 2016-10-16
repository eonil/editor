////
////  WindowContentViewController.swift
////  Editor6WorkspaceUI
////
////  Created by Hoon H. on 2016/10/15.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//import Editor6Common
//
//final class WindowContentViewController: Editor6CommonViewController {
////    var documentViewController: NSViewController? {
////        didSet {
////            if let vc = oldValue {
////                vc.removeFromParentViewController()
////                vc.view.removeFromSuperview()
////            }
////            if let vc = documentViewController {
////                view.addSubview(vc.view)
////                addChildViewController(vc)
////            }
////            view.needsLayout = true
////        }
////    }
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        view.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
////        view.autoresizesSubviews = false
////        view.translatesAutoresizingMaskIntoConstraints = false
////        view.wantsLayer = true
////    }
////    override func viewDidLayout() {
////        super.viewDidLayout()
////        documentViewController?.view.frame = view.bounds
////    }
//}
