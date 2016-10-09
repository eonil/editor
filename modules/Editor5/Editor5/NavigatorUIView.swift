//
//  NavigatorUIView.swift
//  Editor5
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import Editor5Common

struct NavigatorUIState {
    var file = ()
    var issue = ()
    var debug = ()
    var log = ()
}

struct DebugNavigatorUIState {

}

struct IssueNavigatorUIState {

}

struct LogNavigatorUIState {

}

final class NavigatorUIView: Editor5CommonView {
    override func editor5_layoutSubviews() {
        super.editor5_layoutSubviews()
    }
}
