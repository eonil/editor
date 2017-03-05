//
//  RepoModel.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/04.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import Editor6Common

public struct RepoState {
    public var location = URL?.none
    public var project = ProjectState()
    public var build = BuildState()
    public var debug = DebugState()
    public var issues = [Issue]()
}

public enum RepoCommand {
    case relocate(URL)
    case `init`
    case product(RepoProductCommand)
}
public enum RepoFileCommand {
    case addNewFile
    case addNewFolder
    case deleteFile
}
public enum RepoProductCommand {
    case clean
    case build
    case run
}
public enum RepoEvent {
    case ADHOC_changeAny
    case mutateIssues(ArrayMutation<Issue>)
}


public final class RepoModel {
    private let cargo = CargoModel()
    public private(set) var state = RepoState()
    public var delegate = ((RepoEvent) -> ())?.none

    public init() {
        cargo.delegate { [weak self] in self?.process(cargoEvent: $0) }
    }
    deinit {
    }

    public func queue(_ command: RepoCommand) {
        switch command {
        case .relocate(let u):
            state.location = u
        case .init:
            guard let u = state.location else { MARK_resultUndefined() }
            cargo.queue(.init(u))
        case .product(let c):
            switch c {
            case .build:
                guard let u = state.location else { MARK_resultUndefined() }
                cargo.queue(.build(u))
            case .clean:
                guard let u = state.location else { MARK_resultUndefined() }
                cargo.queue(.clean(u))
            case .run:
                MARK_unimplemented()
            }
        }
    }

    private func process(cargoEvent e: CargoEvent) {
        switch e {
        case .phase:
            state.build.isRunningBuild = (cargo.state.phase == .busy)
            delegate?(.ADHOC_changeAny)
        case .issue(let i):
            let eidx = state.issues.endIndex
            let newIssue = i.toRepoIssue()
            state.issues.append(newIssue)
            delegate?(.mutateIssues(.insert(eidx..<(eidx+1), [newIssue])))
        case .error(let e):
            debugLog(e)
            MARK_unimplementedButSkipForNow()
        }
    }
}

private extension CargoIssue {
    func toRepoIssue() -> Issue {
        return Issue(source: .cargo, description: "\(self)")
    }
}
