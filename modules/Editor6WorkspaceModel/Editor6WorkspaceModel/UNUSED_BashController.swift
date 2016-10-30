////
////  BashController.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/10/18.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//
//struct BashState {
//    var lines = [BashLine]()
//}
//enum BashLine {
//    case input(String)
//    case output(String)
//    case error(String)
//}
//final class BashController {
//    private let subproc = SubprocessController(url: URL(fileURLWithPath: "/bin/bash"), arguments: ["--posix", "--login", "-s"])
//    private var outputLineReader = LineReader()
//    private var errorLineReader = LineReader()
//    private var localState = BashState()
//    init() {
//        subproc.launch()
//    }
//    deinit {
//        subproc.terminate()
//    }
//    /// - Parameter line:
//    ///     Excludes ending `\n` character.
//    func writeInputLines(lines: [String]) {
//        let s = lines.map({ $0 + "\n" }).joined()
//        let d = s.data(using: .utf8) ?? Data()
//        subproc.writeToStdin(data: d)
//        let bashLines = lines.map(BashLine.input)
//        localState.lines.append(contentsOf: bashLines)
//    }
//    /// - Returns:
//    ///     Excludes ending `\n` character.
//    func readOutputLines() throws -> [String]? {
//        if let data = try subproc.readFromStdout() {
//            let lines = outputLineReader.push(data: data)
//            let bashLines = lines.map(BashLine.output)
//            localState.lines.append(contentsOf: bashLines)
//            return lines
//        }
//        return nil
//    }
//    /// - Returns:
//    ///     Excludes ending `\n` character.
//    func readErrorLines() throws -> [String]? {
//        if let data = try subproc.readFromStderr() {
//            let lines = errorLineReader.push(data: data)
//            let bashLines = lines.map(BashLine.error)
//            localState.lines.append(contentsOf: bashLines)
//            return lines
//        }
//        return nil
//    }
//}
