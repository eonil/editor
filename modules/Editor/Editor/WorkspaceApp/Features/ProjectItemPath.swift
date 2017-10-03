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
    func deletingLastComponent1() -> ProjectItemPath {
        precondition(components.isEmpty == false)
        return ProjectItemPath(components: Array(components.dropLast()))
    }
    func splitFirstComponent() -> (fistComponent: String, ProjectItemPath) {
        let (a, b) = components.splitFirst()
        return (a, ProjectItemPath(components: Array(b)))
    }
    func splitLastComponent() -> (ProjectItemPath, lastComponent: String) {
        let (a, b) = components.splitLast()
        return (ProjectItemPath(components: Array(a)), b)
    }
    static func == (_ a: ProjectItemPath, _ b: ProjectItemPath) -> Bool {
        return a.components == b.components
    }
    static var root: ProjectItemPath {
        return ProjectItemPath(components: [])
    }
}
extension ProjectItemPath {
    static func fromUnixFilePathFromProjectRoot(_ p: String) -> ProjectItemPath {
        let ps = p.split(separator: "/").map({String($0)})
        return ProjectItemPath(components: ps)
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


