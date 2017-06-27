//
//  LineBuilder.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/25.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

struct LineBuilder {
    private var utf8 = UTF8()
    ///
    /// Buffered bytes.
    /// This may contain some incomplete Unicode points.
    ///
    private(set) var bytes = Data()
    ///
    /// This contains only properly decoded Unicode scalar values.
    ///
    private(set) var construction = ""

    ///
    /// Push byte array and returns discovered line.
    ///
    /// Each input will be accumulated to build
    /// complete line later.
    ///
    /// This operation is not transactional. This object becomes
    /// an error state on any error, and the error stays forever.
    ///
    /// - Returns:
    ///     Array of strings representing lines.
    ///     An empty array if no line has been found yet.
    ///     All lines include ending new-line characters.
    ///
    /// - Note:
    ///     If input does not end with a new-line 
    ///     character, last line won't be returned.
    ///     Do one of these to take it out.
    ///     - Push a new-line character to get it.
    ///     - Copy `construction` property value.
    ///
    mutating func process(_ d: Data) -> Result<[String], Issue> {
        bytes.append(d)
        var lines = [String]()
        var cont = true
        while cont {
            var i = 0
            var g = AnyIterator { [bytes] () -> UTF8.CodeUnit? in
                let r: UTF8.CodeUnit?
                if i == bytes.count { r = nil }
                else { r = bytes[i] }
                i += 1
                return r
            }
            switch utf8.decode(&g) {
            case .error:
                return .failure(.badUTF8EncodedData)
            case .emptyInput:
                // Ended properly.
                cont = false
            case .scalarValue(let s):
                bytes.removeSubrange(0..<i)
                construction.unicodeScalars.append(s)
                if let ch = construction.characters.last {
                    if ch == "\n" {
                        let line = construction
                        construction = ""
                        lines.append(line)
                        continue
                    }
                }
                continue
            }
        }
        return .success(lines)
    }
}
extension LineBuilder {
    enum Issue {
        ///
        /// Input data does not build a proper UTF-8 byte sequence.
        ///
        case badUTF8EncodedData
    }
}








