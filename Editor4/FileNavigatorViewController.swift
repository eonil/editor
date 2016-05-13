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

final class FileNavigatorViewController: RenderableViewController, DriverAccessible {

    private let outlineView = NSOutlineView()
    private var proxyRoot = FileNodeUIProxy()
    private var installer = ViewInstaller()

    var workspaceID: WorkspaceID? {
        didSet {
            render()
        }
    }

    override func render() {
        installer.installIfNeeded {
            outlineView.setDataSource(self)
            outlineView.setDelegate(self)
            view.addSubview(outlineView)
        }
        outlineView.frame = view.bounds
        outlineView.reloadData()
    }
}
extension FileNavigatorViewController: NSOutlineViewDataSource, NSOutlineViewDelegate {
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        return true
    }
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        guard let proxy = item as? FileNodeUIProxy else { return 0 }
        return proxy.proxySubnodeManager.array.count
    }
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        guard let proxy = item as? FileNodeUIProxy else { return proxyRoot }
        return proxy.proxySubnodeManager.array[index]
    }
    func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
        guard let proxy = item as? FileNodeUIProxy else { return proxyRoot }
        return proxy.sourceState?.name
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























