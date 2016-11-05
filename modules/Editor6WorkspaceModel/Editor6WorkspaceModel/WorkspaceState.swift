//
//  WorkspaceState.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/17.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

public struct WorkspaceState: ModelState {
    public typealias Mutation = WorkspaceMutation

    public var location = URL?.none
    public var project = ProjectState()
    public var build = BuildState()
    public var debug = DebugState()
    public var issues = [Issue]()

    public init() {}
    public mutating func apply(mutation: WorkspaceMutation) {
        switch mutation {
        case .none:
            break
        case .all(let newState):
            self = newState
        case .location(let newLocation):
            location = newLocation
        case .project(let projectMutation):
            project.apply(mutation: projectMutation)
        case .build(let newBuild):
            build = newBuild
        case .debug(let debugMutation):
            debug.apply(mutation: debugMutation)
        case .issues(let newIssues):
            issues = newIssues
        }
    }
}

public struct BuildState {
    public var isRunningBuild = false
    public var executableReadiness = WorkspaceExecutableReadiness.unknown
}

public enum WorkspaceExecutableReadiness {
    case unknown
    case executableReady
    case executableMissing
}

public struct CompileIssue {
    var description: String
}

public struct Issue {
    var source: IssueSourceID
    var description: String
}
public enum IssueSourceID {
    case cargo
    case rustLanguageServer
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public enum WorkspaceMutation {
    case none
    case all(WorkspaceState)
    case location(URL)
    case project(ProjectMutation)
    case build(BuildState)
    case debug(DebugMutation)
    case issues([Issue])
}

//public extension WorkspaceState {
//    func apply(transaction: ModelTransaction<WorkspaceState>) {
//        self = transaction.to
//    }
//}
