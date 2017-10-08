////
////  Data.extension.swift
////  Editor
////
////  Created by Hoon H. on 2017/09/27.
////Copyright © 2017 Eonil. All rights reserved.
////
//
//import Foundation
//
//extension Data {
//    func write(to u: URL) -> Result<Void, AlienIssue> {
//        do {
//            try write(to: u, options: .atomic)
//            return .success(Void())
//        }
//        catch let err {
//            return .failure(AlienIssue(err))
//        }
//    }
//}
//
