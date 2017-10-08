//
//  TreeOutlineAdapter2.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/05.
//Copyright © 2017 Eonil. All rights reserved.
//

import EonilTree
import AppKit

final class TreeOutlineAdapter2<Node> {
    typealias IdentityProxy = TreeOutlineAdapter2IdentityProxy<Node>
    private var sourceTree: Tree<Node>?
    private(set) var rootProxy: IdentityProxy?
    private let isFolded: (Tree<Node>) -> Bool

    init(_ initialSourceTree: Tree<Node>?, _ isFolded: @escaping (Tree<Node>) -> Bool) {
        sourceTree = initialSourceTree
        rootProxy = initialSourceTree.flatMap({ IdentityProxy(tree: $0) })
        self.isFolded = isFolded
    }

//    func path(for proxy: IdentityProxy) -> IndexPath? {
//        return rootProxy?.resolvePath()
//    }
    ///
    /// O(depth)
    ///
    func proxy(for path: IndexPath) -> IdentityProxy? {
        return rootProxy?.findNode(at: path)
    }

    ///
    /// This assumes the value `V` in the tree contains expansion state
    /// and gets copied together.
    ///
    func makeSelection(selectedRowIndices: IndexSet) -> Selection {
        guard let sourceTree = sourceTree else { return Selection() }
        return Selection(sourceTree, selectedRowIndices, isFolded)
    }
    
    ///
    /// Applies `muation` to `snapshot` and returns commands for `NSOutlineView`.
    ///
    /// - Note:
    ///     Take care that `replace(_)` works as a full replacement for designted
    ///     node. Which means all descendant proxies will be re-created. This is
    ///     inefficient, and make `NSOutlineView` doesn't work well.
    ///     If you want just light-weight in-place node property update,
    ///     please use `Tree<T>.OptimizedMutation` and apply it to here.
    ///
    @discardableResult
    func applyMutation(_ mutation: Tree<Node>.Mutation, to snapshot: Tree<Node>) -> OutlineViewCommand {
        switch mutation {
        case .insert(let idxp):
            if idxp == .root {
                guard rootProxy == nil else { REPORT_criticalBug("Root proxy must be `nil` now.")}
                rootProxy = IdentityProxy(tree: snapshot)
                return .reload
            }
            else {
                guard let rootProxy = rootProxy else { REPORT_criticalBug("Missing root-proxy and an operation with non-root path received.") }
                return rootProxy.applyMutation(mutation, to: snapshot)
            }

        case .replace(let idxp):
            if idxp == .root {
                guard rootProxy != nil else { REPORT_criticalBug("`replace` operation to root cannot be performed with no root proxy object.") }
                rootProxy = IdentityProxy(tree: snapshot)
                return .reload
            }
            else {
                guard let rootProxy = rootProxy else { REPORT_criticalBug("`replace` operation to root cannot be performed with no root proxy object.") }
                return rootProxy.applyMutation(mutation, to: snapshot)
            }

        case .remove(let idxp):
            if idxp == .root {
                guard rootProxy != nil else { REPORT_criticalBug("Root proxy must not be `nil` now.")}
                rootProxy = nil
                return .reload
            }
            else {
                guard let rootProxy = rootProxy else { REPORT_criticalBug("Missing root-proxy and an operation with non-root path received.") }
                return rootProxy.applyMutation(mutation, to: snapshot)
            }
        }
    }
    
    ///
    /// Applies `muation` to `snapshot` and returns commands for `NSOutlineView`.
    ///
    @discardableResult
    func applyOptimizedMutation(_ mutation: Tree<Node>.OptimizedMutation, to snapshot: Tree<Node>) -> OutlineViewCommand {
        guard let rootProxy = rootProxy else { REPORT_criticalBug("`replaceNode` operation to root cannot be performed with no root proxy object.") }
        return rootProxy.applyOptimizedMutation(mutation, to: snapshot)
    }
}
extension TreeOutlineAdapter2 {
    enum OutlineViewCommand {
        case reload
        case insertItems(children: IndexSet, parent: Any?)
        ///
        /// `NSOutlineView` does not have update-items method.
        /// So you're supposed to implement it yourself.
        ///
        case updateItem(Any?)
        case deleteItems(children: IndexSet, parent: Any?)
    }
    struct Selection: Sequence {
        private let sourceTree: Tree<Node>?
        private let selectedRowIndices: IndexSet
        private let isFolded: (Tree<Node>) -> Bool
        ///
        /// Creates an empty selection.
        ///
        init() {
            sourceTree = nil
            selectedRowIndices = IndexSet()
            isFolded = { _ in false }
        }
        init(_ sourceTree: Tree<Node>, _ selectedRowIndices: IndexSet, _ isFolded: @escaping (Tree<Node>) -> Bool) {
            self.sourceTree = sourceTree
            self.selectedRowIndices = selectedRowIndices
            self.isFolded = isFolded
        }
        func makeIterator() -> AnyIterator<IndexPath> {
            guard let sourceTreeCopy = sourceTree else { return AnyIterator { nil } }
            let isFoldedCopy = isFolded
            var foldedIndexPaths = Set<IndexPath>()
            var idxpLazyDFS = TreeLazyDepthFirstIndexPathIterator(sourceTreeCopy) { idxp, _ in
                guard idxp.isEmpty == false else { return true } // Root always will be included if selected.
                return foldedIndexPaths.contains(idxp.dropLast()) == false
            }
            var resolvedIndexPaths = [IndexPath]()
            //
            // Take care that `IndexSet` is an UNORDERED set, and ordering
            // between iterated indices are not guaranteed.
            // Though they're very likely to be pre-sorted, but that's not
            // guaranteed, and make sure that the code to work properly with
            // unsorted indices too.
            //
            var rowIndices = selectedRowIndices.makeIterator()
            return AnyIterator { () -> IndexPath? in
                guard let rowIndex = rowIndices.next() else { return nil }
                // Resolve index-paths up to the row index.
                // This can be up to O(n) if row indices are not sorted.
                // I just bet on the row indices are very likely to be sorted.
                while (resolvedIndexPaths.count - 1) < rowIndex {
                    guard let idxp = idxpLazyDFS.next() else { REPORT_criticalBug("Next index-path could not be resolved.") }
                    if isFoldedCopy(sourceTreeCopy.at(idxp)) {
                        foldedIndexPaths.insert(idxp)
                    }
                    resolvedIndexPaths.append(idxp)
                }
                return resolvedIndexPaths[rowIndex]
            }
        }
    }
}



///
/// A proxy object which provides referential identity to `NSOutlineView`.
///
final class TreeOutlineAdapter2IdentityProxy<T> {
    private(set) var sourceNode: T
    fileprivate(set) weak var containerProxy: TreeOutlineAdapter2IdentityProxy?
    private(set) var subproxies = [TreeOutlineAdapter2IdentityProxy]()

    init(tree: Tree<T>) {
        sourceNode = tree.node
        for subtree in tree.subtrees {
            let subproxy = TreeOutlineAdapter2IdentityProxy(tree: subtree)
            subproxy.containerProxy = self
            subproxies.append(subproxy)
        }
    }
    ///
    /// O(depth * average width)
    ///
    func resolvePath() -> IndexPath {
        guard let containerProxy = containerProxy else { return [] }
        guard let i = containerProxy.subproxies.index(where: { $0 === self }) else { REPORT_criticalBug("Path to self proxy object due to bad container proxy.") }
        return containerProxy.resolvePath().appending(i)
    }
    ///
    /// O(depth)
    ///
    /// This assumes the `path` is correct. Program crashes for invalid `path`.
    ///
    fileprivate func findNode(at path: IndexPath) -> TreeOutlineAdapter2IdentityProxy {
        if path.isEmpty { return self }
        let (i, subpath) = path.splitFirst()
        return subproxies[i].findNode(at: subpath)
    }
    
    ///
    /// Applies `muation` to `snapshot` and returns commands for `NSOutlineView`.
    ///
    func applyMutation(_ mutation: Tree<T>.Mutation, to snapshot: Tree<T>) -> TreeOutlineAdapter2<T>.OutlineViewCommand {
        switch mutation {
        case .insert(let path):
            precondition(path.isEmpty == false, "You cannot insert at root. Result cannot be defined.")
            let newSubtree = snapshot[path]
            let (containerPath, i) = path.splitLast()
            let containerProxy = findNode(at: containerPath)
            let subproxy = TreeOutlineAdapter2IdentityProxy(tree: newSubtree)
            subproxy.containerProxy = self
            containerProxy.subproxies.insert(subproxy, at: i)
            return .insertItems(children: [i], parent: containerProxy)
            
        case .replace(let path):
            //
            // Basically, this adapter assumes you would notify any
            // insert/remove operations using explicit insert/remove
            // mutations and replace operations to be used only for
            // node data update.
            //
            assert(false, "Please use `replaceNode` mutation signal instead of.")
            //
            // Though we asserted a condition, program should wor as expected.
            // This still produces a correct result, but far more expensive.
            // I don't optimize this because there's no generic way to optimize
            // this to satisfying level (O(1)), so optimization is uselessly
            // complex and not worth to it. Instead force use to use optimized
            // signals. (`Tree.OptimizedMutation.replaceNode`)
            //
            let newSubtree = snapshot[path]
            let containerProxy = path.isEmpty ? self : findNode(at: path)
            containerProxy.sourceNode = newSubtree.node
            containerProxy.subproxies = []
            for subtree in newSubtree.subtrees {
                let subproxy = TreeOutlineAdapter2IdentityProxy(tree: subtree)
                subproxy.containerProxy = self
                containerProxy.subproxies.append(subproxy)
            }
            return .updateItem(self)
            
        case .remove(let path):
            precondition(path.isEmpty == false, "You cannot remove at root. Result cannot be defined.")
            let (containerPath, i) = path.splitLast()
            let containerProxy = findNode(at: containerPath)
            let subproxy = containerProxy.subproxies[i]
            subproxy.containerProxy = nil
            containerProxy.subproxies.remove(at: i)
            return .deleteItems(children: [i], parent: containerProxy)
        }
    }
    
    ///
    /// Applies `muation` to `snapshot` and returns commands for `NSOutlineView`.
    ///
    func applyOptimizedMutation(_ mutation: Tree<T>.OptimizedMutation, to snapshot: Tree<T>) -> TreeOutlineAdapter2<T>.OutlineViewCommand {
        switch mutation {
        case .replaceNode(let path):
            let newNode = snapshot[path].node
            let containerNode = findNode(at: path)
            containerNode.sourceNode = newNode
            return .updateItem(containerNode)
        }
    }
}
