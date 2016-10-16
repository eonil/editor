//
//  WorkspaceUIViewController.swift
//  Editor6WorkspaceUI
//
//  Created by Hoon H. on 2016/10/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox
import Editor6Common
import Editor6FileTreeUI
import ManualView

public final class WorkspaceUIViewController: Editor6CommonViewController, NSSplitViewDelegate {
    public var delegate: ((WorkspaceUIAction) -> ())?
    private let outerSplit = WorkspaceUICommonSplitViewController()
    private let innerSplit = WorkspaceUICommonSplitViewController()
    private let navigator = WorkspaceUINavigatorViewController()
    private let inspector = WorkspaceUIInspectorViewController()
    private let console = Editor6CommonViewController()
    private let document = Editor6CommonViewController()
    private var installer = ViewInstaller()

    public func reload(_ newState: WorkspaceUIState) {
        navigator.reload(newState)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.frame = CGRect(x: 0, y: 0, width: 1600 / 2, height: 900 / 2)
        view.addSubview(outerSplit.view)
        addChildViewController(outerSplit)
        typealias SidePane = WorkspaceUICommonSplitViewControllerSidePane
        typealias SplitState = WorkspaceUICommonSplitViewControllerState
        let leftPane = SidePane(viewController: navigator,
                                currentSize: 100,
                                minSize: 100)
        let rightPane = SidePane(viewController: inspector,
                                 currentSize: 100,
                                 minSize: 100)
//        let topPane = SidePane(viewController: Editor6CommonViewController(),
//                               currentSize: 100,
//                               minSize: 100)
        let bottomPane = SidePane(viewController: console,
                                  currentSize: 100,
                                  minSize: 100)
        outerSplit.state = SplitState(isVertical: true,
                                 centerPaneViewController: innerSplit,
                                 sidePanes: (leftPane, rightPane))
        innerSplit.state = SplitState(isVertical: false,
                                      centerPaneViewController: document,
                                      sidePanes: (nil, bottomPane))

//        navigator.view.layer = CALayer(backgroundColor: NSColor.red.cgColor)
//        document.view.layer = CALayer(backgroundColor: NSColor.green.cgColor)
//        inspector.view.layer = CALayer(backgroundColor: NSColor.blue.cgColor)
//        console.view.layer = CALayer(backgroundColor: NSColor.black.cgColor)
    }
    public override func viewDidLayout() {
        super.viewDidLayout()
        outerSplit.view.frame = view.bounds
    }
}

//public final class WorkspaceUIViewController: NSViewController, NSSplitViewDelegate {
//    private let split = NSSplitViewController()
//    private let navigator = WorkspaceUINavigatorViewController()
//    private let workbench = Editor6CommonViewController()
//    private let inspector = WorkspaceUIInspectorViewController()
//    private var installer = ViewInstaller()
//
//    public override func loadView() {
//        view = NSView(frame: CGRect(x: 0, y: 0, width: 400, height: 100))
//    }
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(split.view)
//        split.splitView.isVertical = true
//        split.addSplitViewItem(NSSplitViewItem(sidebarWithViewController: navigator))
//        split.addSplitViewItem(NSSplitViewItem(viewController: workbench))
//        split.addSplitViewItem(NSSplitViewItem(sidebarWithViewController: inspector))
//    }
//    public override func viewDidLayout() {
//        super.viewDidLayout()
//        split.view.frame = view.bounds
//    }
//}
