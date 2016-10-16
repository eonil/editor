//
//  TestdriveViewController.swift
//  Editor6FileTreeUI
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import Editor6Common
import Editor6FileTreeUI

final class TestdriveViewController: Editor6CommonViewController {
    private let v = FileNavigatorUIView()
    private var s = FileNavigatorUIState()

    private func process(_ e: FileNavigatorUIEvent) {
        switch e {
        case .changeSelection:
            print(v.selection.map({ s.tree[$0].name }))
//            print(Array(v.selection).count)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.addSubview(v)
        v.delegate = { [weak self] in self?.process($0) }

        s.tree[s.tree.root.id].name = "root!"

        let id1 = s.tree.insert(makeState1(), at: 0, in: s.tree.root.id)
        let id2 = s.tree.insert(makeState1(), at: 0, in: s.tree.root.id)
        s.tree.insert(makeState1(), at: 0, in: s.tree.root.id)
        s.tree.insert(makeState1(), at: 0, in: s.tree.root.id)
        s.tree.insert(makeState1(), at: 0, in: s.tree.root.id)

        s.tree.insert(makeState1(), at: 0, in: id1)
        s.tree.insert(makeState1(), at: 0, in: id1)
        s.tree.insert(makeState1(), at: 0, in: id1)
        s.tree.insert(makeState1(), at: 0, in: id1)
        s.tree.insert(makeState1(), at: 0, in: id1)

        s.tree.insert(makeState1(), at: 0, in: id2)
        s.tree.insert(makeState1(), at: 0, in: id2)
        s.tree.insert(makeState1(), at: 0, in: id2)
        s.tree.insert(makeState1(), at: 0, in: id2)
        s.tree.insert(makeState1(), at: 0, in: id2)

        v.reload(state: s)
    }
    override func viewDidLayout() {
        super.viewDidLayout()
        v.frame = view.bounds
    }
}

private var seed = 0
private func makeState1() -> FileNavigatorUINodeState {
    seed += 1
    var state1 = FileNavigatorUINodeState()
    state1.name = "A\(seed)"
    return state1
}
