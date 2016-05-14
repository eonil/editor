//
//  FileNavigatorViewController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/20.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox

private enum ColumnID: String {
    case Name
}

final class FileNavigatorViewController: RenderableViewController, DriverAccessible, WorkspaceAccessible {

    private let scrollView = NSScrollView()
    private let outlineView = NSOutlineView()
    private let nameColumn = NSTableColumn(identifier: ColumnID.Name.rawValue)
    private var proxyRoot: FileNodeUIProxy?
    private var installer = ViewInstaller()

    var workspaceID: WorkspaceID? {
        didSet {
            render()
        }
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        renderLayout()
    }
    override func render() {
        renderLayout()
        renderStates()
    }
    private func renderLayout() {
        installer.installIfNeeded {
            view.wantsLayer = true
            view.layer?.backgroundColor = NSColor.redColor().CGColor

            view.addSubview(scrollView)
            scrollView.documentView = outlineView
            outlineView.rowSizeStyle = .Small
            outlineView.addTableColumn(nameColumn)
            outlineView.outlineTableColumn = nameColumn
            outlineView.setDataSource(self)
            outlineView.setDelegate(self)
        }
        scrollView.frame = view.bounds

    }
    private func renderStates() {
        if let workspaceState = workspaceState {
            if proxyRoot == nil {
                proxyRoot = FileNodeUIProxy()
            }
            proxyRoot?.syncFrom(workspaceState.file)
        }
        else {
            proxyRoot = nil
        }
        outlineView.reloadData()
    }
}
extension FileNavigatorViewController: NSOutlineViewDataSource, NSOutlineViewDelegate {
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        return true
    }
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        guard proxyRoot != nil else { return 0 }
        guard item != nil else { return 1 }
        guard let proxy = item as? FileNodeUIProxy else { return 0 }
        return proxy.proxySubnodeManager.array.count
    }
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        guard let proxyRoot = proxyRoot else { fatalError() }
        guard let proxy = item as? FileNodeUIProxy else { return proxyRoot }
        return proxy.proxySubnodeManager.array[index]
    }
    func outlineView(outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat {
        return 16
    }
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        guard let proxy = item as? FileNodeUIProxy else { return nil }

        let imageView = NSImageView()
        let textField = NSTextField()
        let cell = NSTableCellView()
        cell.addSubview(imageView)
        cell.addSubview(textField)
        cell.imageView = imageView
        cell.textField = textField
//        imageView.image = NSWorkspace.sharedWorkspace().iconForFile(<#T##fullPath: String##String#>)
        textField.bordered = false
        textField.drawsBackground = false
        textField.stringValue = proxy.sourceState?.name ?? ""
        return cell
    }

}









extension FileNode: IdentifiableType {
    func identify() -> String {
        return state.name
    }
}
private final class FileNodeUIProxy: SynchronizableElementType, IdentifiableType, DefaultInitializableType {
    typealias SourceType = FileNode
    var sourceVersion: Version?
    var sourceState: FileNodeState?
    var sourceSubnodesVersion: Version?
    var proxySubnodeManager = ArraySynchronizationManager<FileNodeUIProxy>()

    private func identify() -> String {
        return sourceState?.name ?? ""
    }
    func syncFrom(source: FileNode) {
        guard sourceVersion != source.version else { return } //< No-op for same version.
        sourceState = source.state
        proxySubnodeManager.syncFrom(source.subnodes)
        sourceVersion = source.version
    }
}























