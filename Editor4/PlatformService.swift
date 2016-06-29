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
    case StoreWorkspace(WorkspaceState)
    case RestoreWorkspace(WorkspaceID, location: NSURL)
    case RenameFile(from: NSURL, to: NSURL) 
}
enum PlatformNotification {
    @available(*,deprecated=0)
    case ReloadWorkspace(WorkspaceID, WorkspaceState)
}
enum PlatformError: ErrorType {
    case BadURLs([NSURL])
    case MissingWorkspaceLocation
    case UTF8EncodingFailure
    case BadFileListFileContent
}

/// Provides a platform invoke service.
///
/// - Note:
///     Take care that some platform features need to be called from main-thread only.
///
final class PlatformService: DriverAccessible {
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

        case .StoreWorkspace(let workspaceState):
            guard let u = workspaceState.getFileListURL() else { throw PlatformError.MissingWorkspaceLocation }
            var bs = [UInt8]()
            debugLog(Array(try WorkspaceSerializationUtility.serialize(workspaceState)))
            try WorkspaceSerializationUtility.serialize(workspaceState).forEach({ bs.appendContentsOf($0.utf8) })
            try bs.withUnsafeMutableBufferPointer({ (inout p: UnsafeMutableBufferPointer<UInt8>) -> () in
                let d = (p.count == 0) ? NSData() : NSData(bytesNoCopy: p.baseAddress, length: p.count, freeWhenDone: false)
                try d.writeToURL(u, options: NSDataWritingOptions.DataWritingAtomic)
            })
            return Task(())

        case .RestoreWorkspace(let workspaceID, let location):
            var tempWorkspaceState = WorkspaceState()
            tempWorkspaceState.location = location
            guard let u = tempWorkspaceState.getFileListURL() else { throw PlatformError.MissingWorkspaceLocation }
            let d = try NSData(contentsOfURL: u, options: [])
            guard let s = (NSString(data: d, encoding: NSUTF8StringEncoding) as String?) else { throw PlatformError.BadFileListFileContent }
            var newWorkspaceState = try WorkspaceSerializationUtility.deserialize(s)
            newWorkspaceState.location = location
            return driver.operation.reloadWorkspace(workspaceID, workspaceState: newWorkspaceState)

        case .RenameFile(let from, let to):
            try NSFileManager.defaultManager().moveItemAtURL(from, toURL: to)
            return Task(())
        }
    }
}

private extension WorkspaceState {
    func getFileListURL() -> NSURL? {
        return location?.URLByAppendingPathComponent("Workspace.FileList")
    }
}

















