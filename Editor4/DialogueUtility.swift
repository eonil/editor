//
//  DialogueUtility.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation.NSURL
import AppKit
import BoltsSwift

struct DialogueUtility {
    static func runFolderSaveDialogue() -> Task<NSURL> {
        let c = SavePanelController()
        let t = c.completionSource.task.continueWithTask { [c] (task: Task<NSURL>) -> Task<NSURL> in
//            c.savePanel.close()
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
    static func runFolderOpenDialogue() -> Task<NSURL> {
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
