//
//  WorkspaceServices.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

final class WorkspaceServices {
    let file = FileManager()
    let cargo = CargoService()
    let rustLanguage = RustLanguageService()
    let rustMIRInterpreter = RustMIRInterpreterService()
    let lldb = LLDBService()

    init() {
    }
    deinit {
    }
}
