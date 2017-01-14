//
//  PcoReport.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

enum PcoReport {
    case unclosedChannelOnDeinit(AnyObject)

    static var delegate: (PcoReport) -> () = handlePcoReportDefault
    static func dispatch(_ r: PcoReport) {
        delegate(r)
    }
}

private func handlePcoReportDefault(_ r: PcoReport) {
    switch r {
    case .unclosedChannelOnDeinit(let ch):
        fatalError("Unclosed channel discovered: \(ch)")
    }
}
