//
//  SubprocessController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import BoltsSwift

enum SubprocessState {
    case NotLaunched
    case Running
    case Terminated
    case Exited
}
enum SubprocessEvent {
    case DidReceiveStandardOutput(NSData)
    case DidReceiveStandardError(NSData)
    case DidTerminate
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
    }
    func launchWithProgram(u: NSURL, arguments: [String]) {
        assert(state == .NotLaunched)
        guard state == .NotLaunched else { return }
        task.standardInput = standardInputPipe
        task.standardOutput = standardOutputPipe
        task.standardError = standardErrorPipe
        task.launchPath = u.path
        task.arguments = arguments
        task.launch()
        state = .Running
    }
    /// Terminate the subprocess immediately.
    func kill() {
        MARK_unimplemented()
    }
    func terminate() -> Task<()> {
        let compl = TaskCompletionSource<()>()
        sendingDataQueue = []
        standardInputPipe.fileHandleForWriting.writeabilityHandler = nil
        task.terminationHandler = { [weak self] _ in
            self?.state = .Terminated
            self?.onEvent?(.DidTerminate)
            compl.trySetResult(())
        }
        task.terminate()
        return compl.task
    }

    ////

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
        standardInputPipe.fileHandleForWriting.writeabilityHandler = { [weak self] h in
            if let availableData = container.payload.tryRemoveFirst() {
                h.writeData(availableData)
            }
            else {
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











