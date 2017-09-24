//
//  NavigatorVC.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class NavigatorVC: NSTabViewController, WorkspaceFeatureDependent {
    private let file = Resources.Storyboard.fileNavigator.instantiate()
    private let issue = Resources.Storyboard.issueNavigator.instantiate()

    weak var features: WorkspaceFeatures? {
        didSet {
            file.features = features
            issue.features = features
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTabViewItem(NSTabViewItem(viewController: file))
        addTabViewItem(NSTabViewItem(viewController: issue))
    }
}
