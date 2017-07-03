//
//  FileNavigatorViewController.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/18.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit
import EonilSignet

final class FileNavigatorViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate, NSMenuDelegate {
    private typealias TOA = TreeOutlineAdapter<ProjectFeature.Path, ProjectFeature.NodeKind>
    private let projectTransactionWatch = Relay<ProjectFeature.Change>()
    private let toa = TOA()
    private var exps = Set<ProjectItemPath>() //< Set of keys to expanded nodes.
    @IBOutlet private weak var outlineView: NSOutlineView?

    private let ctxm = FileNavigatorMenuCommand.makeMenu()

    ///
    /// Designate feature to provides actual functionalities.
    /// Settings this to `nil` makes every user interaction
    /// no-op.
    ///
    weak var features: WorkspaceFeatures? {
        willSet {
            disconnectFromFeatures()
        }
        didSet {
            connectToFeatures()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        outlineView?.dataSource = self
        outlineView?.delegate = self
        outlineView?.reloadData()
        outlineView?.menu = ctxm
        ctxm.delegate = self
        ctxm.setDelegateToAllNodes { [weak self] in self?.processContextMenuSignal($0) }
    }
    override func viewWillAppear() {
        super.viewWillAppear()
    }
    override func viewDidDisappear() {
        super.viewDidDisappear()
    }

    ///
    /// Idempotent.
    /// No-op if there's no feature.
    ///
    private func connectToFeatures() {
        guard let features = features else { return }
        projectTransactionWatch.delegate = { [weak self] in self?.processProjectTransaction($0) }
        // Reset TOA.
        toa.process(.apply(features.project.state.files, .reset))
        features.project.changes += projectTransactionWatch
        outlineView?.reloadData()
    }
    ///
    /// Idempotent.
    /// No-op if there's no feature.
    ///
    private func disconnectFromFeatures() {
        guard let features = features else { return }
        features.project.changes -= projectTransactionWatch
        projectTransactionWatch.delegate = nil
    }

    private func processProjectTransaction(_ cx: ProjectFeature.Change) {
        guard let features = features else { REPORT_missingFeaturesAndFatalError() }
        switch cx {
        case .location:
            break

        case .files(let m):
            let c = TOA.Command.apply(features.project.state.files, m)
            let c1 = toa.process(c)
            switch c1 {
            case .reload:
                outlineView?.reloadData()
            case .insertItems(let children, let parent):
                DEBUG_log("\(children) \(parent)")
//                DEBUG_log("\(toa.rootNode)")
                outlineView?.insertItems(at: children, inParent: parent, withAnimation: [])
//                outlineView.reloadItem(parent, reloadChildren: true)
            case .updateItem(let item):
                outlineView?.reloadItem(item, reloadChildren: true)
            case .deleteItems(let children, let parent):
//                outlineView.reloadItem(parent, reloadChildren: true)
                outlineView?.removeItems(at: children, inParent: parent, withAnimation: [])
            }
            
        case .selection:
            break

        case .issues(_):
            break
        }
    }




    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        let node = item as! TOA.OutlineViewNode
        switch node.value {
        case .folder: return true
        case .file: return false
        }
    }
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let node = item as! TOA.OutlineViewNode? {
//            DEBUG_log(node)
//            DEBUG_log(node.children)
//            DEBUG_log(node.children.count)
            return node.children.count
        }
        else {
            return toa.rootNode == nil ? 0 : 1
        }
    }
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let node = item as! TOA.OutlineViewNode? {
            let subnode = node[subnode: index]
            return subnode
        }
        else {
            return toa.rootNode!
        }
    }

    func outlineViewItemDidCollapse(_ notification: Notification) {
        // https://developer.apple.com/documentation/appkit/nsoutlineview/1526467-itemdidcollapsenotification?changes=latest_beta
        assert(notification.object as? NSObject === outlineView)
        assert(notification.name == Notification.Name.NSOutlineViewItemDidCollapse)
        let item = AUDIT_unwrap(notification.userInfo!["NSObject"])
        let node = item as! TOA.OutlineViewNode
//        assert(exps.contains(node.key))
        exps.remove(node.key)
        DEBUG_log("End-user did collapse: \(node.key), exps = \(exps)")
    }
    func outlineViewItemDidExpand(_ notification: Notification) {
        // https://developer.apple.com/documentation/appkit/nsoutlineview/1526467-itemdidcollapsenotification?changes=latest_beta
        assert(notification.object as? NSObject === outlineView)
        assert(notification.name == Notification.Name.NSOutlineViewItemDidExpand)
        let item = AUDIT_unwrap(notification.userInfo!["NSObject"])
        let node = item as! TOA.OutlineViewNode
//        assert(exps.contains(node.key) == false)
        exps.insert(node.key)
        DEBUG_log("End-user did expand: \(node.key), exps = \(exps)")
    }
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let v = outlineView.make(withIdentifier: "FileItem", owner: self) as! NSTableCellView
        let node = item as! TOA.OutlineViewNode
        v.imageView?.image = makeIconForNode(node)
        let u = features?.project.makeFileURL(for: node.key)
        v.textField?.stringValue = u?.lastPathComponent ?? ""
        return v
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let sel = makeSelection() else { return }
        struct PS: ProjectSelection {
            var toasel: TOA.Selection
            var items: [ProjectItemPath] { return toasel.items }
        }
        let ps = PS(toasel: sel)
        features?.project.setSelection(AnyProjectSelection(ps))
    }

    func menuWillOpen(_ menu: NSMenu) {
        DEBUG_log("Clicked row: \(outlineView!.clickedRow)")
        setMenuAttributes()
    }
    private func processContextMenuSignal(_ s: FileNavigatorMenuCommand) {
        DEBUG_log("Clicked row: \(outlineView!.clickedRow)")
        DEBUG_log("Menu command: \(s)")
        guard let features = features else { return }
        guard let path = getClickedFilePath() else { return }
        guard let idxp = features.project.state.files.index(of: path) else { return }

        switch s {
        case .newFolder:
            let idxp1 = idxp.appendingLastComponent(0)
            features.project.makeFile(at: idxp1, content: .folder)
            let (k, _) = AUDIT_unwrap(
                features.project.state.files[idxp],
                "Parent of new node at `\(idxp)` is missing")
            expandNodeImpl(at: k)

        case .newFolderWithSelection:
            MARK_unimplemented()

        case .newFile:
            let idxp1 = idxp.appendingLastComponent(0)
            features.project.makeFile(at: idxp1, content: .file)

        case .showInFinder:
            let ps = getGrabbedFilePathsForContextMenuOperation() ?? []
            let us = ps.flatMap({ features.project.makeFileURL(for: $0) })
            NSWorkspace.shared().activateFileViewerSelecting(us)

        case .delete:
            let ps = getGrabbedFilePathsForContextMenuOperation() ?? []
//            let ps = (makeSelection()?.items ?? []) + [getClickedFilePath()].flatMap({$0})
            let idxps = ps.flatMap({ features.project.state.files.index(of: $0) })
            features.project.deleteFiles(at: idxps)
        }
    }





    private func setMenuAttributes() {
        guard let features = features else { return }
        var ops = Set<FileNavigatorMenuCommand>()
        if let path = getClickedFilePath() {
            ops.formUnion([
                .showInFinder,
                ])
            if path != .root {
                ops.formUnion([
                    .delete
                    ])
            }
            if features.project.state.files[path] == .folder {
                ops.formUnion([
                    .newFolder,
                    .newFolderWithSelection,
                    .newFile,
                    ])
            }
        }
        ctxm.resetEnabledCommands(ops)
    }

    private func expandNodeImpl(at path: ProjectItemPath) {
        guard let n = toa.node(for: path) else { return }
        outlineView?.expandItem(n, expandChildren: false)
        exps.insert(n.key)
        DEBUG_log("Expanded: \(n.key), exps = \(exps)")
    }
    private func collapseNodeImpl(at path: ProjectItemPath) {
        guard let n = toa.node(for: path) else { return }
        outlineView?.collapseItem(n, collapseChildren: false)
        exps.remove(n.key)
        DEBUG_log("Collapsed: \(n.key), exps = \(exps)")
    }
    private func getGrabbedFilePathsForContextMenuOperation() -> [ProjectItemPath]? {
        if let p = getClickedFilePath() {
            let selps = makeSelection()?.items ?? []
            if selps.contains(p) {
                return selps
            }
            else {
                return [p]
            }
        }
        else {
            return makeSelection()?.items
        }
    }
    private func getClickedFilePath() -> ProjectItemPath? {
        guard let row = outlineView?.clickedRow else { return nil }
        guard row != -1 else { return nil }
        guard let item = outlineView?.item(atRow: row) else { return nil }
        guard let node = item as? TOA.OutlineViewNode else { return nil }
        let path = node.key
        return path
    }
    private func makeSelection() -> TOA.Selection? {
        guard let ov = outlineView else { return nil }
        return toa.makeSelection(
            selectedRowIndices: ov.selectedRowIndexes,
            isExpanded: { [exps] k, v in exps.contains(k) })
    }
    private func makeIconForNode(_ n: TOA.OutlineViewNode) -> NSImage? {
        guard let features = features else { return nil }
        guard let u = features.project.makeFileURL(for: n.key) else { return nil }
        guard let m = NSImage(contentsOf: u) else { return nil }
        return m
    }
}

private extension FileNavigatorViewController {

}


