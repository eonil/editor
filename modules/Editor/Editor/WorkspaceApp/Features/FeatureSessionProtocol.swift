////
////  reset.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/24.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
////protocol FeatureSessionProtocol {
////    init(_ services: WorkspaceServices)
////    unowned var services: WorkspaceServices { get }
////}
////func reset<S>(_ session: inout S?, _ services: inout WorkspaceServices?) where S: FeatureSessionProtocol {
////    guard session?.services !== services else { return }
////    guard let services = services else { return }
////    session = S(services)
////}
//
//import EonilSignet
//
//final class FeatureProxy {
//    let transaction = Relay<Transaction>()
//    private(set) var state = State()
//    func process(_ c: Command) {
//
//    }
//
//    struct State {}
//    enum Command {}
//    enum Transaction {}
//}
