//
//  ProjectFeature.Command.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/03.
//Copyright © 2017 Eonil. All rights reserved.
//

extension ProjectFeature {
    enum Command {
        case setNodeFoldingState(at: IndexPath, isFolded: Bool)
        case setSelection(to: ProjectSelection)

        ///
        /// Make a new file at designated position
        /// with a templated new-file-name.
        ///
        /// This is required because clicking position is only temporarily
        /// available in AppKit's `NSOutlineView`. It's not appropriate to
        /// keep the clicking point information in another memory.
        /// (really...?)
        ///
        /// - Parameters at:
        ///     Position to insert a new file.
        ///     If this is `nil`, position will be inferred automatically
        ///     based on current selection.
        ///     For now, right under the current selection.
        ///
        case makeFile(at: IndexPath, as: NodeKind)
        ///
        /// Make a new file at automatically inferred location
        /// with a templated new-file-name.
        ///
        case makeFileAtInferredPosition(as: NodeKind)
        case renameFile(at: IndexPath, with: String)

        ///
        /// This command may cause some user-interaction during process.
        ///
        /// This tries these steps.
        /// - Move file on system.
        /// - If fails, for any reason, it spawns an alert.
        ///   Potential reasons.
        ///   - Any file-system error.
        /// - Logical bugs crash program.
        ///   - A file does not exist at `from` path.
        ///   - A file already exists at `to` path.
        ///
        case moveFile(from: IndexPath, to: IndexPath)

        case deleteSelectedFiles
    }
}
