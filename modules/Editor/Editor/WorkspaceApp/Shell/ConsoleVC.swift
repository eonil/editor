//
//  ConsoleVC.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class ConsoleVC: NSViewController, WorkspaceFeatureDependent {
    private let buildChangeWatch = Relay<[BuildFeature.Change]>()
    private let logChangeWatch = Relay<[LogFeature.Change]>()

    weak var features: WorkspaceFeatures? {
        didSet {
            render()
            features?.build.changes += buildChangeWatch
            features?.log.changes += logChangeWatch
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        buildChangeWatch.delegate = { [weak self] in self?.processBuildChanges($0) }
        logChangeWatch.delegate = { [weak self] in self?.processLogChanges($0) }
    }
    private func processBuildChanges(_ cs: [BuildFeature.Change]) {
        for c in cs {
            switch c {
            case .phase:
                break
            case .session(let field):
                switch field {
                case .id:
                    break
                case .logs:
                    render()
                }
            }
        }
    }
    private func processLogChanges(_ cs: [LogFeature.Change]) {
        DEBUG_log("Receive log change: \(cs)")
        for c in cs {
            switch c {
            case .currentSession:
                render()
                // TODO: Needs optimization.
            case .archivedSessions:
                REPORT_unimplementedAndContinue()
            }
        }
    }
    private func render() {
        func toConsoleLogLine(_ m: LogFeature.Item) -> String? {
            switch m {
            case .cargoReport(let r):
                switch r {
                case .stdout(_):        return nil
                case .stderr(let s):    return s
                }
            case .cargoIssue(let s):    return "\(s)"
            case .ADHOC_any(let v):     return prettifySwiftReflectiveDescription("\(v)")
            }
        }
        let lines = features?.log.state.currentSession.items.flatMap(toConsoleLogLine) ?? []
        codeTextView?.string = lines.joined(separator: "\n")
        codeTextView?.isEnabled = true
    }
//    private func renderLogChanges(_ cs: [LogFeature.Change]) {
//        MARK_unimplemented()
//    }

    @IBOutlet private weak var codeTextView: CodeView?
}

private func prettifySwiftReflectiveDescription(_ s: String) -> String {
    var indent = 0
    var s1 = ""
    func newLine() {
        s1.append("\n")
        for _ in 0..<indent {
            s1.append("    ")
        }
    }
    var skipWhitespaces = false
    var isStringLiteral = false
    var escapingCount = 0
    for ch in s {
        // Append source character.
        switch ch {
        case "\\":
            if isStringLiteral {
                escapingCount = 2
            }
            s1.append(ch)
        case "\"":
            if escapingCount == 0 {
                isStringLiteral = !isStringLiteral
            }
            s1.append("\"")
        case " ", "\t":
            if skipWhitespaces == false {
                s1.append(ch)
            }
        case "\n":
            s1.append(isStringLiteral ? "\\n" : "\n")
        case ",":
            if isStringLiteral == false { skipWhitespaces = true }
            s1.append(ch)
        default:
            skipWhitespaces = false
            s1.append(ch)
        }

        if escapingCount > 0 {
            escapingCount -= 1
        }

        // Append extra formatting characters.
        if isStringLiteral == false {
            switch ch {
            case "\n":
                newLine()
            case ",":
                newLine()
            case "(":
                indent += 1
                newLine()
            case ")":
                indent -= 1
            default:
                break
            }
        }
    }
    return s1
}
