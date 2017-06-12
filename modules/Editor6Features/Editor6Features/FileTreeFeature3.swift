//
//  FileTreeFeature3.swift
//  Editor6Features
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

import EonilToolbox
import EonilSignet
import Editor6Common
import Editor6Services

public final class FileTreeFeature3 {
    weak var services: Services?
    private let channelImpl = MutableChannel<State>(.init())
    private var signalQueue = SignalQueue<Signal>()

    public var channel: Channel<State> {
        return channelImpl
    }
    public func process(_ s: Signal) {
        signalQueue.queue(s)
        step()
    }
    private func step() {
        guard channelImpl.state.issues.isEmpty else { return }
        while let s = signalQueue.consume() {
            switch s {
            case .apply(let ms):
                // Modify in-memory state first.
                // File-system operations may fail, but it's fine.
                let r = channelImpl.mutateStateTransactionally({ state in state.applying(ms) })
                switch r {
                case .failure(let issue):
                    // Failed due to any reason.
                    channelImpl.state.issues.append(Issue(state: issue))

                case .success(_):
                    // Perform operations on file-system.
                    for m in ms {
                        switch m {
                        case .insert(let n, let i):
                            // Perform I/O.
                            MARK_unimplemented()
                        case .update(let n, let i):
                            // Perform I/O.
                            MARK_unimplemented()
                        case .delete(let n, let i):
                            // Perform I/O.
                            MARK_unimplemented()
                        }
                    }
                }
            }
        }
    }
}

public extension FileTreeFeature3 {
    public struct Issue {
        public let id = ObjectAddressID()
        public let state: String
    }
}
public extension FileTreeFeature3 {
    ///
    /// File-tree state is provided in transition form to
    /// make easy to track changes between states.
    ///
    public struct State {
        public var transition = Transition()
        public var issues = [Issue]()
        func applying(_ ms: [Mutation]) -> Result<State, String> {
            var editingSnapshot = transition.to
            for m in ms {
                switch transition.to.applying(m) {
                case .failure(let issue):
                    return .failure(issue)
                case .success(let solution):
                    editingSnapshot = solution
                }
            }
            var editingState = self
            editingState.transition = Transition(
                from: transition.to,
                to: editingSnapshot,
                by: ms)
            return .success(editingState)
        }
    }
    public typealias Operation = Signal
    public enum Signal {
        case apply([Mutation])
    }
    public enum Mutation {
        case insert(Node, at: Snapshot.Tree.IndexPath)
        case update(Node, at: Snapshot.Tree.IndexPath)
        case delete(Node, at: Snapshot.Tree.IndexPath)
    }
}
public extension FileTreeFeature3 {
    public struct Transition {
        public var from = Snapshot()
        public var to = Snapshot()
        public var by = [Mutation]()
    }
    public struct Snapshot {
        public typealias Tree = Tree2<Path, NodeKind>

        public fileprivate(set) var id = ObjectAddressID()
        public fileprivate(set) var tree = Tree()

        fileprivate init() {
        }
        mutating func apply(_ m: Mutation) -> Result<Void, String> {
            id = ObjectAddressID()
            switch m {
            case .insert(let n, let idxp):
                guard tree[idxp] == nil else { return .failure("A node already exists at location of index-path `\(idxp)`.") }
                tree[idxp] = n
            case .update(let n, let idxp):
                guard tree[idxp] != nil else { return .failure("A node does not exist at location of index-path `\(idxp)`.") }
                tree[idxp] = n
            case .delete(_, let idxp):
                guard tree[idxp] != nil else { return .failure("A node does not exist at location of index-path `\(idxp)`.") }
                tree[idxp] = nil
            }
            return .success(Void())
        }
        func applying(_ m: Mutation) -> Result<Snapshot, String> {
            var editing = self
            switch editing.apply(m) {
            case .failure(let issue):
                return .failure(issue)
            case .success(let solution):
                return .success(editing)
            }
        }
    }
}
public extension FileTreeFeature3 {
    public typealias Node = (id: Path, state: NodeKind)
    public struct Path: Hashable {
        private var core = URL(fileURLWithPath: "./")
        public init(components initialCompoenents: [String]) {
            var u = URL(fileURLWithPath: "./")
            for c in initialCompoenents {
                u = u.appendingPathComponent(c)
            }
            core = u
        }
        public var components: [String] {
            get { return core.pathComponents }
            set { self = Path(components: components) }
        }
        public var hashValue: Int {
            return core.hashValue
        }
        public var isRoot: Bool {
            return components.isEmpty
        }
        public func appendingComponent(_ component: String) -> Path {
            return Path(components: components + [component])
        }
        public func deletingLastComponent() -> Result<Path, String> {
            guard components.isEmpty == false else { return .failure("This is root path(`/`). Cannot delete more.") }
            return .success(Path(components: Array(components.dropLast())))
        }
        public static func == (_ a: Path, _ b: Path) -> Bool {
            return a.components == b.components
        }
        public static var root: Path {
            return Path(components: [])
        }
    }
    public enum NodeKind {
        case file
        case folder
    }
}
public extension FileTreeFeature3.Path {
    public enum ConversionError: Error {
        case nonFileURLUnsupported
        case hasNoRelativeFilePath
    }
    public init(relativeFileURLFromWorkspaceRoot u: URL) throws {
        guard u.isFileURL else { throw ConversionError.nonFileURLUnsupported }
        guard u.path.hasPrefix("./") else { throw ConversionError.hasNoRelativeFilePath }
        self = FileTreeFeature3.Path(components: u.pathComponents)
    }
    public func makeRelativeFileURLFromWorkspaceRoot() -> URL {
        var u = URL(fileURLWithPath: "./")
        for c in components {
            u = u.appendingPathComponent(c)
        }
        return u
    }
}





