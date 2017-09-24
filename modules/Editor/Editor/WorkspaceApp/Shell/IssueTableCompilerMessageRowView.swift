////
////  IssueTableCompilerMessageRowView.swift
////  Editor
////
////  Created by Hoon H. on 2017/09/24.
////Copyright © 2017 Eonil. All rights reserved.
////
//
//import AppKit
//
//final class IssueTableRowView: NSTableRowView {
//    override var isSelected: Bool {
//        didSet {
//            for i in 0..<numberOfColumns {
//                let v = view(atColumn: i)
//                guard let v1 = v as? IssueTableItemCellView else { continue }
//                v1.messageLabel?.textColor = isSelected ? messageSelectedTextColor : messageRegularTextColor
//                v1.locationLabel?.textColor = isSelected ? locationSelectedTextColor : locationRegularTextColor
//            }
//        }
//    }
//}
//
//private let messageRegularTextColor = NSColor.textColor
//private let messageSelectedTextColor = NSColor.selectedTextColor
//
//private let locationRegularTextColor = NSColor.textColor.weaken()
//private let locationSelectedTextColor = NSColor.selectedTextColor.weaken()
//
//
