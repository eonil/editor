//
//  Resources.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

struct Resources {
    enum Storyboard {
        case division
        case navigator
        case fileNavigator
        case issueNavigator
        case utility
        case editor
        case console
    }
}
extension Resources.Storyboard {
    func instantiate() -> NSViewController & WorkspaceFeatureDependent {
        let n = makeFileName()
        let sb = NSStoryboard(name: NSStoryboard.Name(rawValue: n), bundle: .shell)
        let vc = sb.instantiateInitialController()
        return vc as! NSViewController & WorkspaceFeatureDependent
    }
    private func makeFileName() -> String {
        switch self {
        case .division:         return "Division"
        case .navigator:        return "Navigator"
        case .fileNavigator:    return "FileNavigator"
        case .issueNavigator:   return "IssueNavigator"
        case .utility:          return "Utility"
        case .editor:           return "Editor"
        case .console:          return "Console"
        }
    }
}

private extension Bundle {
    static var shell: Bundle {
        return Bundle(for: WorkspaceShell.self)
    }
}
