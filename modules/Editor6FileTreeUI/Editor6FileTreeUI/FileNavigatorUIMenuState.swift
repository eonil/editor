//
//  FileNavigatorUIMenuState.swift
//  Editor6FileTreeUI
//
//  Created by Hoon H. on 2017/03/09.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

public struct FileNavigatorUIMenuItemID: OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
    public static let showInFinder     =   FileNavigatorUIMenuItemID(rawValue: 1 << 0)
    public static let newFile          =   FileNavigatorUIMenuItemID(rawValue: 1 << 1)
    public static let newFolder        =   FileNavigatorUIMenuItemID(rawValue: 1 << 2)
    public static let rename           =   FileNavigatorUIMenuItemID(rawValue: 1 << 3)
    public static let groupSelection   =   FileNavigatorUIMenuItemID(rawValue: 1 << 4)
    public static let delete           =   FileNavigatorUIMenuItemID(rawValue: 1 << 5)
}
