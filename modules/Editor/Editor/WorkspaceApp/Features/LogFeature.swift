//
//  LogFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

final class LogFeature: ServiceDependent {
    private(set) var state = State()
}
extension LogFeature {
    struct State {
        var messages = [String]()
    }
}
