//
//  ProjectSelection.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/24.
//  Copyright © 2017 Eonil. All rights reserved.
//

///
/// Immutable collection of `ProjectItemPath`s
/// which represents selection.
///
protocol ProjectSelection {
    ///
    /// First access allowed to go up to O(n).
    /// Any subsequent access MUST be O(1).
    ///
    var items: [ProjectItemPath] { get }
}
struct AnyProjectSelection: ProjectSelection {
    private let impl: () -> [ProjectItemPath]
    init<T>(_ raw: T) where T: ProjectSelection {
        impl = { raw.items }
    }
    init() {
        impl = { [] }
    }
    var items: [ProjectItemPath] {
        return impl()
    }
}
extension ProjectSelection {
    static var none: AnyProjectSelection {
        return AnyProjectSelection()
    }
}
