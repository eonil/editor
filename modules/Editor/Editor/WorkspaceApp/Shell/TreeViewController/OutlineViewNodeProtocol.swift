//
//  TreeNode.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/21.
//  Copyright © 2017 Eonil. All rights reserved.
//

protocol OutlineViewNodeProtocol: class {
    var isExpandable: Bool { get }
//    var isExpanded: Bool { get }
    var numberOfSubnodes: Int { get }
    func subnode(at index: Int) -> OutlineViewNodeProtocol 
}
