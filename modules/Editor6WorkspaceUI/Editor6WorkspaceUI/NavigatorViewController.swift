//
//  NavigatorViewController.swift
//  Editor6WorkspaceUI
//
//  Created by Hoon H. on 2017/03/05.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import Editor6Common

final class NavigatorViewController: Editor6CommonViewController {
    private let navView = NavigatorView()

    func reload(_ newState: WorkspaceUIState) {
        navView.reload(newState)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navView)
    }
    override func viewDidLayout() {
        super.viewDidLayout()
        navView.frame = view.bounds
    }
}
