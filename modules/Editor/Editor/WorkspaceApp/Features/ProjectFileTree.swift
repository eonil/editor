////
////  ProjectFileTree.swift
////  Editor
////
////  Created by Hoon H. on 2017/10/03.
////Copyright © 2017 Eonil. All rights reserved.
////
//
//import EonilTree
//
/////
///// Adds these features to `Tree`.
///// - Empty name check.
///// - Duplicated name check.
/////
//struct ProjectTree {
//    typealias CoreTree = Tree<ProjectNode>
//    private var core = CoreTree(node: .root)
//
//    var subtrees: ProjectSubtreeCollection {
//        get { return ProjectSubtreeCollection(core: core.subtrees) }
//        set { core.subtrees = newValue.core }
//    }
//    mutating func insert(at path: IndexPath, subtree: ProjectTree) {
//        core.insert(at: path, subtree.core)
//    }
//    mutating func remove(at path: IndexPath) {
//        core.remove(at: path)
//    }
//
//    struct ProjectSubtreeCollection: RandomAccessCollection, RangeReplaceableCollection {
//        fileprivate var core: CoreTree.SubtreeCollection
//        init() {
//            self.core = CoreTree.SubtreeCollection()
//        }
//        fileprivate init(core: CoreTree.SubtreeCollection) {
//            self.core = core
//        }
//        var startIndex: Int { return core.startIndex }
//        var endIndex: Int { return core.endIndex }
//        subscript(position: Int) -> ProjectTree {
//            get { return ProjectTree(core: core[position]) }
//            set {
//                precondition(isAcceptableName(newValue.core.node.name), "The node's name is unacceptable.")
//                core[position] = newValue.core
//            }
//        }
//        private func isAcceptableName(_ name: String) -> Bool {
//            guard name.isEmpty == false else { return false }
//            for e in self {
//                guard e.core.node.name != name else { return false }
//            }
//            return true
//        }
//    }
//}
//
//struct ProjectNode {
//    var name: String
//    var kind: Kind
//
//    ///
//    /// Provides root node.
//    /// A root node is the only node which is allowed to have empty name.
//    ///
//    static var root: ProjectNode {
//        return ProjectNode(name: "", kind: .folder)
//    }
//
//    enum Kind {
//        case folder
//        case file
//    }
//}

