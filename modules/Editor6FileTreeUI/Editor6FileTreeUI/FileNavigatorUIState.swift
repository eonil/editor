//
//  FileNavigatorUITree.swift
//  Editor6FileTreeUI
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import EonilToolbox
import BTree

public struct FileNavigatorUIState {
    public var tree = FileNavigatorUITree()
    fileprivate(set) var selection = FileNavigatorUISelectionState()
    public init() {}
}

public typealias FileNavigatorUINode = (id: FileNavigatorUINodeID, state: FileNavigatorUINodeState)
public struct FileNavigatorUINodeID: Hashable, Comparable {
    fileprivate let oid = ObjectAddressID()
    public init() {
    }
    public var hashValue: Int {
        return oid.hashValue
    }
    public static func == (_ a: FileNavigatorUINodeID, _ b: FileNavigatorUINodeID) -> Bool {
        return a.oid == b.oid
    }
    public static func < (_ a: FileNavigatorUINodeID, _ b: FileNavigatorUINodeID) -> Bool {
        return a.oid < b.oid
    }
}

internal struct FileNavigatorUINodeLinkage {
//    var prent = FileNavigatorUINodeID?.none
    internal var children = [FileNavigatorUINodeID]()
}

public struct FileNavigatorUINodeState {
    public var icon = URL?.none
    public var name = String?.none
    public var type = FileNavigatorUINodeType.folder
    public var isExpanded = false
    public var availableMenuItemIDs = FileNavigatorUIMenuItemID([])

    public init() {}
}

public enum FileNavigatorUINodeType {
    case folder
    case document
}

public enum FileNavigatorUITreeError: Error {
    case badID
    case badIndex
}

private extension Array {
    func inserted(_ newElement: Element, at index: Int) -> Array {
        var copy = self
        copy.insert(newElement, at: index)
        return copy
    }
    func replaced(_ newElement: Element, at index: Int) -> Array  {
        var copy = self
        copy[index] = newElement
        return copy
    }
    func removed(at index: Int) -> Array {
        var copy = self
        copy.remove(at: index)
        return copy
    }
}
