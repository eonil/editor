//
//  DriverFeatures.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

final class DriverFeatures {
    weak var services: DriverServices? {
        willSet { disconnectFromServices() }
        didSet { connectToServices() }
    }

    ///
    /// Idempotent.
    /// No-op if `services == nil`.
    ///
    private func connectToServices() {
        guard let services = services else { return }
    }

    ///
    /// Idempotent.
    /// No-op if `services == nil`.
    ///
    private func disconnectFromServices() {
        guard let services = services else { return }
    }
}
