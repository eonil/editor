//
//  IssueTableItemCellView.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class IssueTableItemCellView: NSTableCellView {
    @IBOutlet weak var messageLabel: NSTextField?
    @IBOutlet weak var locationLabel: NSTextField?

    override var backgroundStyle: NSView.BackgroundStyle {
        didSet {
            switch backgroundStyle {
            case .dark:
                messageLabel?.textColor = NSColor.selectedTextColor
                locationLabel?.textColor = NSColor.selectedTextColor

            case .light:
                messageLabel?.textColor = NSColor.textColor
                locationLabel?.textColor = NSColor.textColor

            default:
                break
            }
        }
    }
}
