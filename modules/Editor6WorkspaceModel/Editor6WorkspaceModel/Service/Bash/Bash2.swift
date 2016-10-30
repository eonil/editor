//
//  Bash2.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/22.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import Flow

enum Bash2Notification {
    case stdout(String)
    case stderr(String)
}
enum Bash2Error: Error {
    case nonZeroExitCode(exitCode: Int32)
}
enum Bash2 {
    typealias Return = (stdin: (String) -> (), flow: Step<()>)
    static func run(ioQueuePair: IOQueuePair, delegate: @escaping (Bash2Notification) -> ()) -> Return {
        let bash1 = Bash1(ioQueuePair: ioQueuePair)
        let stdin = { [weak bash1] (s: String) -> () in bash1?.dispatch([s]) }
        let flow = DispatchQueue.main.flow(with: ()).step { [bash1] (_: (), signal: (ok: () -> (), error: (Error) -> ())) in
            bash1.delegate { (sender: Bash1, action: Bash1.Action) in
                switch action {
                case .output(let lines):
                    for line in lines {
                        delegate(.stdout(line))
                    }
                case .error(let lines):
                    for line in lines {
                        delegate(.stderr(line))
                    }
                case .terminate(let exitCode):
                    guard exitCode == 0 else {
                        signal.error(Bash2Error.nonZeroExitCode(exitCode: exitCode))
                        return
                    }
                    signal.ok()
                }
            }
        }
        return (stdin, flow)
    }
}
