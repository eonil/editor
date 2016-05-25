//
//  PlatformService.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Dispatch
import BoltsSwift
import AppKit

enum PlatformCommand {
    case OpenFileInFinder([NSURL])
}
enum PlatformError: ErrorType {
    case BadURLs([NSURL])
}

/// Provides a platform invoke service.
///
/// - Note:
///     Take care that some platform features need to be called from main-thread only.
///
final class PlatformService {
    private let gcdq = dispatch_queue_create("\(PlatformService.self)", DISPATCH_QUEUE_SERIAL)
    func dispatch(command: PlatformCommand) -> Task<()> {
        return Task(()).continueWithTask(Executor.Queue(gcdq)) { [weak self] (task: Task<()>) throws -> Task<()> in
            guard let S = self else { return task }
            return try S.step(command)
        }
    }
    private func step(command: PlatformCommand) throws -> Task<()> {
        switch command {
        case .OpenFileInFinder(let urls):
            NSWorkspace.sharedWorkspace().activateFileViewerSelectingURLs(urls)
            return Task(())
        }
    }
}