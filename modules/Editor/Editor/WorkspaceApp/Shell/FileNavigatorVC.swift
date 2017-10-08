//
//  FileNavigatorVC.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit
import EonilSignet

final class FileNavigatorVC: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate, NSMenuDelegate, NSTextFieldDelegate, WorkspaceFeatureDependent {
    private typealias TOA = TreeOutlineAdapter2<ProjectFeature.FileNode>
    private let projectTransactionWatch = Relay<[ProjectFeature.Change]>()
    private let toa = TOA(ProjectFeature.FileTree(node: .root)) { subtree in subtree.node.isFolded }
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
        outlineView?.target = self
        outlineView?.action = #selector(userDidClickOnOutlineViewCellOrColumnHeader)
        outlineView?.doubleAction = #selector(userDidDoubleClickOnOutlineViewCellOrColumnHeader)
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
        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
        projectTransactionWatch.delegate = { [weak self] in self?.processProjectTransaction($0) }
        // Reset TOA.
        toa.applyMutation(.replace(at: []), to: features.project.state.files)
        features.project.changes += projectTransactionWatch
        outlineView?.reloadData()
    }
    ///
    /// Idempotent.
    /// No-op if there's no feature.
    ///
    private func disconnectFromFeatures() {
        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
        features.project.changes -= projectTransactionWatch
        projectTransactionWatch.delegate = nil
    }

    private func processProjectTransaction(_ cs: [ProjectFeature.Change]) {
        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
        func applyOutlineViewCommand(_ oc: TOA.OutlineViewCommand) {
            switch oc {
            case .reload:
                outlineView?.reloadData()
            case .insertItems(let children, let parent):
                outlineView?.insertItems(at: children, inParent: parent, withAnimation: [])
//                outlineView.reloadItem(parent, reloadChildren: true)
            case .updateItem(let item):
                outlineView?.reloadItem(item, reloadChildren: true)
            case .deleteItems(let children, let parent):
//                outlineView.reloadItem(parent, reloadChildren: true)
                outlineView?.removeItems(at: children, inParent: parent, withAnimation: [])
            }
        }
        for c in cs {
            switch c {
            case .files(let mutation):
                let oc = toa.applyMutation(mutation, to: features.project.state.files)
                applyOutlineViewCommand(oc)
                
            case .filesOptimized(let optimizedMutation):
                let oc = toa.applyOptimizedMutation(optimizedMutation, to: features.project.state.files)
                applyOutlineViewCommand(oc)
                
            default:
                break
            }
        }
    }


    


    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        let proxy = item as! TOA.IdentityProxy
        switch proxy.sourceTree.node.kind {
        case .folder: return true
        case .file: return false
        }
    }
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let proxy = item as! TOA.IdentityProxy? {
            return proxy.subproxies.count
        }
        else {
            return 1
        }
    }
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let proxy = item as! TOA.IdentityProxy? {
            return proxy.subproxies[index]
        }
        else {
            guard let rootProxy = toa.rootProxy else { REPORT_criticalBug("`NSOutlineView` in file-navigator VC wants a top level node at a certain index, but root-proxy is missing now.") }
            return rootProxy
        }
    }

    func outlineViewItemDidCollapse(_ notification: Notification) {
        // https://developer.apple.com/documentation/appkit/nsoutlineview/1526467-itemdidcollapsenotification?changes=latest_beta
        assert(notification.object as? NSObject === outlineView)
        assert(notification.name == NSOutlineView.itemDidCollapseNotification)
        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
        let item = AUDIT_unwrap(notification.userInfo!["NSObject"])
        let proxy = item as! TOA.IdentityProxy
        let idxp = proxy.resolvePath()
        features.process(.project(.setNodeFoldingState(at: idxp, isFolded: true)))
    }
    func outlineViewItemDidExpand(_ notification: Notification) {
        // https://developer.apple.com/documentation/appkit/nsoutlineview/1526467-itemdidcollapsenotification?changes=latest_beta
        assert(notification.object as? NSObject === outlineView)
        assert(notification.name == NSOutlineView.itemDidExpandNotification)
        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
        let item = AUDIT_unwrap(notification.userInfo!["NSObject"])
        let proxy = item as! TOA.IdentityProxy
        let idxp = proxy.resolvePath()
        features.process(.project(.setNodeFoldingState(at: idxp, isFolded: false)))
    }
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let v = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FileItem"), owner: self) as! NSTableCellView
        let proxy = item as! TOA.IdentityProxy
        v.imageView?.image = makeIconForNode(proxy)
        v.textField?.stringValue = proxy.sourceTree.node.name
        v.textField?.delegate = self
        return v
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
        let outlineSelection = makeOutlineSelection()
        let newProjectSelection = features.project.makeSelection(with: outlineSelection)
        features.process(.project(.setSelection(to: newProjectSelection)))
    }

    func menuWillOpen(_ menu: NSMenu) {
        DEBUG_log("Clicked row: \(outlineView!.clickedRow)")
        setMenuAttributes()
    }
    private func processContextMenuSignal(_ s: FileNavigatorMenuCommand) {
        DEBUG_log("Clicked row: \(outlineView!.clickedRow)")
        DEBUG_log("Menu command: \(s)")
        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
        guard let idxp = getIndexPathToClickedFile() else { return }
        switch s {
        case .newFolder:
            let new_idxp = idxp.appending(0)
            features.process(.project(.makeFile(at: new_idxp, as: .folder)))
            expandNodeImpl(at: new_idxp)

        case .newFolderWithSelection:
            MARK_unimplemented()

        case .newFile:
            let new_idxp = idxp.appending(0)
            features.process(.project(.makeFile(at: new_idxp, as: .file)))

        case .showInFinder:
            let grabbedIndexPaths = getIndexPathsToGrabbedFilesForContextMenuOperation() ?? []
            let urls = grabbedIndexPaths.flatMap({ features.project.makeURLForFile(at: $0).successValue })
            // TODO: Make external I/O to be done in services.
            NSWorkspace.shared.activateFileViewerSelecting(urls)

        case .delete:
            let grabbedIndexPaths = getIndexPathsToGrabbedFilesForContextMenuOperation() ?? []
            let newProjectSelection = features.project.makeSelection(with: grabbedIndexPaths)
            features.process(.project(.setSelection(to: newProjectSelection)))
            features.process(.project(.deleteSelectedFiles))
        }
    }



    @objc
    private func userDidClickOnOutlineViewCellOrColumnHeader() {
        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
        guard let idxp = getIndexPathToClickedFile() else { return }
        if let fileURL = features.project.makeURLForFile(at: idxp).successValue {
            features.process(.codeEditing(.open(fileURL)))
        }

        guard let outlineView = outlineView else { return }
        let rowIndex = outlineView.clickedRow
        guard rowIndex != -1 else { return }
        guard outlineView.window?.firstResponder === outlineView else { return }
        guard let cellView = outlineView.view(atColumn: 0, row: rowIndex, makeIfNecessary: false) as? NSTableCellView else { return }
        cellView.textField?.isEditable = true
        // Don't make it first-responder. If you do it, it starts editing
        // immediately instead of having some delay.
    }
    @objc
    private func userDidDoubleClickOnOutlineViewCellOrColumnHeader() {
        MARK_unimplemented()
    }

    override func controlTextDidEndEditing(_ obj: Notification) {
        guard let features = features else { return }
        guard let outlineView = outlineView else { return }
        let rowIndex = outlineView.selectedRow
        guard rowIndex != -1 else { return }
        guard let cellView = outlineView.view(atColumn: 0, row: rowIndex, makeIfNecessary: false) as? NSTableCellView else { return }
        guard obj.object as AnyObject? === cellView.textField else { return }
        guard let newName = cellView.textField?.stringValue else { return }
        guard let proxy = outlineView.item(atRow: rowIndex) as? TOA.IdentityProxy else { return }
        let idxp = proxy.resolvePath()
        features.process(.project(.renameFile(at: idxp, with: newName)))
    }




    private func setMenuAttributes() {
        var ops = Set<FileNavigatorMenuCommand>()
        if let idxp = getIndexPathToClickedFile() {
            ops.formUnion([
                .showInFinder,
                ])
            if idxp != [] {
                ops.formUnion([
                    .delete
                    ])
            }
            if let rootProxy = toa.rootProxy, rootProxy.sourceTree[idxp].node.kind == .folder {
                ops.formUnion([
                    .newFolder,
                    .newFolderWithSelection,
                    .newFile,
                    ])
            }
        }
        ctxm.resetEnabledCommands(ops)
    }

    private func expandNodeImpl(at idxp: IndexPath) {
        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
        guard let outlineView = outlineView else { REPORT_missingIBOutletViewAndFatalError() }
        guard let proxy = toa.proxy(for: idxp) else { return }
        outlineView.expandItem(proxy, expandChildren: false)
        features.process(.project(.setNodeFoldingState(at: idxp, isFolded: false)))
    }
    private func collapseNodeImpl(at idxp: IndexPath) {
        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
        guard let outlineView = outlineView else { REPORT_missingIBOutletViewAndFatalError() }
        let proxy = toa.proxy(for: idxp)
        outlineView.collapseItem(proxy, collapseChildren: false)
        features.process(.project(.setNodeFoldingState(at: idxp, isFolded: true)))
    }
    private func getIndexPathsToGrabbedFilesForContextMenuOperation() -> [IndexPath]? {
        if let p = getIndexPathToClickedFile() {
            let selps = makeOutlineSelection().toArray()
            if selps.contains(p) {
                return selps
            }
            else {
                return [p]
            }
        }
        else {
            return makeOutlineSelection().toArray()
        }
    }
    private func getIndexPathToClickedFile() -> IndexPath? {
        guard let row = outlineView?.clickedRow else { return nil }
        guard row != -1 else { return nil }
        guard let proxy = outlineView?.item(atRow: row) as? TOA.IdentityProxy else { return nil }
        let path = proxy.resolvePath()
        return path
    }
    private func makeOutlineSelection() -> TOA.Selection {
        guard let ov = outlineView else { return TOA.Selection() }
        return toa.makeSelection(selectedRowIndices: ov.selectedRowIndexes)
    }
    private func makeIconForNode(_ n: TOA.IdentityProxy) -> NSImage? {
        guard let features = features else { return nil }
        let idxp = n.resolvePath()
        guard let u = features.project.makeURLForFile(at: idxp).successValue else { return nil }
        guard let m = NSImage(contentsOf: u) else { return nil }
        return m
    }
}

