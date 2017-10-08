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
            guard u != state.location else { return .success(Void()) }

            // Save if needed.
            if state.location != nil {
                switch process(.save) {
                case .failure(let issue):   return .failure(issue)
                case .success(_):           break
                }
            }

            // Perform input I/O first.
            // Be transactional.
            // No in-memory change on failure.
//            let isDir: Bool?
//            do { isDir = (try u.resourceValues(forKeys: [.isDirectoryKey])).isDirectory }
//            catch let err { return .failure(.open(.fileSystemError(err))) }
//            guard let isDir = isDir else { return .failure(.open(.unableToCheckFileForDirectoryFile)) }
//            guard isDir == false else {  }
            guard let d = try? Data(contentsOf: u) else { return .failure(.open(.fileContentCannotBeDecodedFromUInt8ArrayUsingUTF8)) }
            let s = String(data: d, encoding: .utf8)

            // Update in-memory state & cast.
            state.location = u
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

        case .saveIfNeeded:
            guard state.location != nil else { return .success(Void()) }
            return process(.save)

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
            case unableToCheckFileForDirectoryFile
            case fileSystemError(Error)
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
        ///
        /// Open and load contents of file at designated URL.
        /// If this fails for any reason, that will be treated as an error.
        /// Do not send this command for file entries that are not supported.
        /// (e.g., directory files)
        ///
        case open(URL)
        ///
        /// Save currently editing file.
        /// This returns a failure for any error.
        ///
        case save
        ///
        /// Save only if needed. Otherwise, this is no-op.
        /// Unlike `save`, this just ignores if nothing is currently loaded
        /// in editor.
        /// Anyway, if there's a loaded file and if the file cannot be saved,
        /// this also returns a failure.
        ///
        case saveIfNeeded
        case setContent(String)
        case close
    }
}
