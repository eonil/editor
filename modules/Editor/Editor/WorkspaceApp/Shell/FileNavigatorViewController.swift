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

final class FileNavigatorViewController: NSViewController {
//    private let projectWatch = Relay<ProjectFeature.Transaction>()
//    @IBOutlet private weak var fileTreeView: FileNavigatorUIView?
//    private var fileTreeViewState = FileNavigatorUIState()
//    private var idMapping = [ProjectFeature.Path: FileNavigatorUINodeID]()
//
//    ///
//    /// Designate feature to provides actual functionalities.
//    /// Settings this to `nil` makes every user interaction
//    /// no-op.
//    ///
//    weak var features: WorkspaceFeatures? {
//        willSet {
//            disconnectFromFeatures()
//        }
//        didSet {
//            connectToFeatures()
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    override func viewWillAppear() {
//        super.viewWillAppear()
//    }
//    override func viewDidDisappear() {
//        super.viewDidDisappear()
//    }
//
//
//
//
//
//
//
//    ///
//    /// Idempotent.
//    /// No-op if there's no feature.
//    ///
//    private func connectToFeatures() {
//        guard let features = features else { return }
//        projectWatch.watch(features.project.transaction)
//    }
//
//    ///
//    /// Idempotent.
//    /// No-op if there's no feature.
//    ///
//    private func disconnectFromFeatures() {
//        guard let features = features else { return }
//        projectWatch.unwatch()
//    }
//
//    private func processProjectTransaction(_ tx: ProjectFeature.Transaction) {
//        MARK_unimplemented()
////        guard let features = features else { REPORT_missingFeaturesAndFatalError() }
////        switch tx {
////        case .location:
////            break
////        case .files(let m):
////            switch m {
////            case .insert(let idxp):
////                guard let (path, metadata) = features.project.state.files[idxp] else { MARK_unimplemented() }
////                if path == .root {
////                    fileTreeViewState.tree.remove(fileTreeViewState.tree.root)
////                }
////                else {
////                    let lastComp = path.components.last!
////                    let parentPath = path.deletingLastComponent()
////                    let viewParentID = idMapping[parentPath]!
////                    var s = FileNavigatorUINodeState()
////                    s.name = "AA"
////                    s.type = .document
////                    fileTreeViewState.tree.insert(s, at: lastcomp, in: viewParentID)
////                    fileTreeViewState.tree.remove(<#T##id: FileNavigatorUINodeID##FileNavigatorUINodeID#>)
////                }
////                fileTreeViewState.tree.
////                var s = FileNavigatorUINodeState()
////                s.name
////                fileTreeViewState.tree.insert(<#T##newState: FileNavigatorUINodeState##FileNavigatorUINodeState#>, at: <#T##Int#>, in: <#T##FileNavigatorUINodeID#>)
////            }
////        case .issues(_):
////            break
////        }
//    }
}

private extension FileNavigatorUITree {
//    func getNodeAt(_ index: Tree2<Void,Void>.IndexPath) -> FileNavigatorUINode {
//        let root1 = self[root]
//        root1
//    }
}










