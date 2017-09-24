//
//  LogFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

final class LogFeature: ServicesDependent {
    let signal = Relay<()>()
    let changes = Relay<Change>()
    private(set) var production = Production()

//    func appendInfo(_ message: String) {
//        let item = Item(
//            timestamp: Date(),
//            severity: .info,
//            message: message,
//            subsystem: "",
//            category: "")
//        append(item)
//    }
    func append(_ item: Item) {
        let c = production.items.endIndex
        production.items.append(item)
        changes.cast(.items(.insert(c..<c+1)))
        signal.cast()
    }
    func process(_ p: BuildFeature.Product) {
        let c = production.items.count
        p.reports.forEach({ production.items.append(.cargoReport($0)) })
        p.issues.forEach({ production.items.append(.cargoIssue($0)) })
        let c1 = production.items.count
        guard c1 > c else { return }
        changes.cast(.items(.insert(c..<c1)))
        signal.cast()
    }
    ///
    /// Clears any productions.
    /// This erases all log items.
    ///
    func clear() {

    }
}
extension LogFeature {
//    struct State {
//    }
    struct Production {
        var items = [Item]()
    }
    enum Item {
        case cargoReport(CargoProcess2.Report)
        case cargoIssue(CargoProcess2.Issue)
    }
//    struct Item {
//        var timestamp: Date
//        var severity: Severity
//        var message: String
//        var subsystem: String
//        var category: String
//    }
//    enum Severity {
//        /// Verbose messages for debugging.
//        case debug
//        /// Informative message.
//        case info
//        /// Recoverable issue.
//        case warning
//        /// Process-wide failure.
//        case error
//        /// System-wide failure.
//        case fault
//    }
    enum Change {
        case items(ArrayMutation<Item>)
    }
}
