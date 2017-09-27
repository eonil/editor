//
//  CodeEditingFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

final class CodeEditingFeature: WorkspaceFeatureComponent {
    let changes = Relay<()>()
    private(set) var state = State()
    func process(_ cmd: Command) -> [WorkspaceCommand] {
        switch cmd {
        case .open(let u):
            guard u != state.location else { break }
            state.location = u
            state.content = nil
            changes.cast(())
            guard let d = try? Data(contentsOf: u) else { break }
            let s = String(data: d, encoding: .utf8)
            state.content = s
            changes.cast(())
            return []

        case .save:
            guard let u = state.location else {
                REPORT_ignoredSignal(cmd)
                break
            }
            guard let s = state.content else {
                REPORT_ignoredSignal(cmd)
                break
            }
            guard let d = s.data(using: .utf8) else {
                REPORT_recoverableWarning("Cannot encode code content into UTF-8.")
                break
            }
            let r = d.write(to: u)
            if r.isFailure {
                return [.dialogue(.spawn(.error(.cannotSaveCurrentlyEditingCodeIntoFile)))]
            }
            return []

        case .close:
            guard state.location != nil else {
                REPORT_ignoredSignal(cmd)
                break
            }
            state.location = nil
            state.content = nil
            changes.cast(())
            return []
        }
        return []
    }
}
extension CodeEditingFeature {
    struct State {
        var location: URL?
        var content: String?
    }
    enum Command {
        case open(URL)
        case save
        case close
    }
}
