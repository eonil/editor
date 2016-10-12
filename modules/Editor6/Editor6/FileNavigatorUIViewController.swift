//
//  FileNavigatorUIViewController.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox
import Editor6Common
import Editor6FileTreeUI

final class FileNavigatorUIViewController: Editor6CommonViewController {
    private let fileNavigator = FileNavigatorUIView()
    private var installer = ViewInstaller()

    private func render() {
        installer.installIfNeeded {
            view.addSubview(fileNavigator)
        }
        fileNavigator.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayout() {
        super.viewDidLayout()
        render()
    }
}
