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
    func process(_ cmd: Command) -> Result<Void, ProcessIsse> {
        switch cmd {
        case .open(let u):
            switch process(.save) {
            case .failure(let issue):   return .failure(issue)
            case .success(_):           break
            }
            guard u != state.location else { return .failure(.open(.missingFileLocation)) }
            state.location = u
            state.content = nil
            changes.cast(())
            guard let d = try? Data(contentsOf: u) else { return .failure(.open(.fileContentCannotBeDecodedFromUInt8ArrayUsingUTF8)) }
            let s = String(data: d, encoding: .utf8)
            state.content = s
            changes.cast(())
            return .success(Void())

        case .save:
            guard let u = state.location else { return .failure(.save(.missingFileLocation)) }
            guard let s = state.content else { return .failure(.save(.nilFileContentCannotBeSaved)) }
            guard let d = s.data(using: .utf8) else { return .failure(.save(.fileContentCannotBeEncodedIntoUInt8ArrayUsingUTF8)) }
            do { try d.write(to: u) }
            catch let err { return .failure(.save(.fileSystemError(err))) }
            return .success(Void())

        case .close:
            switch process(.save) {
            case .failure(let issue):   return .failure(issue)
            case .success(_):           break
            }
            state.location = nil
            state.content = nil
            changes.cast(())
            return .success(Void())

        case .setContent(let s):
            state.content = s
            return .success(Void())
        }
    }
    enum ProcessIsse {
        case cannotSaveCurrentlyEditingCodeIntoFile
        case open(OpenIssue)
        case save(SaveIssue)

        enum OpenIssue {
            case missingFileLocation
            case fileContentCannotBeDecodedFromUInt8ArrayUsingUTF8
        }
        enum SaveIssue {
            case missingFileLocation
            case nilFileContentCannotBeSaved
            case fileContentCannotBeEncodedIntoUInt8ArrayUsingUTF8
            case fileSystemError(Error)
        }
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
        case setContent(String)
        case close
    }
}
