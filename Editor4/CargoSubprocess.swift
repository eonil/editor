//
//  CargoSubprocess.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation.NSFileManager

enum CargoSubprocessError: ErrorType {
    case BadLocation(NSURL)
    case DirectoryAlreadyExists(NSURL)
}
final class CargoSubprocess {
    let location: NSURL
    private let bash = BashSubprocess()
    init(location: NSURL) {
        self.location = location
    }
    /// Creates a new cargo template at the `location`.
    func new() throws {
        try bash.runCommand("cargo new")
    }
    /// Cleans a cargo project at the `location`.
    func clean() throws {
        try bash.runCommand("cargo clean")
    }
    /// Builds a cargo project at the `location`.
    func build() throws {
        try bash.runCommand("cargo build")
    }
    func cancel() {

    }
}