//
//  FileNavigatorViewController.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/18.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit
import EonilSignet
import Editor6FileTreeUI

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
        toa.process(.reload(features.project.state.files))
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
    private func processContextMenuSignal(_ s: FileNavigatorMenuCommand) {
        guard let features = features else { return }
        guard let path = getClickedFilePath() else { return }
        guard let idxp = features.project.state.files.index(of: path) else { return }

        switch s {
        case .newFolder:
            let idxp1 = idxp.appendingLastComponent(0)
            features.project.makeFile(at: idxp1, content: .folder)

        case .newFolderWithSelection:
            MARK_unimplemented()

        case .newFile:
            let idxp1 = idxp.appendingLastComponent(0)
            features.project.makeFile(at: idxp1, content: .file)

        case .showInFinder:
            MARK_unimplemented()

        case .delete:
            features.project.deleteFile(at: idxp)
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
        assert(exps.contains(node.key))
        exps.remove(node.key)
    }
    func outlineViewItemDidExpand(_ notification: Notification) {
        // https://developer.apple.com/documentation/appkit/nsoutlineview/1526467-itemdidcollapsenotification?changes=latest_beta
        assert(notification.object as? NSObject === outlineView)
        assert(notification.name == Notification.Name.NSOutlineViewItemDidExpand)
        let item = AUDIT_unwrap(notification.userInfo!["NSObject"])
        let node = item as! TOA.OutlineViewNode
        assert(exps.contains(node.key) == false)
        exps.insert(node.key)
    }
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let v = outlineView.make(withIdentifier: "FileItem", owner: self) as! NSTableCellView
        let node = item as! TOA.OutlineViewNode
        v.imageView?.image = makeIconForNode(node)
        let u = features?.project.makeFileURL(for: node.key)
        v.textField?.stringValue = u?.path ?? ""
//        v.textField?.stringValue = node.key.components.last ?? ""
        return v
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let ov = outlineView else { return }
        let sel = toa.makeSelection(
            selectedRowIndices: ov.selectedRowIndexes,
            isExpanded: { [exps] k, v in
                return exps.contains(k)
            })
        struct PS: ProjectSelection {
            var toasel: TOA.Selection
            var items: [ProjectItemPath] { return toasel.items }
        }
        let ps = PS(toasel: sel)
        features?.project.setSelection(AnyProjectSelection(ps))
    }

    func menuWillOpen(_ menu: NSMenu) {
        setMenuAttributes()
    }






    private func setMenuAttributes() {
        let maybePath = getClickedFilePath()
        let hasPath = maybePath != nil
        ctxm.setCommandEnabled(.newFolder, hasPath)
        ctxm.setCommandEnabled(.newFolderWithSelection, false)
        ctxm.setCommandEnabled(.newFile, hasPath)
        ctxm.setCommandEnabled(.showInFinder, false)
        ctxm.setCommandEnabled(.delete, hasPath)
    }

    private func getClickedFilePath() -> ProjectItemPath? {
        guard let row = outlineView?.clickedRow else { return nil }
        guard row != -1 else { return nil }
        guard let item = outlineView?.item(atRow: row) else { return nil }
        guard let node = item as? TOA.OutlineViewNode else { return nil }
        let path = node.key
        return path
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


