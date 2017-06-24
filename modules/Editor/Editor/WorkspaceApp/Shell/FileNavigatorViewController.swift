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

final class FileNavigatorViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
    private typealias TOA = TreeOutlineAdapter<ProjectFeature.Path, ProjectFeature.NodeKind>
    private let projectTransactionWatch = Relay<ProjectFeature.Transaction>()
    private let toa = TOA()
    @IBOutlet private weak var outlineView: NSOutlineView?
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
        projectTransactionWatch.watch(features.project.transaction)
    }
    ///
    /// Idempotent.
    /// No-op if there's no feature.
    ///
    private func disconnectFromFeatures() {
        guard let features = features else { return }
        projectTransactionWatch.unwatch()
        projectTransactionWatch.delegate = nil
    }

    private func processProjectTransaction(_ tx: ProjectFeature.Transaction) {
        guard let features = features else { REPORT_missingFeaturesAndFatalError() }
        guard let outlineView = outlineView else { MARK_unimplemented() }

        switch tx {
        case .location:
            break
        case .files(let m):
            let c = TOA.Command.apply(features.project.state.files, m)
            let c1 = toa.process(c)
            switch c1 {
            case .reload:
                outlineView.reloadData()
            case .insertItems(let children, let parent):
                DEBUG_log("\(children) \(parent)")
//                DEBUG_log("\(toa.rootNode)")
                outlineView.insertItems(at: children, inParent: parent, withAnimation: [])
//                outlineView.reloadItem(parent, reloadChildren: true)
            case .updateItem(let item):
                outlineView.reloadItem(item, reloadChildren: true)
            case .deleteItems(let children, let parent):
//                outlineView.reloadItem(parent, reloadChildren: true)
                outlineView.removeItems(at: children, inParent: parent, withAnimation: [])
            }
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

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let v = outlineView.make(withIdentifier: "FileItem", owner: self) as! NSTableCellView
        let node = item as! TOA.OutlineViewNode
        v.imageView?.image = makeIconForNode(node)
        v.textField?.stringValue = node.key.components.last ?? ""
        return v
    }

    private func makeIconForNode(_ n: TOA.OutlineViewNode) -> NSImage? {
        guard let features = features else { return nil }
        guard let u = features.project.makeFileURL(for: n.key) else { return nil }
        guard let m = NSImage(contentsOf: u) else { return nil }
        return m
    }
}










