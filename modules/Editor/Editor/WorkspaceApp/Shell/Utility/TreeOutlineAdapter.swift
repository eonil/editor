//
//  TreeOutlineAdapter.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/21.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Buckets

///
/// Convert value/state based tree to object/reference based tree.
///
/// This is designed for `NSOutlineView`.
///
/// Rendering `NSOutlineView`
/// -------------------------
/// - Get root node object from `rootNode` property.
/// - You can obtain source key, value and child keys from the node object.
/// - You can obtain subnode object by calling subscript with an index.
///   Number of subnodes is equal with number of children.
/// - Identity of returning subnode is equal for same key until it gets deleted.
///   `NSOutlineView` provides better UX if same reference if used for
///   same node, and this should play well with that.
///
/// Mutating `NSOutlineView`
/// ------------------------
/// - Input data by calling `process` function.
/// - The method returns a command for outline-view.
/// - Apply the command to outline-view.
/// - Note that `NSOutlineView` does not support "update" operation.
///   You are supposed to implement it yourself. Especially in view-
///   based outline view.
///
/// Though you can use this with cell-based outline-view, this isn't
/// designed for cell-based outline-view and does not provide 
/// expected features.
///
final class TreeOutlineAdapter<K,V> where K: Hashable {
    private(set) var snapshot = Snapshot()
    fileprivate var idToNodeMapping = [K: OutlineViewNode]()
    private(set) var rootNode: OutlineViewNode?

    ///
    /// This assumes the value `V` in the tree contains expansion state
    /// and gets copied together.
    ///
    func makeSelection(selectedRowIndices: IndexSet, isExpanded: @escaping (K, V) -> Bool) -> Selection {
        return Selection(snapshot: snapshot, selectedRowIndices: selectedRowIndices, isExpanded: isExpanded)
    }
    func node(for k: K) -> OutlineViewNode? {
        return idToNodeMapping[k]
    }

    @discardableResult
    func process(_ c: Command) -> OutlineViewCommand {
        switch c {
        case .apply(let newSnapshot, let mutation):
            func makePositionInOutlineView(indexPath: Snapshot.IndexPath) -> (children: IndexSet, parent: OutlineViewNode?) {
                if indexPath == .root {
                    let idxs = IndexSet(integer: 0)
                    return (idxs, nil)
                }
                else {
                    let i = indexPath.components.last!
                    let idxs = IndexSet(integer: i)
                    let parentIndexPath = indexPath.deletingLastComponent()
                    do {
                        // As only one node can be inserted/deleted,
                        // the parent node MUST exist.
                        let parent = snapshot[parentIndexPath]!
                        let (k, _) = parent
                        let n = idToNodeMapping[k]!
                        return (idxs, n)
                    }
                }
            }
            func updateParentNodeIfPossible(at indexPath: Snapshot.IndexPath) {
                guard indexPath != .root else { return }
                let pidxp = indexPath.deletingLastComponent()
                let (pk, _) = newSnapshot[pidxp]!
                let pcs = newSnapshot.children(of: pk)!
                let pn = idToNodeMapping[pk]!
                pn.children = pcs
            }
            switch mutation {
            case .reset:
                // Prepare.
                let oldKeys = Set(idToNodeMapping.keys)
                let newKeys = Set(newSnapshot.keys)
                let keysToInsert = newKeys.subtracting(oldKeys)
                let keysToUpdate = oldKeys.intersection(newKeys)
                let keysToDelete = oldKeys.subtracting(newKeys)
                // Update.
                snapshot = newSnapshot
                for k in keysToInsert {
                    assert(idToNodeMapping[k] == nil)
                    let v = newSnapshot[k]!
                    let cs = newSnapshot.children(of: k)!
                    let n = OutlineViewNode(k, v, cs)
                    n.adapter = self
                    idToNodeMapping[k] = n
                }
                for k in keysToUpdate {
                    assert(idToNodeMapping[k] != nil)
                    let n = idToNodeMapping[k]!
                    let v = newSnapshot[k]!
                    let cs = newSnapshot.children(of: k)!
                    n.key = k
                    n.value = v
                    n.children = cs
                }
                for k in keysToDelete {
                    assert(idToNodeMapping[k] != nil)
                    idToNodeMapping[k] = nil
                }
                if let root = newSnapshot[Snapshot.IndexPath.root] {
                    let (k, v) = root
                    let n = idToNodeMapping[k]!
                    rootNode = n
                }
                else {
                    rootNode = nil
                }
                return .reload

            case .insert(let idxp):
                let (k, v) = newSnapshot[idxp]!
                snapshot[idxp] = (k, v)
                let cs = newSnapshot.children(of: k)!
                let n = OutlineViewNode(k, v, cs)
                n.adapter = self
                idToNodeMapping[k] = n
                let (c, p) = makePositionInOutlineView(indexPath: idxp)
                if idxp == .root {
                    rootNode = n
                }
                // Also update parent node.
                updateParentNodeIfPossible(at: idxp)
                return .insertItems(children: c, parent: p)
                
            case .update(let idxp):
                let (k, v) = newSnapshot[idxp]!
                snapshot[idxp] = (k, v)
                let n = idToNodeMapping[k]!
                let cs = newSnapshot.children(of: k)!
                n.key = k
                n.value = v
                n.children = cs
//                let (c, p) = makePositionInOutlineView(indexPath: idxp)
//                return .updateItems(children: c, parent: p)
                return .updateItem(n)

            case .delete(let idxp):
                // New snapshot does not have 
                // node information for the index path.
                let (k, _) = snapshot[idxp]!
                snapshot[idxp] = nil
//                let n = idToNodeMapping[k]!
                idToNodeMapping[k] = nil
                let (c, p) = makePositionInOutlineView(indexPath: idxp)
                if idxp == .root {
                    rootNode = nil
                }
                // Also update parent node.
                updateParentNodeIfPossible(at: idxp)
                return .deleteItems(children: c, parent: p)
            }
        }
    }
}
extension TreeOutlineAdapter {
    typealias Snapshot = Tree2<K,V>
    typealias Mutation = Tree2Mutation<K,V>

    enum Command {
//        case reload(Snapshot)
        case apply(Snapshot, Tree2Mutation<K,V>)
    }
}
extension TreeOutlineAdapter {
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
    class OutlineViewNode {
        weak var adapter: TreeOutlineAdapter?
        fileprivate(set) var key: K
        fileprivate(set) var value: V
        fileprivate(set) var children: [K]
        fileprivate init(_ k: K, _ v: V, _ cs: [K]) {
            key = k
            value = v
            children = cs
        }
        subscript(subnode index: Int) -> OutlineViewNode {
            // Capture `adapter` weakly.
            guard let adapter = adapter else { fatalError("Owner `TreeAdapater` has been dead.") }
            let k = children[index]
            return adapter.idToNodeMapping[k]!
        }
    }
}
extension TreeOutlineAdapter {
    ///
    /// Lazily resolving selection.
    ///
    /// `NSOutlineView` provides index-set of selected rows.
    /// Resolving this indices into keys for each mutation takes too expensive.
    /// This just copies the snapshot and indices and resolve them on-demand.
    ///
    /// This resolution is not required in most cases. So resolution cost
    /// can be avoided.
    /// As all collections in Swift are employing copy-on-write, 
    /// copying cost should not be significant and O(n) at worst.
    /// If O(n) at worst is unacceptable, consider updating tree's
    /// internal dictionary with B-tree based one. Anyway, do this
    /// only when your data-set is larger then CPU cache-line.
    ///
    /// This implementation assumes `IndexSet` from `NSOutlineView.selectedRows` 
    /// is very efficient to copy. It should...
    ///
    struct Selection {
        private let impl: Impl
        init(snapshot: Snapshot, selectedRowIndices: IndexSet, isExpanded: @escaping (K, V) -> Bool) {
            impl = Impl(snapshot, selectedRowIndices, isExpanded)
        }
        var items: [K] {
            return impl.result
        }
        final class Impl {
            let snapshot: Snapshot
            let selectedRowIndices: IndexSet
            let isExpanded: (K, V) -> Bool
            private var cachedResult: [K]?
            init(_ ss: Snapshot, _ ridxs: IndexSet, _ expdet: @escaping (K, V) -> Bool) {
                snapshot = ss
                selectedRowIndices = ridxs
                isExpanded = expdet
            }
            var result: [K] {
                return cachedResult ?? makeResult()
            }
            private func makeResult() -> [K] {
                if let (k, _) = snapshot[Snapshot.IndexPath.root] {
                    // Has root.
                    var visibleRowKeys = [K]()
                    collectVisibleKeys(at: k, &visibleRowKeys)
                    DEBUG_log("\(visibleRowKeys)")
                    let selectedRowKeys = selectedRowIndices.map({ visibleRowKeys[$0] })
                    DEBUG_log("\(selectedRowKeys)")
                    return selectedRowKeys
                }
                else {
                    // No root. Tree is empty.
                    return []
                }
            }
            ///
            /// Perform DFS to collect keys to visible rows in order.
            ///
            private func collectVisibleKeys(at k: K, _ bucket: inout [K]) {
                bucket.append(k)
                let v = snapshot[k]!
                let exp = isExpanded(k, v)
                if exp {
                    let cs = snapshot.children(of: k)!
                    for c in cs {
                        collectVisibleKeys(at: c, &bucket)
                    }
                }
            }
        }
    }
}
extension TreeOutlineAdapter: CustomStringConvertible {
    var description: String {
        return "\(String(describing: rootNode))"
    }
}
extension TreeOutlineAdapter.OutlineViewNode: CustomStringConvertible {
    var description: String {
        func linewiseIndent(_ s: String) -> String {
            let lns = s.components(separatedBy: "\n")
            return lns.map({ "- " + $0 }).joined(separator: "\n")
        }
        let s = "\(key): \(value)"
        let ss = (0..<children.count)
            .map({ self[subnode: $0] })
            .map({ "\($0)" })
            .map(linewiseIndent)
        return s + "\n" + ss.joined(separator: "\n")
    }
}
