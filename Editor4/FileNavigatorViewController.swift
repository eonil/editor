//
//  FileNavigatorViewController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/20.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit
import BoltsSwift
import EonilToolbox

private enum ColumnID: String {
    case Name
}

private struct LocalState {
    /// TODO: Need to reduce to only required data.
    var workspace: (id: WorkspaceID, state: WorkspaceState)?
}

final class FileNavigatorViewController: WorkspaceRenderableViewController, DriverAccessible {

    private let scrollView = NSScrollView()
    private let outlineView = FileNavigatorOutlineView()
    private let nameColumn = NSTableColumn(identifier: ColumnID.Name.rawValue)
    private let menuPalette = FileNavigatorMenuPalette()

    private var installer = ViewInstaller()
    private var localState = LocalState()
    private var runningMenu = false
    private let selectionController = TemporalLazyCollectionController<FileID2>()

    private var sourceFilesVersion: Version?
    private var proxyMapping = [FileID2: FileUIProxy2]()
    private var rootProxy: FileUIProxy2?

    deinit {
        // This is required to clean up temporal lazy sequence.
        selectionController.source = AnyRandomAccessCollection([])
    }
    override func viewDidLayout() {
        super.viewDidLayout()
        renderLayoutOnly()
    }
    override func render(state: UserInteractionState, workspace: (id: WorkspaceID, state: WorkspaceState)?) {
        // Download.
        localState.workspace = workspace

        // Render.
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
            outlineView.target = self
            outlineView.action = #selector(EDITOR_action(_:)) // This prevents immediate rename editing. Mimics Xcode/Finder behaviour.
            outlineView.menu = menuPalette.context.item.submenu
            outlineView.onEvent = { [weak self] in self?.process($0) }
        }

        renderLayoutOnly()
        renderStatesOnly(localState.workspace)
        renderMenuStatesOnly(localState.workspace?.state)
    }
    private func renderLayoutOnly() {
        scrollView.frame = view.bounds
    }
    private func renderStatesOnly(workspace: (id: WorkspaceID, state: WorkspaceState)?) {
        guard sourceFilesVersion != workspace?.state.files.version else { return }
        // TODO: Not optimized. Do it later...
        if let workspaceState = workspace?.state {
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
        sourceFilesVersion = workspace?.state.files.version
        outlineView.reloadData()
        renderCurrentFileStateOnly(workspace?.state)
    }
    private func renderCurrentFileStateOnly(workspaceState: WorkspaceState?) {
        guard let currentFileID = workspaceState?.window.navigatorPane.file.selection.current else { return }
        guard let currentFileProxy = proxyMapping[currentFileID] else { return }
        guard let rowIndex = outlineView.getRowIndexForItem(currentFileProxy) else { return }
        outlineView.selectRowIndexes(NSIndexSet(index: rowIndex), byExtendingSelection: false)
    }
    private func renderMenuStatesOnly(workspaceState: WorkspaceState?) {
//        let hasClickedFile = (outlineView.getClickedRowIndex() != nil)
//        let selectionContainsClickedFile = outlineView.isSelectedRowIndexesContainClickedRow()
//        let isFileOperationAvailable = hasClickedFile || selectionContainsClickedFile
        let optionalHighlightOrCurrentFileID = workspaceState?.window.navigatorPane.file.selection.getHighlightOrCurrent()
        let isFileOperationAvailable = (optionalHighlightOrCurrentFileID != nil)
//        let isContainerFile = (optionalHighlightOrCurrentFileID == nil ? false : (workspaceState?.files[optionalHighlightOrCurrentFileID!].form == .Container))

        menuPalette.context.enabled             =   true
        menuPalette.showInFinder.enabled        =   isFileOperationAvailable
        menuPalette.showInTerminal.enabled      =   isFileOperationAvailable
        menuPalette.createNewFolder.enabled     =   isFileOperationAvailable // If selected file is non-container, new entry will be created beside of them.
        menuPalette.createNewFile.enabled       =   isFileOperationAvailable // If selected file is non-container, new entry will be created beside of them.
        menuPalette.delete.enabled              =   isFileOperationAvailable
    }

//    private func scan() {
//        // This must be done first because it uses temporal lazy sequence,
//        // and that needs immediate synchronization.
//        scanSelectedFilesOnly()
//        scanCurrentFileOnly()
//    }

    private func scanHighlightedFileOnly() {
        guard let workspaceID = localState.workspace?.id else { return reportErrorToDevelopers("Missing `FileNavigatorViewController.workspaceID`.") }
        let optionalFileID = runningMenu ? outlineView.getClickedFileID2() : nil
        driver.operation.workspace(workspaceID, setHighlightedFile: optionalFileID)
    }

    private func process(event: FileNavigatorOutlineViewEvent) {
        switch event {
        case .WillOpenMenu:
            runningMenu = true
        case .DidCloseMenu:
            runningMenu = false
        }
        renderMenuStatesOnly(localState.workspace?.state)
        scanHighlightedFileOnly()
    }
}
extension FileNavigatorViewController {
    @objc
    private func EDITOR_action(_: AnyObject?) {
    }
    @objc
    private func EDITOR_doubleAction(_: AnyObject?) {
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
        textField.delegate = self

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
            guard let workspaceID = localState.workspace?.id else { return reportErrorToDevelopers("Missing `FileNavigatorViewController.workspaceID`.") }
            guard let current = rowIndexToOptionalFileID(outlineView.selectedRow) else { return }
            debugLog(outlineView.selectedRowIndexes)
            debugLog(outlineView.selectedRowIndexes.lazy.flatMap(rowIndexToOptionalFileID))
            let c = AnyRandomAccessCollection(outlineView.selectedRowIndexes.lazy.flatMap(rowIndexToOptionalFileID))
            selectionController.source = c
            let items = selectionController.sequence
            driver.operation.workspace(workspaceID, resetSelection: (current, items))
        }
        // This must come first to keep state consistency.
        scanSelectedFilesOnly()
    }
}
extension FileNavigatorViewController: NSTextFieldDelegate {

//	func control(control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
//		return	true
//	}
//	func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
//		return	true
//	}
//	override func controlTextDidBeginEditing(obj: NSNotification) {
//
//	}
    func control(control: NSControl, isValidObject obj: AnyObject) -> Bool {
        return	true
    }
    /// This it the only event that works. All above events won't be sent.
    override func controlTextDidEndEditing(notification: NSNotification) {
        // TODO: Improve this to a regular solution.
        // Currently this is a bit hacky. I don't know better solution.
        guard let textField = notification.object as? NSTextField else { return reportErrorToDevelopers("Cannot find sender of end-editing notification in file outline view.") }
//        guard let cellView = textField.superview as? NSTableCellView else { return reportErrorToDevelopers("Cannot find cell that ended editing in file outline view.") }
//        guard let rowView = cellView.superview as? NSTableRowView else { return reportErrorToDevelopers("Cannot find row that ended editing in file outline view.") }
        let rowIndex = outlineView.rowForView(textField)
        guard rowIndex != -1 else { return reportErrorToDevelopers("Cannot find row that ended editing in file outline view.") }
        guard let proxy = outlineView.itemAtRow(rowIndex) as? FileUIProxy2 else { return reportErrorToDevelopers("") }

        guard let workspaceID = localState.workspace?.id else { return reportErrorToDevelopers("Cannot determine workspace ID.") }
        let fileID = proxy.sourceFileID
        let newFileName = textField.stringValue
        // Let the action processor to detect errors in the new name.
        driver.operation.workspace(workspaceID, file: fileID, renameTo: newFileName)
        // Calling `render()` will be no-op because journal should be empty.
        // Set text-field manually.
        driver.operation.invalidateRendering()
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

























