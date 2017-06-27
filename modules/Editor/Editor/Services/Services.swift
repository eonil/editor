//
//  Services.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/24.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

///
/// Models external world and provides I/O to there.
///
final class Services {
    fileprivate static let shared = Services()

    let fileSystem = FileManager()
    let cargo = CargoService2()
    let rustLanguage = RustLanguageService()
    let rustMIRInterpreter = RustMIRInterpreterService()
    let lldb = LLDBService()

    private init() {
    }
}

class ServiceDependent {
    var services: Services {
        return Services.shared
    }
}
