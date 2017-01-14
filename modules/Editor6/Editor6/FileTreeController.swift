//
//  FileTreeController.swift
//  Editor6
//
//  Created by Hoon H. on 2016/12/27.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import EonilGCDActor
import Editor6WorkspaceUI

final class FileTreeController {
//    private var addNewFileProcess: AddNewFileProcess?
    func addNewFile() {
    }
    func process(_ id: FileTreeProcessID) {
        switch id {
            case .addNewFile:
            break
        }
    }
}

enum FileTreeProcessID {
    case addNewFile
}

private enum AddNewFileProcess {
    enum InputSignal {
        case pickNewFileType(String)
        case submitNewFileName(String)
    }
    enum OutputSignal {
        case beginNewFileTypePickingSheet
        case endNewFileTypePickingSheet
        case selectNewFileNodeInTree
        case startEditingName(String)
        case endEditingName
    }
    enum ErrorSignal: Error {
        case unexpectedInputSignal
    }
    static func spawn(input: GCDChannel<InputSignal>, output: GCDChannel<OutputSignal>, error: GCDChannel<ErrorSignal>) {
        GCDActor.spawn { (_ ss: GCDActorSelf) in
            output.send(.beginNewFileTypePickingSheet)
            let s1 = input.receive()
            guard case .pickNewFileType(let newFileType) = s1 else { return error.send(.unexpectedInputSignal) }
            output.send(.endNewFileTypePickingSheet)
            /// Create a new file actually.
            output.send(.startEditingName("")) // NOSHIP: Use actual proper name generated and created.
            guard case .submitNewFileName(let newFileName) = input.receive() else { return error.send(.unexpectedInputSignal) }
            output.send(.endEditingName)
        }
    }
}

