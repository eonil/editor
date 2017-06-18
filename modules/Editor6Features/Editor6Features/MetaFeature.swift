//
//  MetaFeature.swift
//  Editor6Features
//
//  Created by Hoon H. on 2017/06/12.
//  Copyright © 2017 Eonil. All rights reserved.
//

public final class MetaFeature {
    public private(set) var state = State()
//    public func process(_ command: Command) {
//        switch command {
//        case .relocate(let u):
//            state.location = u
//        }
//    }
    public func setLocation(_ newLocation: URL?) {
        state.location = newLocation
    }
}
public extension MetaFeature {
    public struct State {
        public var location: URL?
    }
//    public enum Command {
//        case relocate(URL)
//    }
}
