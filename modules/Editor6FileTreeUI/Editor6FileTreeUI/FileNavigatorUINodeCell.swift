//
//  FileNavigatorUINodeCell.swift
//  Editor6FileTreeUI
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox
import Editor6Common

final class FileNavigatorUINodeCell: NSTableCellView {
    private let icon = NSImageView()
    private let name = NSTextField()
    private var localCopy = FileNavigatorUINodeState?.none
    private var installer = ViewInstaller()

    func reload(_ newState: FileNavigatorUINodeState?) {
        localCopy = newState
        render()
    }
    private func render() {
        installer.installIfNeeded {
            // You must add these views AND set to properties to make it work.
            imageView = icon
            textField = name
            addSubview(icon)
            addSubview(name)
            name.isBordered = false
            name.backgroundColor = NSColor.clear
        }
        textField?.stringValue = localCopy?.name ?? ""
    }
    override func layout() {
        super.layout()
        render()
    }
}
