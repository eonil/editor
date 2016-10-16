//
//  WorkspaceUINavigatorViewController.swift
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

final class WorkspaceUINavigatorViewController: Editor6CommonViewController {
    private let stack = ManualStackView()
    private let tabBar = WorkspaceUINavigatorTabBarView()
    private let divider = ManualView()
    private let container = ManualView()
    private let fileTree = FileNavigatorUIView()
    private let issueList = Editor6CommonOutlineUIView()
    private let debugTree = ManualView()

    func reload(_ newState: WorkspaceUIState) {
        fileTree.reload(state: newState.navigator.files)
        issueList.reload(newState.navigator.issues)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stack)
        stack.reload(ManualStackViewState(axis: .y, segments: [
            ManualStackViewSegment(filling: container),
            ManualStackViewSegment(view: divider, holding: 1),
            ManualStackViewSegment(fitting: tabBar),
            ]))
        divider.layer = CALayer(backgroundColor: NSColor.gridColor.cgColor)
//        container.addSubview(fileTree)
        container.addSubview(issueList)
//        container.addSubview(debugTree)
        view.needsLayout = true
    }
    override func viewDidLayout() {
        stack.frame = view.bounds
        stack.manual_layoutIfNeeded()
        fileTree.frame = container.bounds
        issueList.frame = container.bounds
        debugTree.frame = container.bounds
    }
}
