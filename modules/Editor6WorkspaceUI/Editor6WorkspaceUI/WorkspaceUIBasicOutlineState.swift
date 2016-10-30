//
//  Editor6CommonOutlineController.swift
//  Editor6WorkspaceUI
//
//  Created by Hoon H. on 2016/10/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox
import Editor6Common

public struct WorkspaceUIBasicOutlineState {
    public typealias Tree = Tree1<WorkspaceUIBasicOutlineNodeID, WorkspaceUIBasicOutlineNodeState>
    /// Allows multiple trees.
    public var tree = Tree(state: WorkspaceUIBasicOutlineNodeState())
    public var showsRootNode = true
    public var showsNodeIcons = true
    public var showsNodeLabels = true
    public init() {}
}

public struct WorkspaceUIBasicOutlineNodeID: Tree1NodeKey {
    private let oid = ObjectAddressID()
    public init() {}
    public var hashValue: Int {
        return oid.hashValue
    }
    public static func == (_ a: WorkspaceUIBasicOutlineNodeID, _ b: WorkspaceUIBasicOutlineNodeID) -> Bool {
        return a.oid == b.oid
    }
    public static func < (_ a: WorkspaceUIBasicOutlineNodeID, _ b: WorkspaceUIBasicOutlineNodeID) -> Bool {
        return a.oid < b.oid
    }
}

public struct WorkspaceUIBasicOutlineNodeState {
    public var isExpandable = true
//    public var isExpanded = false
    public var icon = NSImage?.none
    public var label = String?.none
    public init() {}
}
