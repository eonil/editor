//
//  DriverFeatures.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

final class DriverFeatures: ServiceDependent {
    func fixWorkspaceDirectoryURL(_ u: URL) -> URL {
        if u.pathExtension == "" {
            return u.appendingPathExtension("edws")
        }
        return u
    }
    func makeWorkspaceDirectiry(at u: URL) {
        try! services.file.createDirectory(at: u, withIntermediateDirectories: true, attributes: nil)
        let ps = CargoExecution.Parameters(
            location: u,
            command: .initialize)
        services.cargo.queue(ps)
    }

}
