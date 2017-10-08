//
//  ProjectFeature.State.makeLocationOnFileSystemForFile.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/08.
//Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

extension ProjectFeature.State {
    ///
    /// - Returns:
    ///     `nil` if `location == nil`.
    ///     Otherwise a URL.
    ///
    /// - Note:
    ///     This requires an existing file node at the index-path.
    ///     If a file node does not exist at the path, this crash
    ///     the app.
    ///
    func makeLocationOnFileSystemForFile(at idxp: IndexPath) -> Result<URL, MakeLocationOnFileSystemIssue> {
        guard let u = location else { return .failure(.projectHasNoLocationOnFileSystem) }
        var u1 = u
        let namep = files.namePath(at: idxp)
        for n in namep.components {
            u1 = u1.appendingPathComponent(n)
        }
        return .success(u1)
    }

    ///
    /// This doesn't require an existing file node in state.
    /// Works always.
    ///
    func makeLocationOnFileSystemForFile(at namep: ProjectItemPath) -> Result<URL, MakeLocationOnFileSystemIssue> {
        guard let u = location else { return .failure(.projectHasNoLocationOnFileSystem) }
        var u1 = u
        for n in namep.components {
            u1 = u1.appendingPathComponent(n)
        }
        return .success(u1)
    }

    enum MakeLocationOnFileSystemIssue {
        case projectHasNoLocationOnFileSystem
    }
}
