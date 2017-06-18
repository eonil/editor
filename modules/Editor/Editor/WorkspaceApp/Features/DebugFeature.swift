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

final class DebugFeature {
    let transaction = Relay<Transaction>()
    private(set) var targetProps = [TargetRef: Relay<TargetRef.Transaction>]()
    weak var services: WorkspaceServices? {
        willSet {
            guard services != nil else { return }
            killAllTargets()
        }
        didSet {
            guard services != nil else { return }
            spawnAllTargets()
        }
    }

    deinit {
        assert(services == nil, "`services` should already been removed at this point.")
    }
    @discardableResult
    func spawnTarget(_ executable: URL) -> TargetRef {
        guard let dbg = services?.lldb.debugger else { REPORT_missingServiceAndFatalError() }
        precondition(executable.isFileURL)
        guard let lldbTarget = dbg.createTarget(withFilename: executable.path) else { REPORT_fatalError("Cannot create an LLDB target.") }
        let ref = TargetRef(origin: self, lldbTarget: lldbTarget)
        let r = Relay<TargetRef.Transaction>()
        targetProps[ref] = r
        return ref
    }
    private func killTarget(_ ref: TargetRef) {
        guard let dbg = services?.lldb.debugger else { REPORT_missingServiceAndFatalError() }
        let lldbTarget = ref.lldbTarget
        dbg.delete(lldbTarget)
        targetProps[ref] = nil
    }
    private func reset() {
        targetProps.removeAll()
        guard let dbg = services?.lldb.debugger else { return }
        for i in 0..<dbg.numberOfTargets {
            let t = dbg.target(at: i)
            guard let p = t?.executableFileSpec().filename else { REPORT_fatalError("Missing or bad executable path. Cannot process a LLDBTarget.") }
            let u = URL(fileURLWithPath: p)
            spawnTarget(u)
        }
    }
    private func spawnAllTargets() {
        assert(targetProps.isEmpty)
        guard let services = services else { REPORT_missingServiceAndFatalError() }
        for t in services.lldb.debugger.allTargets {
            let id = TargetRef(origin: self, lldbTarget: t)
            targetProps[id] = Relay()
        }
    }
    private func killAllTargets() {
        guard let services = services else { REPORT_missingServiceAndFatalError() }
        for (k, _) in targetProps {
            services.lldb.debugger.delete(k.lldbTarget)
        }
        targetProps.removeAll()
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
