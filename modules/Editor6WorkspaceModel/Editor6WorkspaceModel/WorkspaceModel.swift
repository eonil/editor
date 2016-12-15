//
//  WorkspaceModel.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/17.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import Flow

public enum WorkspaceError: Error {
    case missingSelf
    case missingDelegate
    case any(String)
    init(_ s: String) {
        self = .any(s)
    }
}

/// `WorkspaceModel` is an independent actor.
/// This manages non-UI stuffs. 
/// Soley interacts with `Driver`.
///
public final class WorkspaceModel {
    private var delegate = ((WorkspaceNotification) -> ())?.none
    private var local = Local()

    public let debug = DebugModel()

    public init() {
        debug.delegate { [weak self] in self?.process($0) }
//        cargo.delegate { [weak self] in self?.process($0) }
//        debug.delegate { [weak self] (n: DebugNotification) in
//        }
    }
    func delegate(to newDelegate: @escaping (WorkspaceNotification) -> ()) {
        delegate = newDelegate
    }

    fileprivate typealias NoteMutation = (WorkspaceMutation) -> ()
    fileprivate typealias CompleteOperation<T> = (Result<T>) -> ()
    fileprivate typealias PerformOperation<T> = (_ local: inout Local, _ note: NoteMutation) -> (T)
    fileprivate typealias PerformAsyncOperation<T> = (_ local: inout Local, _ note: NoteMutation, _: @escaping CompleteOperation<T>) -> ()
    fileprivate func queueOperation<T>(_ perform: @escaping PerformAsyncOperation<T>) -> Future<T> {
        guard let delegate = delegate else { return Future(error: WorkspaceError.missingDelegate) }
        let f = Future<T>()
        delegate(.queue({ [weak self] in
            guard let s = self else {
                f.signal(.error(WorkspaceError.missingSelf))
                return
            }
            guard let delegate = s.delegate else {
                f.signal(.error(WorkspaceError.missingDelegate))
                return
            }
            var mutations = [WorkspaceMutation]()
            let note: NoteMutation = { mutations.append($0) }
            // 2. Delegate completion next.
            let complete: CompleteOperation<T> = { r in delegate(.queue({ f.signal(r) })) }
            let from = s.local.state
            perform(&s.local, note, complete)
            let to = s.local.state
            let by = mutations
            let t = ModelTransaction<WorkspaceState>(from: from, to: to, by: by)
            // 1. Delegate transaction first.
            delegate(.apply(t))
        }))
        return f
    }
    private func process(_ n: DebugNotification) {
        switch n {
        case .apply(let t):
            let from1 = local.state
            local.state.debug = t.to
            let to1 = local.state
            let by1 = t.by.map(WorkspaceMutation.debug)
            let t1 = ModelTransaction<WorkspaceState>(from: from1, to: to1, by: by1)
            delegate?(.apply(t1))
        case .queue(let continuation):
            delegate?(.queue(continuation))
        }
    }
}

public extension WorkspaceModel {
    /// Initialze a new workspace directory and open it.
    public func ADHOC_make(at location: URL) -> Future<()> {
        return queueOperation { local, note, complete in
            local.cargo.queue(CargoCommand.new(location))
        }
    }
    /// Purge in-memory workspace data and reload all from a new location.
    /// This method is no-op if new location is same with old location.
    public func relocate(_ newLocation: URL) -> Future<()> {
        return queueOperation { local, note, complete in
            guard local.state.location != newLocation else { return complete(.cancel) }
            local.state.location = newLocation
            note(.location(newLocation))
            complete(.ok(()))
        }.step(to: { [weak self] (_: ()) -> Future<()> in
            guard let s = self else { return Future(error: WorkspaceError.missingSelf) }
            return s.reloadProjectItems()
        })
    }
    public func addFile(name: String, group: Bool, note: String?, data: Data, at index: Int, in parent: ProjectItemID) -> Future<ProjectItemID> {
        return queueOperation { local, note, complete in
            let newProjectItemPath = parent.appending(last: name)
            Future {
                guard local.state.project.items[newProjectItemPath] == nil else { throw WorkspaceError("An file already exists at the path `\(newProjectItemPath)`.") }
                guard let newFileURL = local.state.getFileSystemURL(forFileAt: newProjectItemPath) else { throw WorkspaceError("Cannot resolve file-system URL for path `\(newProjectItemPath)`.") }
                let newProjectItemState = ProjectItemState()
                local.state.project.items[newProjectItemPath] = newProjectItemState
                try data.write(to: newFileURL, options: [.atomic])
                note(.project(.items(.insert([newProjectItemPath: newProjectItemState]))))
                return newProjectItemPath
            }.step(complete)
        }
    }
    public func removeFile(id: ProjectItemID) -> Future<()> {
        return queueOperation { local, note, complete in
            /// NOSHIP: Incomplete...
            MARK_unimplemented()
        }
    }

    /// Reload all project items from current workspace location.
    /// This always performs reloading naively.
    private func reloadProjectItems() -> Future<()> {
        return queueOperation { local, note, complete in
            MARK_unimplemented()
        }
    }
    private func persistProjectItems() -> Future<()> {
        return queueOperation { local, note, complete in
            guard let u = local.state.getFileListFile() else { return complete(.error(WorkspaceError("Bad location URL `\(local.state.location)`. Cannot produce a file-list file URL."))) }
            let projectItems = local.state.project.items

            Future(ok: ()).transfer(to: DispatchQueue.global(qos: .background)).step({ () throws -> () in
                var ss = [String]()
                for (id, state) in projectItems {
                    func isGroup() -> Bool {
                        if case .group(_) = state.linkage { return true }
                        return false
                    }
                    guard let s = id.getSerialized(isGroup: isGroup()) else { throw WorkspaceError("Cannot serialize project item `(\(id),\(state))`.") }
                    ss.append(s)
                }
                let t = ss.joined(separator: "\n")
                guard let d = t.data(using: .utf8) else { throw WorkspaceError("Cannot encode into UTF-8 string `\(t)`.") }
                try d.write(to: u, options: .atomic)
                return ()
            }).step({ (r: Result<()>) -> () in
                complete(r)
            })
        }
    }
}

fileprivate extension WorkspaceState {
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

fileprivate struct Local {
//    private let files =
    let debug = DebugModel()
    let cargo = Cargo()
    let rls = RustLanguageServer()
    var state = WorkspaceState()
}

private extension CargoError {
    func toIssue() -> Issue {
        return Issue(source: .cargo, description: localizedDescription)
    }
}

