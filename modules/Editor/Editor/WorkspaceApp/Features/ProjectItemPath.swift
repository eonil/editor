//
//  ProjectItemPath.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/22.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

struct ProjectItemPath: Hashable {
    var components = [String]()
    init(components initialComponents: [String]) {
        components = initialComponents
    }
    var hashValue: Int {
        return components.last?.hashValue ?? 0
    }
    var isRoot: Bool {
        return components.isEmpty
    }
    func appendingComponent(_ component: String) -> ProjectItemPath {
        return ProjectItemPath(components: components + [component])
    }
    func deletingLastComponent() -> Result<ProjectItemPath, String> {
        guard components.isEmpty == false else { return .failure("This is root path(`/`). Cannot delete more.") }
        return .success(ProjectItemPath(components: Array(components.dropLast())))
    }
    static func == (_ a: ProjectItemPath, _ b: ProjectItemPath) -> Bool {
        return a.components == b.components
    }
    static var root: ProjectItemPath {
        return ProjectItemPath(components: [])
    }
}

extension ProjectItemPath {
    enum ConversionError: Error {
        case nonFileURLUnsupported
        case hasNoRelativeFilePath
    }
//    init(relativeFileURLFromWorkspaceRoot u: URL) throws {
//        guard u.isFileURL else { throw ConversionError.nonFileURLUnsupported }
//        guard u.path.hasPrefix("./") else { throw ConversionError.hasNoRelativeFilePath }
//        self = ProjectFeature.Path(components: u.pathComponents)
//    }
//    func makeRelativeFileURLFromWorkspaceRoot() -> URL {
//        var u = URL(fileURLWithPath: "./")
//        for c in components {
//            u = u.appendingPathComponent(c)
//        }
//        return u
//    }
}

extension Tree2 where Key == ProjectItemPath {
    func index(of path: Key) -> Tree2.IndexPath? {
        if path == .root { return .root }
        let parentPathResult = path.deletingLastComponent()
        switch parentPathResult {
        case .failure(_):
            return nil
        case .success(let parentPath):
            guard let cs = children(of: parentPath) else { return nil }
            guard let lastIndexComp = cs.index(of: path) else { return nil }
            guard let parentIndex = index(of: parentPath) else { return nil }
            let finalIndex = parentIndex.appendingLastComponent(lastIndexComp)
            return finalIndex
        }
    }
}
