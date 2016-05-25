//
//  FileNavigatorViewController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/20.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit
import EonilToolbox

private enum ColumnID: String {
    case Name
}

final class FileNavigatorViewController: RenderableViewController, DriverAccessible, WorkspaceAccessible {

    private let scrollView = NSScrollView()
    private let outlineView = NSOutlineView()
    private let nameColumn = NSTableColumn(identifier: ColumnID.Name.rawValue)
    private var installer = ViewInstaller()

    private var sourceFilesVersion: Version?
    private var proxyMapping = [FileID2: FileUIProxy2]()
    private var rootProxy: FileUIProxy2?

    var workspaceID: WorkspaceID? {
        didSet {
            render()
        }
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        renderLayoutOnly()
    }
    override func render() {
        installer.installIfNeeded {
            view.addSubview(scrollView)
            scrollView.documentView = outlineView
            outlineView.addTableColumn(nameColumn)
            outlineView.outlineTableColumn = nameColumn
            outlineView.headerView = nil
            outlineView.rowSizeStyle = .Small
            outlineView.allowsMultipleSelection = true
            outlineView.setDataSource(self)
            outlineView.setDelegate(self)
        }
        renderLayoutOnly()
        renderStatesOnly()
    }
    private func renderLayoutOnly() {
        scrollView.frame = view.bounds
    }
    private func renderStatesOnly() {
        guard sourceFilesVersion != workspaceState?.files.version else { return }
        // TODO: Not optimized. Do it later...
        if let workspaceState = workspaceState {
            let oldMappingCopy = proxyMapping
            proxyMapping = [:]
            for (fileID, fileState) in workspaceState.files {
                proxyMapping[fileID] = oldMappingCopy[fileID]?.renewSourceFileState(fileState) ?? FileUIProxy2(sourceFileID: fileID, sourceFileState: fileState)
            }
            rootProxy = proxyMapping[workspaceState.files.rootID]
        }
        else {
            proxyMapping = [:]
        }
        sourceFilesVersion = workspaceState?.files.version
        outlineView.reloadData()
        renderCurrentFileStateOnly()
    }
    private func renderCurrentFileStateOnly() {
        guard let currentFileID = workspaceState?.window.navigatorPane.file.current else { return }
        guard let currentFileProxy = proxyMapping[currentFileID] else { return }
        let rowIndex = outlineView.rowForItem(currentFileProxy)
        guard rowIndex != NSNotFound else { return }
        outlineView.selectRowIndexes(NSIndexSet(index: rowIndex), byExtendingSelection: false)
    }

    private func scanSelection() {
        guard let workspaceID = workspaceID else { return reportErrorToDevelopers("Missing `FileNavigatorViewController.workspaceID`.") }
        let index = outlineView.selectedRow
        let fileID = ((index == NSNotFound) ? nil : (outlineView.itemAtRow(index) as? FileUIProxy2))?.sourceFileID
        driver.dispatch(Action.Workspace(workspaceID, WorkspaceAction.File(FileAction.SetCurrent(fileID))))
    }
}
extension FileNavigatorViewController: NSOutlineViewDataSource {
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        guard let proxy = item as? FileUIProxy2 else { return false }
        return proxy.sourceFileState.form == .Container
    }
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if item == nil {
            // Root nodes.
            guard rootProxy != nil else { return 0 }
            return 1
        }
        else {
            guard let proxy = item as? FileUIProxy2 else { return 0 }
            return proxy.sourceFileState.subfileIDs.count
        }
    }
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if item == nil {
            // Root nodes.
            assert(rootProxy != nil)
            guard let rootProxy = rootProxy else { fatalError() }
            return rootProxy
        }
        else {
            guard let proxy = item as? FileUIProxy2 else { return 0 }
            let subfileID = proxy.sourceFileState.subfileIDs[index]
            guard let childProxy = proxyMapping[subfileID] else { fatalError() }
            return childProxy
        }
    }
    func outlineView(outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat {
        return 16
    }
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        guard let proxy = item as? FileUIProxy2 else { return nil }

        let imageView = NSImageView()
        let textField = NSTextField()
        let cell = NSTableCellView()
        cell.addSubview(imageView)
        cell.addSubview(textField)
        cell.imageView = imageView
        cell.textField = textField

//        func getIcon() -> NSImage? {
//            guard let path = workspaceState?.files.resolvePathFor(proxy.sourceFileID) else { return nil }
//            guard let path1 = workspaceState?.location?.appending(path).path else { return nil }
//            return NSWorkspace.sharedWorkspace().iconForFile(path1)
//        }
        imageView.image = nil
        textField.bordered = false
        textField.drawsBackground = false
        textField.stringValue = proxy.sourceFileState.name

        return cell
    }
}
extension FileNavigatorViewController: NSOutlineViewDelegate {
    func outlineViewSelectionDidChange(notification: NSNotification) {
        scanSelection()
    }
}
extension NSURL {
    func appending(path: FileNodePath) -> NSURL {
        guard let (first, tail) = path.splitFirst() else { return self }
        return URLByAppendingPathComponent(first).appending(tail)
    }
}














private final class FileUIProxy2 {
    let sourceFileID: FileID2
    var sourceFileState: FileState2
    init(sourceFileID: FileID2, sourceFileState: FileState2) {
        self.sourceFileID = sourceFileID
        self.sourceFileState = sourceFileState
    }
    func renewSourceFileState(sourceFileState: FileState2) -> FileUIProxy2 {
        self.sourceFileState = sourceFileState
        return self
    }
}






















