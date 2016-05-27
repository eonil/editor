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
    case CreateDirectoryWithIntermediateDirectories(NSURL)
    case CreateDataFileWithIntermediateDirectories(NSURL)
    case DeleteFileSubtrees([NSURL])
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
            guard let S = self else { return Task.cancelledTask() }
            return try S.step(command)
        }
    }
    private func step(command: PlatformCommand) throws -> Task<()> {
        switch command {
        case .CreateDirectoryWithIntermediateDirectories(let u):
            assert(u.fileURL)
            try NSFileManager.defaultManager().createDirectoryAtURL(u, withIntermediateDirectories: true, attributes: nil)
            return Task(())

        case .CreateDataFileWithIntermediateDirectories(let u):
            assert(u.fileURL)
            try NSData().writeToURL(u, options: NSDataWritingOptions.DataWritingWithoutOverwriting)
            return Task(())

        case .DeleteFileSubtrees(let us):
            assert(us.map { $0.fileURL }.reduce(true, combine: { $0 && $1 }))
            us.forEach { u in
                // Eat-up errors.
                let _ = try? NSFileManager.defaultManager().removeItemAtURL(u)
            }
            return Task(())

        case .OpenFileInFinder(let urls):
            NSWorkspace.sharedWorkspace().activateFileViewerSelectingURLs(urls) // This method is safe to be called from any thread.
            return Task(())
        }
    }
}

















