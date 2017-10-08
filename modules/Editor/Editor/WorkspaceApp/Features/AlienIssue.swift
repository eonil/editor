////
////  AlienIssue.swift
////  Editor
////
////  Created by Hoon H. on 2017/10/08.
////Copyright © 2017 Eonil. All rights reserved.
////
//
//import Foundation
//
//struct AlienIssue {
//    var error: Error
//    var domain: Domain
//
//    init(_ err: Error) {
//        self.error = err
//        let domainCode = (err as NSError).domain
//        switch domainCode {
//        default:    domain = .unknown(code: doaminCode)
//        }
//    }
//
//    enum Domain {
//        case fileSystem
//        case unknown(code: String)
//    }
//}
//
