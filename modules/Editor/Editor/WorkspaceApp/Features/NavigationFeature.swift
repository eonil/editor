//
//  NavigationFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

final class NavigationFeature: ServicesDependent {
    private(set) var state = State()
}
extension NavigationFeature {
    struct State {
        var history = History()
        var navigator = NavigatorPane()
        var editing: Content?
    }
    struct NavigatorPane {
        var isVisible = false
        var tool = NavigatorTool.files
    }
//    struct InspectorPane {
//        var isVisible = false
//    }
    struct Panes {
        var left = false
        var right = false
        var centerBottom = false
//        var centerTop = false
    }
    enum NavigatorTool {
        case files
        case issues
        case debug
        case logs
    }
//    enum InspectorTool {
//        case
//    }

    struct Content {
        var path: String
        var type: ContentType
    }
    enum ContentType {
        case unknown
        case texture
        case scene
        case commonMarkdownCode
        case rustCode
        case cargoFile
        case swiftFile
        case h
        case c
        case cpp
        case a
        case o
        case dylib
    }
    struct History {
        var records = [EditingRecord]()
    }
    struct EditingRecord {
        var location: Void
        var content: Content
    }
}
