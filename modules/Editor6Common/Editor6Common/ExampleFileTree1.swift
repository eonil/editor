//
//  ExampleFileTree1.swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

import EonilToolbox

struct ExampleFileTree1: Tree2Protocol {
    private var coreImpl = Tree2<NodeID, NodeState>()

    var count: Int {
        return coreImpl.count
    }
    subscript(_ indexPath: Tree2<NodeID, NodeState>.IndexPath) -> (Node)? {
        get {
            return coreImpl[indexPath]
        }
        set {
            coreImpl[indexPath] = newValue
        }
    }
    func children(of parent: ExampleFileTree1.NodeID) -> [ExampleFileTree1.NodeID]? {
        return coreImpl.children(of: parent)
    }


}

extension ExampleFileTree1 {
    typealias Node = (NodeID, NodeState)
    struct NodeID: Hashable {
        let coreImpl = URL(fileURLWithPath: "./")
        var hashValue: Int {
            return coreImpl.hashValue
        }
        static func == (_ a: NodeID, _ b: NodeID) -> Bool {
            return a.coreImpl == b.coreImpl
        }
    }
    struct NodeState {
        var kind = NodeKind.file
    }
    enum NodeKind {
        case file
        case folder
    }
}
