////
////  TaskController.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/10/17.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import Flow
//
//enum SubprocessControllerAction {
//    case standardOutput(Data)
//    case standardError(Data)
//    case error(SubprocessControllerError)
//}
//enum SubprocessControllerError: Error {
//    case posix(errno: Int32)
//    case invalidaFileDescriptor
//}
//enum SubprocessControllerReadingResult {
//    case eof
//    case data(Data)
//}
//private let BUFFER_SIZE = 1024 * 4
//
//final class SubprocessController {
//    var delegate: ((_ sender: SubprocessController, _ action: SubprocessControllerAction) -> ())?
//
//    private let subproc = Process()
//    private let stdinPipe = Pipe()
//    private let stdoutPipe = Pipe()
//    private let stderrPipe = Pipe()
//    private var stdoutReader = Reader()
//    private var stderrReader = Reader()
//    init(url: URL, arguments: [String]) {
//        subproc.standardInput = stdinPipe
//        subproc.standardOutput = stdoutPipe
//        subproc.standardError = stderrPipe
//        subproc.launchPath = url.path
//        subproc.arguments = arguments
//    }
//    func writeToStdin(data: Data) {
//        stdinPipe.fileHandleForWriting.write(data)
//    }
//    /// Returns `nil` at EOF.
//    func readFromStdout() throws -> Data? {
//        return try stdoutReader.read(from: stdoutPipe.fileHandleForReading.fileDescriptor)
//    }
//    /// Returns `nil` at EOF.
//    func readFromStderr() throws -> Data? {
//        return try stderrReader.read(from: stderrPipe.fileHandleForReading.fileDescriptor)
//    }
//
//    func launch() {
//        subproc.launch()
//    }
//    func terminate() {
//        subproc.terminate()
//        subproc.waitUntilExit()
//    }
////    func kill() {
////        fatalError()
////    }
//}
//
//fileprivate struct Writer {}
//
//fileprivate struct Reader {
//    private var readBuffer = Data(count: BUFFER_SIZE)
//    init() {}
//    func isValid(fileDescriptor: Int32) -> Bool {
//        let r = Darwin.fcntl(fileDescriptor, Darwin.F_GETFL)
//        let isBadFile = r == -1 && errno == Darwin.EBADF
//        return isBadFile == false
//    }
//    /// Returns whether the file descriptor has available data.
//    ///
//    /// Throws an error if file is not valid and open.
//    /// - Returns:
//    ///     `false` if no data is available yet.
//    ///     `true` if some data is arrived.
//    /// - Note:
//    ///     You cannot know whether the file is at EOF or not
//    ///     with this method.
//    ///
//    func isDataAvailable(on fileDescriptor: Int32) throws -> Bool {
//        guard isValid(fileDescriptor: fileDescriptor) else { throw SubprocessControllerError.invalidaFileDescriptor }
//        let POLLIN = Int16(Darwin.POLLIN)
//        var fd = pollfd(fd: fileDescriptor,
//                        events: POLLIN,
//                        revents: 0)
//        let r = Darwin.poll(&fd, 1, 0)
//        switch r {
//        case -1:
//            let e = errno
//            throw SubprocessControllerError.posix(errno: e)
//        case 0:
//            // Timeout.
//            return false
//        default:
//            precondition(r == 1)
//            return fd.revents & POLLIN > 0
//        }
//    }
//    /// Gets currently available bytes from the file descriptor.
//    ///
//    /// - Returns:
//    ///     This method returns immediately.
//    ///     Non-zero length data if some data is available.
//    ///     Zero-length data if no data is available yet.
//    ///     `nil` at EOF.
//    ///
//    mutating func read(from fileDescriptor: Int32) throws -> Data? {
//        let fd = fileDescriptor
//        guard try isDataAvailable(on: fileDescriptor) else { return Data() }
//        let cap = readBuffer.count
//        enum ReadingResult {
//            case read(Int)
//            case eof
//        }
//        let readResult = try readBuffer.withUnsafeMutableBytes { (ptr: UnsafeMutablePointer<UInt8>) throws -> ReadingResult in
//            let n = Darwin.read(fd, ptr, cap)
//            switch n {
//            case -1:
//                let e = Darwin.errno
//                throw SubprocessControllerError.posix(errno: e)
//            case 0:
//                return .eof
//            default:
//                precondition(n > 0)
//                return .read(n)
//            }
//        }
//        switch readResult {
//        case .eof:
//            return nil
//        case .read(let n):
//            let subdata = readBuffer.subdata(in: 0..<n)
//            return subdata
//        }
//    }
//}
