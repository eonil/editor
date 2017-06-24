//
//  DebugFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper
import EonilSignet
import EonilToolbox

final class DebugFeature: ServiceDependent {
    let transaction = Relay<Transaction>()
    private(set) var targetProps = [TargetRef: Relay<TargetRef.Transaction>]()

    override init() {
        super.init()
        spawnAllTargets()
    }
    deinit {
        killAllTargets()
    }
    @discardableResult
    func spawnTarget(_ executable: URL) -> TargetRef {
        return spawnTargetImpl(executable)
    }

    private func spawnAllTargets() {
        assert(targetProps.isEmpty)
        for t in services.lldb.debugger.allTargets {
            let id = TargetRef(origin: self, lldbTarget: t)
            targetProps[id] = Relay()
        }
    }
    private func killAllTargets() {
        for (k, _) in targetProps {
            services.lldb.debugger.delete(k.lldbTarget)
        }
        targetProps.removeAll()
    }
    private func spawnTargetImpl(_ executable: URL) -> TargetRef {
        let dbg = services.lldb.debugger
        precondition(executable.isFileURL)
        guard let lldbTarget = dbg.createTarget(withFilename: executable.path) else { REPORT_fatalError("Cannot create an LLDB target.") }
        let ref = TargetRef(origin: self, lldbTarget: lldbTarget)
        let r = Relay<TargetRef.Transaction>()
        targetProps[ref] = r
        return ref
    }

    private func killTarget(_ ref: TargetRef) {
        let dbg = services.lldb.debugger
        let lldbTarget = ref.lldbTarget
        dbg.delete(lldbTarget)
        targetProps[ref] = nil
    }
}
extension DebugFeature {
    enum Transaction {
        case targets(ArrayMutation<DebugFeature.TargetRef>)
    }
    struct TargetRef: Hashable {
        fileprivate unowned let origin: DebugFeature
        fileprivate unowned let lldbTarget: LLDBTarget
        var hashValue: Int {
            return lldbTarget.hashValue
        }
        func process(_ command: Command) {
            let t = lldbTarget
            switch command {
            case .launch:
                t.launchProcessSimply(withWorkingDirectory: ".")
            case .pause:
                t.process.stop()
            case .stepInto:
                t.process.thread(at: 0).stepInto()
            case .stepOut:
                t.process.thread(at: 0).stepOut()
            case .stepOver:
                t.process.thread(at: 0).stepOver()
            case .resume:
                t.process.`continue`()
            case .halt:
                t.process.kill()
            }
        }
        func setCurrentThread(_ thread: ThreadRef?) {
            guard origin.targetProps[self] != nil else { REPORT_fatalError("You cannot access an invalidated reference.") }
            lldbTarget.process.setSelectedThread(thread?.lldbThread)
        }
        func setCurrentFrame(_ frame: FrameRef?) {
            guard origin.targetProps[self] != nil else { REPORT_fatalError("You cannot access an invalidated reference.") }
            lldbTarget.process.selectedThread.setSelectedFrameBy(frame?.index ?? 0)
        }
        static func == (_ a: TargetRef, _ b: TargetRef) -> Bool {
            return a.origin === b.origin && a.lldbTarget == b.lldbTarget
        }
    }
    struct ThreadRef: Hashable {
        fileprivate let targetRef: TargetRef
        fileprivate let lldbThread: LLDBThread
        var hashValue: Int {
            return lldbThread.hashValue
        }
        static func == (_ a: ThreadRef, _ b: ThreadRef) -> Bool {
            return a.targetRef == b.targetRef && a.lldbThread == b.lldbThread
        }
    }
    struct FrameRef: Hashable {
        fileprivate let threadRef: ThreadRef
        fileprivate let index: UInt32
        var hashValue: Int {
            return index.hashValue
        }
        static func == (_ a: FrameRef, _ b: FrameRef) -> Bool {
            return a.threadRef == b.threadRef && a.index == b.index
        }
    }
}
extension DebugFeature.TargetRef {
    struct Parameters {
        var name = ""
        var executable: URL
    }
    typealias Command = DebugCommand
    struct State {
        var inspection: Inspection?
    }
    struct Inspection {
        var process: ProcessSnapshot?
        var stackFrame: StackFrameSnapshot?
    }
    enum Transaction {
        case inspectionProcess
        case inspectionStackFrame
    }
}
