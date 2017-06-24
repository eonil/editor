//
//  ProjectItemPath.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/22.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

struct ProjectItemPath: Hashable {
    private var core = URL(fileURLWithPath: "./")
    init(components initialCompoenents: [String]) {
        var u = URL(fileURLWithPath: "./")
        for c in initialCompoenents {
            u = u.appendingPathComponent(c)
        }
        core = u
    }
    var components: [String] {
        get { return core.pathComponents }
        set { self = ProjectItemPath(components: components) }
    }
    var hashValue: Int {
        return core.hashValue
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

