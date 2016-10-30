//
//  LineReader.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/18.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

struct LineReader {
    private var decodingState = UTF8()
    private var incompleteBytes = Data()
    private(set) var decodedString = ""
    /// - Parameter onLine:
    ///     - Parameter $0:
    ///         Excludes ending `\n` character.
    mutating func push(data: Data, onLine: (String) -> ()) {
        let backup = decodingState
        var byteIter = data.makeIterator()
        var canContinue = true
        while canContinue {
            let r = decodingState.decode(&byteIter)
            switch r {
            case .emptyInput:
                // Clean finish.
                canContinue = false
                break
            case .error:
                // Needs more byte to complete.
                incompleteBytes.append(data)
                // Rollback original decoder state.
                decodingState = backup
                // Suspend.
                canContinue = false
            case .scalarValue(let codePoint):
                // Clean continue.
                // Append to line.
                decodedString.unicodeScalars.append(codePoint)
                if decodedString.characters.last == "\n" {
                    let line = String(decodedString.characters.dropLast())
                    onLine(line)
                    decodedString = ""
                }
            }
        }
    }
    /// - Returns:
    ///     Produced lines without ending `\n` characters.
    mutating func push(data: Data) -> [String] {
        var lines = [String]()
        push(data: data) { line in
            lines.append(line)
        }
        return lines
    }
}
