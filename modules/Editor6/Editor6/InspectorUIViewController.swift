//
//  InspectorUIViewController.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox
import Editor6Common

final class InspectorUIViewController: Editor6CommonViewController {
    
    private var installer = ViewInstaller()

    private func render() {
        installer.installIfNeeded {

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayout() {
        super.viewDidLayout()
        render()
    }
}
