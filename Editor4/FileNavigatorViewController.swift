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
    private let outlineView = FileNavigatorOutlineView()
    private let nameColumn = NSTableColumn(identifier: ColumnID.Name.rawValue)
    private let menuPalette = FileNavigatorMenuPalette()

    private var installer = ViewInstaller()
    private var runningMenu = false
    private let selectionController = TemporalLazyCollectionController<FileID2>()

    private var sourceFilesVersion: Version?
    private var proxyMapping = [FileID2: FileUIProxy2]()
    private var rootProxy: FileUIProxy2?

    deinit {
        // This is required to clean up temporal lazy sequence.
        selectionController.source = AnyRandomAccessCollection([])
    }
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
            outlineView.menu = menuPalette.context.item.submenu
            outlineView.onEvent = { [weak self] in self?.process($0) }
        }
        renderLayoutOnly()
        renderStatesOnly()
        renderMenuStatesOnly()
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
        guard let currentFileID = workspaceState?.window.navigatorPane.file.selection.current else { return }
        guard let currentFileProxy = proxyMapping[currentFileID] else { return }
        guard let rowIndex = outlineView.getRowIndexForItem(currentFileProxy) else { return }
        outlineView.selectRowIndexes(NSIndexSet(index: rowIndex), byExtendingSelection: false)
    }
    private func renderMenuStatesOnly() {
        let hasClickedFile = (outlineView.getClickedRowIndex() != nil)
        let selectionContainsClickedFile = outlineView.isSelectedRowIndexesContainClickedRow()
        let isFileOperationAvailable = hasClickedFile || selectionContainsClickedFile
        menuPalette.context.enabled = true
        menuPalette.showInFinder.enabled = isFileOperationAvailable
        menuPalette.showInTerminal.enabled = isFileOperationAvailable
        menuPalette.createNewFolder.enabled = isFileOperationAvailable
        menuPalette.createNewFolder.enabled = isFileOperationAvailable
        menuPalette.delete.enabled = isFileOperationAvailable
    }

//    private func scan() {
//        // This must be done first because it uses temporal lazy sequence,
//        // and that needs immediate synchronization.
//        scanSelectedFilesOnly()
//        scanCurrentFileOnly()
//    }

    private func scanCurrentFileOnly() {
        guard let workspaceID = workspaceID else { return reportErrorToDevelopers("Missing `FileNavigatorViewController.workspaceID`.") }
        if runningMenu {
            let optionalFileID = outlineView.getClickedFileID2() ?? outlineView.getSelectedFileID2()
            driver.dispatch(Action.Workspace(workspaceID, WorkspaceAction.File(FileAction.SetCurrent(optionalFileID))))
        }
        else {
            let optionalFileID = outlineView.getSelectedFileID2()
            driver.dispatch(Action.Workspace(workspaceID, WorkspaceAction.File(FileAction.SetCurrent(optionalFileID))))
        }
    }

    private func process(event: FileNavigatorOutlineViewEvent) {
        switch event {
        case .WillOpenMenu:
            runningMenu = true
        case .DidCloseMenu:
            runningMenu = false
        }
        renderMenuStatesOnly()
        scanCurrentFileOnly()
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
        let rowIndexToOptionalFileID = { [weak self] (rowIndex: Int) -> FileID2? in
            guard let S = self else { return nil }
            guard rowIndex != -1 else { return nil }
            guard let proxy = S.outlineView.itemAtRow(rowIndex) as? FileUIProxy2 else { return nil }
            return proxy.sourceFileID
        }
        /// Must be called only from  `SelectionDidChange` event.
        /// Because we cannot determine version of `selectedRowIndexes`,
        /// the only thing what we can do is just tracking event precisely.
        /// Extra or redundant scanning of selected files will prevent access to lazy sequence.
        func scanSelectedFilesOnly() {
            guard let workspaceID = workspaceID else { return reportErrorToDevelopers("Missing `FileNavigatorViewController.workspaceID`.") }
            guard let current = rowIndexToOptionalFileID(outlineView.selectedRow) else { return }
            let c = AnyRandomAccessCollection(outlineView.selectedRowIndexes.lazy.flatMap(rowIndexToOptionalFileID))
            selectionController.source = c
            let items = selectionController.sequence
            driver.dispatch(Action.Workspace(workspaceID, WorkspaceAction.File(FileAction.SetSelectedFiles(current: current, items: items))))
        }
        // This must come first to keep state consistency.
        scanSelectedFilesOnly()
        scanCurrentFileOnly()
    }
}

private extension NSOutlineView {
    private func getRowIndexForItem(proxy: FileUIProxy2?) -> Int? {
        let legacyIndex = rowForItem(proxy)
        guard legacyIndex != -1 else { return nil }
        return legacyIndex
    }
    private func getClickedRowIndex() -> Int? {
        return clickedRow == -1 ? nil : clickedRow
    }
    private func getClickedFileUIProxy2() -> FileUIProxy2? {
        guard let index = getClickedRowIndex() else { return nil }
        guard let proxy = itemAtRow(index) as? FileUIProxy2 else { return nil }
        return proxy
    }
    private func getClickedFileID2() -> FileID2? {
        return getClickedFileUIProxy2()?.sourceFileID
    }
    private func isSelectedRowIndexesContainClickedRow() -> Bool {
        return selectedRowIndexes.containsIndex(clickedRow)
    }
    private func getSelectedFileID2() -> FileID2? {
        guard selectedRow != -1 else { return nil }
        guard let proxy = itemAtRow(selectedRow) as? FileUIProxy2 else { return nil }
        return proxy.sourceFileID
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















////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private enum FileNavigatorOutlineViewEvent {
    case WillOpenMenu
    case DidCloseMenu
}
private final class FileNavigatorOutlineView: NSOutlineView {
    var onEvent: (FileNavigatorOutlineViewEvent -> ())?
    private override func willOpenMenu(menu: NSMenu, withEvent event: NSEvent) {
        super.willOpenMenu(menu, withEvent: event)
        onEvent?(.WillOpenMenu)
    }
    private override func didCloseMenu(menu: NSMenu, withEvent event: NSEvent?) {
        super.didCloseMenu(menu, withEvent: event)
        onEvent?(.DidCloseMenu)
    }
}

























