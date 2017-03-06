//
//  NavigatorView.swift
//  Editor6WorkspaceUI
//
//  Created by Hoon H. on 2017/03/05.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilToolbox
import ManualView
import Editor6Common
import Editor6FileTreeUI

final class NavigatorView: NSView {
    private let headSegmentedControl = NSSegmentedControl()
    private let dividerView = NSBox()
    private let bodyContainerView = NSView()
    private let filePaneView = FileNavigatorUIView()
    private let issuePaneView = WorkspaceUIBasicOutlineView()
    private let debugPaneView = ManualView()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        install()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        install()
    }
    func reload(_ newState: WorkspaceUIState) {
        filePaneView.reload(state: newState.navigator.files)
        issuePaneView.reload(newState.navigator.issues)
    }

    private func install() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.controlHighlightColor.cgColor
        addSubview(headSegmentedControl)
        addSubview(dividerView)
        addSubview(bodyContainerView)
        headSegmentedControl.translatesAutoresizingMaskIntoConstraints = true
        headSegmentedControl.controlSize = .small
        headSegmentedControl.segmentStyle = .smallSquare
        headSegmentedControl.font = .systemFont(ofSize: NSFont.systemFontSize(for: .small))
        headSegmentedControl.segmentCount = 3
        headSegmentedControl.setLabel("File", forSegment: 0)
        headSegmentedControl.setLabel("Issue", forSegment: 1)
        headSegmentedControl.setLabel("Debug", forSegment: 2)
        dividerView.boxType = .separator
        bodyContainerView.addSubview(filePaneView)
        bodyContainerView.addSubview(issuePaneView)
        bodyContainerView.addSubview(debugPaneView)

        headSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        headSegmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor).activateAlmostRequired()
        headSegmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: -1).activateAlmostRequired()
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.leadingAnchor.constraint(equalTo: leadingAnchor).activateAlmostRequired()
        dividerView.trailingAnchor.constraint(equalTo: trailingAnchor).activateAlmostRequired()
        dividerView.topAnchor.constraint(equalTo: headSegmentedControl.bottomAnchor, constant: -1).activateAlmostRequired()
        dividerView.heightAnchor.constraint(equalToConstant: 1).activateAlmostRequired()
        bodyContainerView.translatesAutoresizingMaskIntoConstraints = false
        bodyContainerView.topAnchor.constraint(equalTo: dividerView.bottomAnchor).activateAlmostRequired()
        bodyContainerView.bottomAnchor.constraint(equalTo: bottomAnchor).activateAlmostRequired()
        bodyContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).activateAlmostRequired()
        bodyContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).activateAlmostRequired()

        headSegmentedControl.target = self
        headSegmentedControl.action = #selector(EDITOR6_processHeadSegmentAction(_:))
    }
    @objc
    private func EDITOR6_processHeadSegmentAction(_: NSObject) {
        let selidx = headSegmentedControl.selectedSegment
        let vs = [filePaneView, issuePaneView, debugPaneView]
        for i in 0..<vs.count {
            vs[i].isHidden = (i != selidx)
        }
    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        needsLayout = true
    }
    override func layout() {
        super.layout()
        filePaneView.frame = bodyContainerView.bounds
        issuePaneView.frame = bodyContainerView.bounds
        debugPaneView.frame = bodyContainerView.bounds
    }

//    func reload(_ newState: WorkspaceUIState) {
//        filePaneView.reload(state: newState.navigator.files)
//        issuePaneView.reload(newState.navigator.issues)
//    }
//
//    @available(*, unavailable)
//    override func manual_installSubviews() {
//        super.manual_installSubviews()
//        addSubview(headSegmentedControl)
//        addSubview(dividerView)
//        addSubview(bodyContainerView)
//        headSegmentedControl.translatesAutoresizingMaskIntoConstraints = true
//        headSegmentedControl.controlSize = .small
//        headSegmentedControl.segmentStyle = .smallSquare
//        headSegmentedControl.font = .systemFont(ofSize: NSFont.systemFontSize(for: .small))
//        headSegmentedControl.segmentCount = 3
//        headSegmentedControl.setLabel("File", forSegment: 0)
//        headSegmentedControl.setLabel("Issue", forSegment: 1)
//        headSegmentedControl.setLabel("Debug", forSegment: 2)
//        dividerView.boxType = .separator
//        bodyContainerView.addSubview(filePaneView)
//        bodyContainerView.addSubview(issuePaneView)
//        bodyContainerView.addSubview(debugPaneView)
//    }
//    @available(*, unavailable)
//    override func manual_layoutSubviews() {
//        super.manual_layoutSubviews()
//        let headSize = headSegmentedControl.sizeThatFits(.zero)
//        let box = bounds.toBox().toSilentBox()
//        let (bodyBox, divBox, headBox) = box.splitInY(100%, 0, headSize.height)
//        headSegmentedControl.frame = headBox.resizedXTo(headSize.width).toCGRect()
//        dividerView.frame = divBox.toCGRect()
//        bodyContainerView.frame = bodyBox.toCGRect()
//
//        let paneBox = bodyContainerView.bounds.toBox().toSilentBox()
//        filePaneView.frame = paneBox.toCGRect()
//        issuePaneView.frame = paneBox.toCGRect()
//        debugPaneView.frame = paneBox.toCGRect()
//    }
}
