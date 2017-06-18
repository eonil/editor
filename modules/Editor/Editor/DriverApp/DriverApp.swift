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
    private let services = DriverServices()
    private let features = DriverFeatures()
    private let shell = DriverShell()
    init() {
        features.services = services
        shell.features = features
    }
    deinit {
        features.services = nil
        shell.features = nil
    }
}
