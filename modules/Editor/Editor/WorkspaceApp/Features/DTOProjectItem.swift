//
//  DTOProjectItem.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/07.
//Copyright © 2017 Eonil. All rights reserved.
//

struct DTOProjectItem: DTOProjectCoding {
    var kind: Kind
    var path: ProjectItemPath

    init(kind: Kind, path: ProjectItemPath) {
        self.kind = kind
        self.path = path
    }
    init(node: ProjectFeature.FileNode, path: ProjectItemPath) {
        kind = {
            switch (node.kind, node.isFolded) {
            case (.folder, true):   return .closedGroup
            case (.folder, false):  return .openGroup
            case (.file, _):        return .dataFile
            }
        }()
        self.path = path
    }
    var node: ProjectFeature.FileNode {
        let name = path.isEmpty ? "" : path.last!
        switch kind {
        case .openGroup:    return ProjectFeature.FileNode(name: name, kind: .folder, isFolded: false)
        case .closedGroup:  return ProjectFeature.FileNode(name: name, kind: .folder, isFolded: true)
        case .dataFile:     return ProjectFeature.FileNode(name: name, kind: .file, isFolded: true)
        }
    }

    static func encode(_ v: DTOProjectItem) -> String {
        let k = v.kind.rawValue
        let p = ProjectItemPath.encode(v.path)
        return "\(k) \(p)"
    }
    static func decode(_ s: String) -> Result<DTOProjectItem, String> {
        let parts = s.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        let p0 = String(parts[0])
        let p1 = String(parts[1])
        guard let k = Kind(rawValue: p0) else { return .failure("Unknown kind: \(p0)") }
        let p: ProjectItemPath
        switch ProjectItemPath.decode(p1) {
        case .failure(let issue):   return .failure(issue)
        case .success(let path):    p = path
        }
        return .success(DTOProjectItem(kind: k, path: p))
    }

    enum Kind: String {
        case dataFile       =   "f"
        case openGroup      =   "g"
        case closedGroup    =   "h"
    }
}

import Foundation

extension ProjectItemPath: DTOProjectCoding {
    static func encode(_ v: ProjectItemPath) -> String {
        if v == .root { return "/" }
        var u = URL(string: "editor://workspace")!
        for c in v.components {
            u = u.appendingPathComponent(c)
        }
        return URLComponents(url: u, resolvingAgainstBaseURL: false)!.percentEncodedPath
    }
    static func decode(_ s: String) -> Result<ProjectItemPath, String> {
        guard s != "/" else { return .success(.root) }
        let f = "editor://workspace\(s)"
        guard let u = URL(string: f) else { return .failure("A URL could not be obtained from the code: \(s)") }
        return .success(ProjectItemPath(Array(u.pathComponents.dropFirst())))
    }
}
