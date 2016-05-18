//
//  SubprocessController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

enum SubprocessState {
    case NotLaunched
    case Running
    case Terminated(exitCode: Int32)

    var isNotLaunched: Bool {
        get {
            switch self {
            case .NotLaunched:  return true
            default:            return false
            }
        }
    }
    var exitCode: Int32? {
        get {
            switch self {
            case .Terminated(let exitCode): return exitCode
            default:                        return nil
            }
        }
    }
}
enum SubprocessEvent {
    case DidReceiveStandardOutput(NSData)
    case DidReceiveStandardError(NSData)
    case DidTerminate
}
enum SubprocessError: ErrorType {
    case AlreadyDidLaunch
}
final class SubprocessController {
    private(set) var state = SubprocessState.NotLaunched
    var onEvent: (SubprocessEvent->())?
    private let task = NSTask()
    private let standardInputPipe = NSPipe()
    private let standardOutputPipe = NSPipe()
    private let standardErrorPipe = NSPipe()
    private var sendingDataQueue = [NSData]() //< 64KB blocks.

    init() {
        standardOutputPipe.fileHandleForReading.readabilityHandler = { [weak self] h in
            let data = h.availableData
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                assertMainThread()
                self?.onEvent?(.DidReceiveStandardOutput(data))
            }
        }
        standardErrorPipe.fileHandleForReading.readabilityHandler = { [weak self] h in
            let data = h.availableData
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                assertMainThread()
                self?.onEvent?(.DidReceiveStandardError(data))
            }
        }
        task.terminationHandler = { [weak self] _ in
            guard let S = self else { return }
            S.state = .Terminated(exitCode: S.task.terminationStatus)
            S.onEvent?(.DidTerminate)
        }
    }
    func launchWithProgram(u: NSURL, arguments: [String]) throws {
        assert(state.isNotLaunched)
        guard state.isNotLaunched else { throw SubprocessError.AlreadyDidLaunch }
        task.standardInput = standardInputPipe
        task.standardOutput = standardOutputPipe
        task.standardError = standardErrorPipe
        task.launchPath = u.path
        task.arguments = arguments
        task.launch()
        state = .Running
    }

    /// Sends `SIGTERM` to notify remote process to quit gracefully as soon as possible.
    func terminate() {
        sendingDataQueue = []
        standardInputPipe.fileHandleForWriting.writeabilityHandler = nil
        task.terminate()
    }

    /// Sends `SIGKILL` to forces remote process to quit immediately.
    /// Remote process will be killed by kernel and cannot perform any cleanup.
    func kill() {
        sendingDataQueue = []
        standardInputPipe.fileHandleForWriting.writeabilityHandler = nil
        Darwin.kill(task.processIdentifier, SIGKILL)
    }

    

    ////////////////////////////////////////////////////////////////

    func sendToStandardInput(data: NSData) {
        sendingDataQueue.append(data)
        if standardInputPipe.fileHandleForWriting.writeabilityHandler == nil {
            runSending()
        }
    }
    private func runSending() {
        assertMainThread()
        guard sendingDataQueue.count > 0 else { return }
        guard standardInputPipe.fileHandleForWriting.writeabilityHandler == nil else { return }
        let container = Container()
        sendingDataQueue.forEach(container.ship)
        sendingDataQueue = []
        standardInputPipe.fileHandleForWriting.writeabilityHandler = { [weak self, container] h in
            if let availableData = container.payload.popFirst() {
                h.writeData(availableData)
            }
            else {
                guard container.done == false else { return }
                container.done = true
                dispatch_async(dispatch_get_main_queue()) { [weak self] in
                    assertMainThread()
                    self?.standardInputPipe.fileHandleForWriting.writeabilityHandler = nil
                    self?.runSending()
                }
            }
        }
    }
}

private final class Container {
    var payload = [NSData]()
    var done = false
    func ship(data: NSData) {
        let (head, tail) = data.splitHead(64 * 1024)
        payload.append(head)
        if tail.length > 0 {
            ship(tail)
        }
    }
}






private extension NSData {
    func splitHead(maxHeadLength: Int) -> (head: NSData, tail: NSData) {
        let len1 = min(length, maxHeadLength)
        let len2 = length - len1
        let head = subdataWithRange(NSRange(location: 0, length: len1))
        let tail = subdataWithRange(NSRange(location: len1, length: len2))
        return (head, tail)
    }
}











