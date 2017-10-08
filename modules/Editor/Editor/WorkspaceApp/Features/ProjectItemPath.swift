//
//  ProjectItemPath.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/22.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

struct ProjectItemPath: Hashable, RandomAccessCollection, RangeReplaceableCollection {
    typealias SubSequence = ProjectItemPath
    var comps = [String]()
    init() {
    }
    init(components initialComponents: [String]) {
        comps = initialComponents
    }
    init(_ initialComponents: [String]) {
        comps = initialComponents
    }
    var hashValue: Int {
        return components.last?.hashValue ?? 0
    }

    var startIndex: Int { return comps.startIndex }
    var endIndex: Int { return comps.endIndex }
    subscript(position: Int) -> String {
        return comps[position]
    }
    subscript(range: Range<Int>) -> ProjectItemPath {
        return ProjectItemPath(comps[range])
    }
    mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, ProjectItemPath.Element == C.Element, Int == R.Bound {
        comps.replaceSubrange(subrange, with: newElements)
    }

    @available(*, deprecated: 0)
    var components: [String] {
        return comps
    }
    @available(*, deprecated: 0)
    var isRoot: Bool {
        return components.isEmpty
    }
    @available(*, deprecated: 0)
    func appendingComponent(_ component: String) -> ProjectItemPath {
        return ProjectItemPath(components: components + [component])
    }
    @available(*, deprecated: 0)
    func deletingLastComponent() -> Result<ProjectItemPath, String> {
        guard components.isEmpty == false else { return .failure("This is root path(`/`). Cannot delete more.") }
        return .success(ProjectItemPath(components: Array(components.dropLast())))
    }
    @available(*, deprecated: 0)
    func deletingLastComponent1() -> ProjectItemPath {
        precondition(components.isEmpty == false)
        return ProjectItemPath(components: Array(components.dropLast()))
    }
    
    @available(*, deprecated: 0)
    func appending(_ subpath: ProjectItemPath) -> ProjectItemPath {
        let comps = components + subpath.components
        return ProjectItemPath(components: comps)
    }
    @available(*, deprecated: 0)
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

extension ProjectItemPath: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: String...) {
        comps = elements
    }
}
