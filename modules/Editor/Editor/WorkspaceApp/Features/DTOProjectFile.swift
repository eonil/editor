//
//  DTOProjectFile.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilTree

struct DTOProjectFile {
    var files = ProjectFeature.FileTree(node: .root)

    init() {}
    init(files fs: ProjectFeature.FileTree) {
        files = fs
    }
//    init?(code: String) {
//        let r = DTOProjectFile.decode(code)
//        switch r {
//        case .failure(_):
//            return nil
//        case .success(let dto):
//            self = dto
//        }
//    }
//    init?(data: Data) {
//
//    }
//    init(contentsOf u: URL) throws {
//
//    }
    func makeCode() -> String {
        return DTOProjectFile.encode(self)
    }
    func makeData() -> Data {
        return makeCode().data(using: .utf8)!
    }
    func write(to u: URL) throws {
        try makeData().write(to: u, options: [.atomicWrite])
    }
}
extension DTOProjectFile {
    private static let magic = "Eonil Editor Workspace Format 0.0.0/0"
    static func encode(_ p: DTOProjectFile) -> String {
        var lines = [String]()
        lines.append(magic)
        // DFS is equal to topological sort.
        let idxps = TreeLazyDepthFirstIndexPathIterator(p.files)
        for idxp in idxps {
            let node = p.files.at(idxp).node
            let namep = p.files.namePath(at: idxp)
            let kind = node.kind
            let ln = [kind.makeCode(), namep.makeSerialized()].joined(separator: " ")
            lines.append(ln)
        }
        return lines.map({ $0 + "\n" }).joined()
    }
    static func decode(_ s: String) -> Result<DTOProjectFile, String> {
        let lines = s.components(separatedBy: "\n")
        var dto = DTOProjectFile()
        guard lines.count >= 1 else { return .failure("Missing magic line.") }
        guard lines[0] == magic else { return .failure("Invalid magic line `\(lines[0])`.") }
        for ln in lines.dropFirst() {
            let ln1 = ln.trimmingCharacters(in: .whitespacesAndNewlines)
            if ln1 == "" { continue }
            guard let ch0 = ln1.characters.first else { return .failure("Missing type speficier in line `\(ln1)`.") }
            guard let ch1 = ln1.characters.dropFirst().first else { return .failure("Missing type separator in line `\(ln1)`.") }
            guard ch1 == " " else { return .failure("Invalid type speficier in line `\(ln1)`.") }
            let type = String(ch0)
            let path = String(ln1.characters.dropFirst(2))
            guard let p = ProjectItemPath(path) else { return .failure("Ill-formed path `\(path)`.") }
            guard let c = ProjectFeature.NodeKind(code: type) else { return .failure("Unknown type code `\(type)`.") }
            // TODO: This can be optimized further.
            typealias FileTree = ProjectFeature.FileTree
            typealias FileNode = ProjectFeature.FileNode
            if p.components.isEmpty {
                dto.files = FileTree(node: .root)
            }
            else {
                let parent_namep = p.deletingLastComponent1()
                guard let parent_idxp = dto.files.indexPath(at: parent_namep) else { return .failure("Some intermediate path is missing.") }
                let parent_subtree = dto.files.at(parent_idxp)
                let idxp = parent_idxp.appending(parent_subtree.subtrees.count)
                let node = FileNode(name: p.components.last!, kind: c, isExpanded: false)
                let subtree = FileTree(node: node)
                dto.files.insert(at: idxp, subtree)
            }
        }
        return .success(dto)
    }
}

private extension ProjectItemPath {
    init?(_ s: String) {
        guard s != "/" else {
            self = .root
            return
        }
        let f = "editor://workspace\(s)"
        guard let u = URL(string: f) else { return nil }
        self = .init(components: Array(u.pathComponents.dropFirst()))
    }
    func makeSerialized() -> String {
        if self == .root { return "/" }
        var u = URL(string: "editor://workspace")!
        for c in components {
            u = u.appendingPathComponent(c)
        }
        return URLComponents(url: u, resolvingAgainstBaseURL: false)!.percentEncodedPath
    }
}

private extension ProjectFeature.NodeKind {
    init?(code: String) {
        switch code {
        case "g":
            self = .folder
        case "f":
            self = .file
        default:
            return nil
        }
    }
    func makeCode() -> String {
        switch self {
        case .folder:   return "g"
        case .file:     return "f"
        }
    }
}
