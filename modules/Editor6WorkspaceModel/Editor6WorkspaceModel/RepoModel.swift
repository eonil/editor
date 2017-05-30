//
//  RepoModel.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/04.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper
import Editor6Common
import Editor6Services

public struct RepoState {
    public var location = URL?.none
    public var project = ProjectState()
    public var build = BuildState()
    public var debug = DebugState()
    public var issues = [Issue]()
    public init() {}
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
    case mutateProject(Tree1Mutation<ProjectItemID, ProjectItemState>)
    case mutateIssues(ArrayMutation<Issue>)
    case ADHOC_changeAnythingElse
}


public final class RepoModel {
    private let cargo = CargoModel()
    public private(set) var localState = RepoState()
    public var delegate = ((RepoEvent) -> ())?.none

    public init() {
        cargo.delegate { [weak self] in self?.process(cargoEvent: $0) }
    }
    deinit {
    }

    public var state: RepoState {
        return localState
    }
//    public func addFile(name: String, group: Bool, note: String?, data: Data, at index: Int, in parent: ProjectItemID) throws -> ProjectItemID {
////        let newProjectItemPath = parent.appending(last: name)
////        guard state.project.items[newProjectItemPath] == nil else { throw RepoError.ADHOC_any("A file already exists at the path `\(newProjectItemPath)`.") }
////        guard let newFileURL = localState.getFileSystemURL(forFileAt: newProjectItemPath) else { throw RepoError.ADHOC_any("Cannot resolve file-system URL for path `\(newProjectItemPath)`.") }
////        let newProjectItemState = ProjectItemState()
////        localState.project.items[newProjectItemPath] = newProjectItemState
////        try data.write(to: newFileURL, options: [.atomic])
////        delegate?(.mutateProject(.insert))
////        note(.project(.items(.insert([newProjectItemPath: newProjectItemState]))))
////        return newProjectItemPath
//    }

    public func queue(_ command: RepoCommand) {
        switch command {
        case .relocate(let u):
            localState.location = u
            delegate?(.ADHOC_changeAnythingElse)
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
            localState.build.isRunningBuild = (cargo.state.phase == .busy)
            delegate?(.ADHOC_changeAnythingElse)
        case .issue(let i):
            let eidx = state.issues.endIndex
            let newIssue = i.toRepoIssue()
            localState.issues.append(newIssue)
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













fileprivate extension RepoState {
    func getFileListFile() -> URL? {
        guard let loc = location else { return nil }
        let name = loc.deletingPathExtension().lastPathComponent
        return loc.appendingPathComponent(name).appendingPathExtension("Editor6FileList")
    }
    func getFileSystemURL(forFileAt path: ProjectItemPath) -> URL? {
        guard let u = location else { return nil }
        var u1 = u
        for s in path.segments.dropLast() {
            u1 = u1.appendingPathComponent(s, isDirectory: true)
        }
        if let s = path.segments.last {
            func isGroup() -> Bool {
                guard let linkage = project.items[path]?.linkage else { return false }
                if case .group(_) = linkage { return true }
                return false
            }
            u1 = u1.appendingPathComponent(s, isDirectory: isGroup())
        }
        return u1
    }
}

fileprivate extension ProjectItemPath {
    func getSerialized(isGroup: Bool) -> String? {
        var c = URLComponents()
        c.scheme = "editor6projectitem"
        c.host = "workspace"
        guard let u = c.url else { return nil }
        var u1 = u
        for s in segments.dropLast() {
            u1 = u1.appendingPathComponent(s, isDirectory: true)
        }
        if let s = segments.last {
            u1 = u1.appendingPathComponent(s, isDirectory: isGroup)
        }
        return u1.absoluteString
    }
}
