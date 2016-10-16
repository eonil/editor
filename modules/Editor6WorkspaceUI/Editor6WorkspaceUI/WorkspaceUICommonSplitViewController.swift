//
//  WorkspaceUICommonSplitViewController.swift
//  Editor6WorkspaceUI
//
//  Created by Hoon H. on 2016/10/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox
import ManualView

struct WorkspaceUICommonSplitViewControllerSidePane {
    var viewController: NSViewController
    var currentSize: CGFloat
    var minSize: CGFloat?
//    var maxSize = CGFloat?.none
}
struct WorkspaceUICommonSplitViewControllerState {
    var isVertical = true
    var centerPaneViewController = NSViewController?.none
    var sidePanes = (WorkspaceUICommonSplitViewControllerSidePane?.none, WorkspaceUICommonSplitViewControllerSidePane?.none)
}

/// Only panes at both side can be collapsed.
final class WorkspaceUICommonSplitViewController: NSViewController, NSSplitViewDelegate {
    private let split = NSSplitView()
    private let containers = (ManualView(), ManualView(), ManualView())
    private var installer = ViewInstaller()
    private var localState = WorkspaceUICommonSplitViewControllerState()

    var state: WorkspaceUICommonSplitViewControllerState {
        get {
            return localState
        }
        set {
            reload(newState: newValue, oldState: localState)
        }
    }
    private func reload(newState: WorkspaceUICommonSplitViewControllerState, oldState: WorkspaceUICommonSplitViewControllerState) {
        localState = newState
        split.isVertical = newState.isVertical
        oldState.sidePanes.0?.viewController.removeFromParentViewController()
        oldState.sidePanes.0?.viewController.view.removeFromSuperview()
        oldState.centerPaneViewController?.removeFromParentViewController()
        oldState.centerPaneViewController?.view.removeFromSuperview()
        oldState.sidePanes.1?.viewController.removeFromParentViewController()
        oldState.sidePanes.1?.viewController.view.removeFromSuperview()

        containers.0.removeFromSuperview()
        containers.1.removeFromSuperview()
        containers.2.removeFromSuperview()

        if let vc = newState.sidePanes.0?.viewController {
            split.addArrangedSubview(containers.0)
            containers.0.addSubview(vc.view)
            addChildViewController(vc)
        }
        if let vc = newState.centerPaneViewController {
            split.addArrangedSubview(containers.1)
            containers.1.addSubview(vc.view)
            addChildViewController(vc)
        }
        if let vc = newState.sidePanes.1?.viewController {
            split.addArrangedSubview(containers.2)
            containers.2.addSubview(vc.view)
            addChildViewController(vc)
        }
        split.adjustSubviews()
    }
    private func applyMinSizes() {
        localState.sidePanes.0?.currentSize.maximize(localState.sidePanes.0?.minSize ?? 0)
        localState.sidePanes.1?.currentSize.maximize(localState.sidePanes.1?.minSize ?? 0)
    }
    private func getTotalDividerVolume() -> CGFloat {
        return split.dividerThickness * 2
    }
    private func getCurrentContainerSizesForCurrentSplitAxis() -> (CGFloat, CGFloat, CGFloat) {
        if split.isVertical {
            return (containers.0.frame.width,
                    containers.1.frame.width,
                    containers.2.frame.width)
        }
        else {
            return (containers.0.frame.height,
                    containers.1.frame.height,
                    containers.2.frame.height)
        }
    }

    override func loadView() {
        view = NSView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(split)
        split.arrangesAllSubviews = false
        split.isVertical = true
        split.dividerStyle = .thin
        split.delegate = self
        split.addArrangedSubview(containers.0)
        split.addArrangedSubview(containers.1)
        split.addArrangedSubview(containers.2)
    }
    override func viewDidLayout() {
        super.viewDidLayout()
        split.frame = view.bounds
    }

    func splitView(_ splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        return containers.0 === subview
            || containers.2 === subview
    }
    func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        if dividerIndex == 0 {
            return localState.sidePanes.0?.minSize ?? proposedMinimumPosition
        }
        return proposedMinimumPosition
    }
    func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        let maxDividerIndex = split.arrangedSubviews.count - 2
        if dividerIndex == maxDividerIndex {
            if let a = localState.sidePanes.1?.minSize {
                if split.isVertical {
                    return splitView.bounds.maxX - a
                }
                else {
                    return splitView.bounds.maxY - a
                }
            }
            return proposedMaximumPosition
        }
        return proposedMaximumPosition
    }
    func splitView(_ splitView: NSSplitView, resizeSubviewsWithOldSize oldSize: NSSize) {
        guard oldSize != splitView.bounds.size else { return }
        func getSidePaneCurrentSizes() -> (CGFloat, CGFloat) {
            let a = localState.sidePanes.0?.currentSize ?? 0
            let b = localState.sidePanes.1?.currentSize ?? 0
            return (a, b)
        }
        let sidePaneSizes = getSidePaneCurrentSizes()
        if split.isVertical {
            let box = split.bounds.toBox().toSilentBox()
            let (a, b, c) = box.splitInX(sidePaneSizes.0, 100%, sidePaneSizes.1)
            containers.0.frame = a.toCGRect()
            containers.1.frame = b.toCGRect()
            containers.2.frame = c.toCGRect()
        }
        else {
            let box = split.bounds.toBox().toSilentBox()
            let (a, b, c) = box.splitInY(sidePaneSizes.0, 100%, sidePaneSizes.1)
            containers.0.frame = a.toCGRect()
            containers.1.frame = b.toCGRect()
            containers.2.frame = c.toCGRect()
        }
    }
    func splitViewDidResizeSubviews(_ notification: Notification) {
        let containerSizes = getCurrentContainerSizesForCurrentSplitAxis()
        localState.sidePanes.0?.currentSize = containerSizes.0
        localState.sidePanes.1?.currentSize = containerSizes.2
        applyMinSizes()
        localState.sidePanes.0?.viewController.view.frame = containers.0.bounds
        localState.centerPaneViewController?.view.frame = containers.1.bounds
        localState.sidePanes.1?.viewController.view.frame = containers.2.bounds
    }
}
