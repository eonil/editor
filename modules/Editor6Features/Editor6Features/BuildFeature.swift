//
//  BuildFeature.swift
//  Editor6Features
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

import EonilSignet
import EonilToolbox
import Editor6Services

public final class BuildFeature {
    private let channelImpl = MutableChannel<State>(.init())

    weak var services: Services?  {
        didSet {
        }
    }

    init() {

    }
    deinit {

    }

    public var channel: Channel<State> {
        return channelImpl
    }
    public func process(_ s: Signal) {
        switch s {
        case .clean:
            channelImpl.mutateStateAtomically { state in
                state.mode = .running
            }
        case .build:
            channelImpl.mutateStateAtomically { state in
                state.mode = .running
            }
        case .halt:
            channelImpl.mutateStateAtomically { state in
                state.mode = .none
            }
        }
    }
}
public extension BuildFeature {
    public struct State {
        ///
        /// Build is done asynchronously in remote process.
        /// This is a sort of "invented" property.
        ///
        var mode = Mode.none
        var issues = [Issue]()
    }
    public enum Mode {
        case none
        case running
    }
    public struct Issue {
        public let id = ObjectAddressID()
        public let state: String
    }
    public enum Signal {
        case clean
        case build
        case halt
    }
}
