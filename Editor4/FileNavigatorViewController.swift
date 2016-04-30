//
//  FileNavigatorViewController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/20.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

final class FileNavigatorViewController: NSViewController, DriverAccessible {
        private var proxyMapping = [FileNodeID: FileNodeUIProxy]()
        private func render() {
                guard let keyWorkspaceID = state.keyWorkspaceID else { return }
                guard let workspaceState = state.workspaces[keyWorkspaceID] else { return }
                proxyMapping.syncFrom(workspaceState.fileNavigator.nodes) { k, v in
                        let p = FileNodeUIProxy(k)
                        p.subnodeIDs = v.subnodes
                        return p
                }
        }
}
extension FileNavigatorViewController: NSOutlineViewDataSource {
        func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
            MARK_unimplemented()
            return 0
//                guard let item = item as? FileNodeUIProxy else {
//                        return
//                }
        }
}

private final class FileNodeUIProxy {
        let ID: FileNodeID
        var subnodeIDs: [FileNodeID] = []
        init(_ ID: FileNodeID) {
                self.ID = ID
        }
}






















