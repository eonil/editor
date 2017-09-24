//
//  ServiceProtocol.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/16.
//  Copyright © 2017 Eonil. All rights reserved.
//

///
/// A service provide a certain range of external I/O.
///
/// Everything out of memory is "external".
/// For example, platform features are also external,
/// and platform I/O should be considered as external
/// access.
///
/// State of a service is opaque basically as it's 
/// in remote space. But some services may have and
/// expose some local state to users. In that case,
/// please use `TransparentServiceProtocol`.
///
protocol OpaqueServiceProtocol {
    associatedtype Event
    associatedtype Command
    var event: Relay<Event> { get }
    func process(_: Command)
}

protocol TransparentServiceProtocol: OpaqueServiceProtocol {
    associatedtype State
    var state: State { get }
}
