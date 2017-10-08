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
extension DTOProjectFile: DTOProjectCoding {
    private static let magic = "Eonil Editor Workspace Format 0.0.0/0"
    static func encode(_ v: DTOProjectFile) -> String {
        var code = ""
        code.append(magic)
        code.append("\n")
        // DFS is equal to topological sort.
        let idxps = TreeLazyDepthFirstIndexPathIterator(v.files)
        for idxp in idxps {
            let node = v.files.at(idxp).node
            let namep = v.files.namePath(at: idxp)
            let item = DTOProjectItem(node: node, path: namep)
            let itemCode = DTOProjectItem.encode(item)
            code.append(itemCode)
            code.append("\n")
        }
        return code
    }
    static func decode(_ s: String) -> Result<DTOProjectFile, String> {
        let lines = s.components(separatedBy: "\n")
        var dto = DTOProjectFile()
        guard lines.count >= 1 else { return .failure("Missing magic line.") }
        guard lines[0] == magic else { return .failure("Invalid magic line `\(lines[0])`.") }
        for ln in lines.dropFirst() {
            let ln1 = ln.trimmingCharacters(in: .whitespacesAndNewlines)
            if ln1 == "" { continue }
            let item: DTOProjectItem
            switch DTOProjectItem.decode(ln1) {
            case .failure(let issue):   return .failure(issue)
            case .success(let newItem): item = newItem
            }
            let namep = item.path
            typealias FileTree = ProjectFeature.FileTree
            typealias FileNode = ProjectFeature.FileNode
            if namep.components.isEmpty {
                dto.files = FileTree(node: .root)
            }
            else {
                // TODO: This can be optimized further.
                let parent_namep = namep.deletingLastComponent1()
                guard let parent_idxp = dto.files.indexPath(at: parent_namep) else { return .failure("Some intermediate path is missing.") }
                let parent_subtree = dto.files.at(parent_idxp)
                let idxp = parent_idxp.appending(parent_subtree.subtrees.count)
                let subtree = FileTree(node: item.node)
                dto.files.insert(at: idxp, subtree)
            }
        }
        return .success(dto)
    }
}
