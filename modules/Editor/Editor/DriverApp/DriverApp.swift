//
//  DriverApp.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

///
/// Bootstrap and manage overall operations.
///
final class DriverApp {
    private let features = DriverFeatures()
    private let shell = DriverShell()
    init() {
        shell.features = features
    }
    deinit {
        shell.features = nil
    }
}
