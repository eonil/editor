//
//  BashSubprocess.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

enum BashSubprocessEvent {
    /// - Parameter 0:
    ///     Printed line. This does not contain ending new-line character. Only line content.
    case StandardOutputDidPrintLine(String)
    /// - Parameter 0:
    ///     Printed line. This does not contain ending new-line character. Only line content.
    case StandardErrorDidPrintLine(String)
    /// Process finished gracefully.
    case DidExit(exitCode: Int32)
    /// Process halted forcefully.
    case DidTerminate
}
enum BashSubprocessError: ErrorType {
    case CannotEncodeCommandUsingUTF8(command: String)
}
final class BashSubprocess {
    var onEvent: (BashSubprocessEvent -> ())?
    private let subproc = SubprocessController()
    init() {
        subproc.onEvent = { [weak self] in
            switch $0 {
            case .DidReceiveStandardOutput(let data):
                self?.pushStandardOutputData(data)
            case .DidReceiveStandardError(let data):
                self?.pushStandardErrorData(data)
            case .DidTerminate:
                self?.emitIncompleteLinesAndClear()
                self?.onEvent?(.DidTerminate)
            }
        }
    }
    deinit {
        if subproc.state != .Terminated {
            // Force quitting
            subproc.kill()
        }
    }

    /// You need to send `exit` command to quit BASH gracefully.
    func runCommand(command: String) throws {
        guard let data = (command + "\n").dataUsingEncoding(NSUTF8StringEncoding) else {
            throw BashSubprocessError.CannotEncodeCommandUsingUTF8(command: command)
        }
        subproc.sendToStandardInput(data)
    }
    func kill() {
        subproc.kill()
    }

    ////////////////////////////////////////////////////////////////
    private var standardOutputDecoder = UTF8LineDecoder()
    private var standardErrorDecoder = UTF8LineDecoder()
    private func pushStandardOutputData(data: NSData) {
        standardOutputDecoder.push(data)
        while let line = standardOutputDecoder.popFirstLine() {
            onEvent?(.StandardOutputDidPrintLine(line))
        }
    }
    private func pushStandardErrorData(data: NSData) {
        standardErrorDecoder.push(data)
        while let line = standardErrorDecoder.popFirstLine() {
            onEvent?(.StandardErrorDidPrintLine(line))
        }
    }

    /// Ensures remaining text to be sent to event observer.
    /// Called on process finish.
    private func emitIncompleteLinesAndClear() {
        onEvent?(.StandardOutputDidPrintLine(standardOutputDecoder.newLineBuffer))
        onEvent?(.StandardErrorDidPrintLine(standardErrorDecoder.newLineBuffer))
        standardOutputDecoder = UTF8LineDecoder()
        standardErrorDecoder = UTF8LineDecoder()
    }
}






////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private struct UTF8LineDecoder {
    /// UTF-8 decoder needs to be state-ful.
    var decoder = UTF8()
    var lines = [String]()
    var newLineBuffer = ""
    mutating func push(data: NSData) {
        // TODO: We can remove this copying with a clever generator.
        guard let startPointer = data.bytes as? UnsafePointer<UInt8> else { fatalError() }
        let endPointer = startPointer.advancedBy(data.length)
        var iteratingPointer = startPointer
        // We need to keep a strong reference to data to make it alive until generator dies.
        var g = AnyGenerator<UInt8> { [data] in
            if iteratingPointer == endPointer { return nil }
            let unit = iteratingPointer.memory
            iteratingPointer += 1
            return unit
        }
        push(&g)
    }
    mutating func push<G: GeneratorType where G.Element == UInt8>(inout codeUnitGenerator: G) {
        var ok = true
        while ok {
            let result = decoder.decode(&codeUnitGenerator)
            switch result {
            case .Result(let unicodeScalar):
                newLineBuffer.append(unicodeScalar)
                if newLineBuffer.hasSuffix("\n") {
                    func getLastCharacterDeletedOf(string: String) -> String {
                        var copy = string
                        let endIndex = copy.endIndex
                        copy.removeRange((endIndex.predecessor())..<(endIndex))
                    }
                    lines.append(getLastCharacterDeletedOf(newLineBuffer))
                    newLineBuffer = ""
                }

            case .EmptyInput:
                ok = false

            case .Error:
                ok = false
            }
        }
    }
    /// Gets first line and removes it from the buffer if available.
    /// Otherwise returns `nil`.
    mutating func popFirstLine() -> String? {
        return lines.tryRemoveFirst()
    }
}















