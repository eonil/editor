//
//  TestdriveViewController.swift
//  Editor5FileTreeUI
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import Editor5Common
import Editor5FileTreeUI

final class TestdriveViewController: Editor5CommonViewController {
    private let v = FileNavigatorUIView()
    private var s = FileNavigatorUIState()

    override func loadView() {
        view = NSView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(v)

        s.tree[s.tree.root.id].name = "root!"
        var state1 = FileNavigatorUINodeState()
        state1.name = "A"

        let id1 = s.tree.insert(state1, at: 0, in: s.tree.root.id)
        let id2 = s.tree.insert(state1, at: 0, in: s.tree.root.id)
        s.tree.insert(state1, at: 0, in: s.tree.root.id)
        s.tree.insert(state1, at: 0, in: s.tree.root.id)
        s.tree.insert(state1, at: 0, in: s.tree.root.id)

        s.tree.insert(state1, at: 0, in: id1)
        s.tree.insert(state1, at: 0, in: id1)
        s.tree.insert(state1, at: 0, in: id1)
        s.tree.insert(state1, at: 0, in: id1)
        s.tree.insert(state1, at: 0, in: id1)

        s.tree.insert(state1, at: 0, in: id2)
        s.tree.insert(state1, at: 0, in: id2)
        s.tree.insert(state1, at: 0, in: id2)
        s.tree.insert(state1, at: 0, in: id2)
        s.tree.insert(state1, at: 0, in: id2)

        v.reload(state: s)
    }
    override func viewDidLayout() {
        super.viewDidLayout()
        v.frame = view.bounds
    }
}

