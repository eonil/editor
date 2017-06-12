//
//  ProjectTransaction.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import EonilToolbox
import Editor6Common

///
/// Provides extra information to validate
/// operations.
///
/// Usually, operations are state-ful, and when you
/// obtained some operation from external source,
/// it's unclear to performing the operations is
/// safe or not.
///
/// This object provides minimal cost pessimistic
/// validation to such stuff by simply comparing
/// from/to versions. If your state's version is
/// same with `from`, and you're safe to go.
/// If your state's version is not same, just
///
public struct ProjectTransaction {
    public let from: ProjectState
    public let to: ProjectState
    public let operations: [ProjectOperation]
    public init(from: ProjectState, to: ProjectState, operations: [ProjectOperation]) {
        self.from = from
        self.to = to
        self.operations = operations
    }
}
public enum ProjectOperation {
    case insert(parent: ProjectItemID, range: CountableRange<Int>, children: [ProjectItemID])
    case update(parent: ProjectItemID, range: CountableRange<Int>, children: [ProjectItemID])
    case delete(parent: ProjectItemID, range: CountableRange<Int>, children: [ProjectItemID])
}
