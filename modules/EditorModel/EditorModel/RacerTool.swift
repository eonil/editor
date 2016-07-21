//
//  RacerTool.swift
//  EditorModel
//
//  Created by Hoon H. on 2016/01/01.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

final class RacerTool {

        private let shellTaskExecutionController = ShellTaskExecutionController()
        private func run() {
                shellTaskExecutionController.standardInput.writeUTF8String("export RUST_SRC_PATH=\"$HOME/Temp/rustc-1.5.0/src\"\n")
                shellTaskExecutionController.standardInput.writeUTF8String("exit\n")
        }
}