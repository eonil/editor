//
//  DialogueService.swift
//  Editor4
//
//  Created by Hoon H. on 2016/06/29.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation.NSURL
import AppKit
import BoltsSwift

final class DialogueService: DriverAccessible {
    private let processingGCDQ = dispatch_get_main_queue()
    private let continuationGCDQ = dispatch_queue_create("\(DialogueService.self)/continuationGCDQ", DISPATCH_QUEUE_SERIAL)!

    func runFolderSaveDialogue() -> Task<NSURL> {
        return runInProcessingGCDQAsTask {
            assertMainThread()
            let c = SavePanelController()
            let t = c.completionSource.task.continueWithTask { [c] (task: Task<NSURL>) -> Task<NSURL> in
//                c.savePanel.close()
                return task
            }
            switch c.savePanel.runModal() {
            case NSFileHandlingPanelOKButton:
                if let u = c.savePanel.URL {
                    c.completionSource.trySetResult(u)
                    return t
                }
            default:
                break
            }
            c.completionSource.tryCancel()
            return t
        }
    }
    func runFolderOpenDialogue() -> Task<NSURL> {
        return runInProcessingGCDQAsTask {
            assertMainThread()
            let c = OpenPanelController()
            let t = c.completionSource.task.continueWithTask { [c] (task: Task<NSURL>) -> Task<NSURL> in
                return task
            }
            switch c.openPanel.runModal() {
            case NSFileHandlingPanelOKButton:
                if let u = c.openPanel.URL {
                    c.completionSource.trySetResult(u)
                    return t
                }
            default:
                break
            }
            c.completionSource.tryCancel()
            return t
        }
    }

    private func runInProcessingGCDQ<T>(process: () -> T) -> Task<T> {
        return Task(()).continueOnSuccessWith(.Queue(dispatch_get_main_queue())) {
            return process()
        }.continueIn(continuationGCDQ)
    }
    private func runInProcessingGCDQAsTask<T>(process: () -> Task<T>) -> Task<T> {
        return Task(()).continueOnSuccessWithTask(.Queue(dispatch_get_main_queue())) {
            return process()
        }.continueIn(continuationGCDQ)
    }
}

private final class SavePanelController: NSObject, NSOpenSavePanelDelegate {
    let savePanel = NSSavePanel()
    let completionSource = TaskCompletionSource<NSURL>()
}
private final class OpenPanelController: NSObject {
    let openPanel = NSOpenPanel()
    let completionSource = TaskCompletionSource<NSURL>()
    override init() {
        super.init()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
    }
}
