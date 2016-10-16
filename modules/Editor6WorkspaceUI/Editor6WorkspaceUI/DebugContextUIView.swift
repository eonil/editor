////
////  DebugContextUIView.swift
////  Editor6WorkspaceUI
////
////  Created by Hoon H. on 2016/10/16.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import ManualView
//
//final class DebugContextUIView: ManualView, NSOutlineViewDataSource, NSOutlineViewDelegate {
//    private let scroll = NSScrollView()
//    private let outline = NSOutlineView()
//    private var localState = DebugContextUIState()
//
//    func reload(_ newState: DebugContextUIState) {
//        localState = newState
//        outline.reloadData()
//    }
//
//    override func manual_installSubviews() {
//        super.manual_installSubviews()
//        addSubview(scroll)
//        scroll.documentView = outline
//        outline.dataSource = self
//        outline.delegate = self
//    }
//    override func manual_layoutSubviews() {
//        super.manual_layoutSubviews()
//    }
//}
