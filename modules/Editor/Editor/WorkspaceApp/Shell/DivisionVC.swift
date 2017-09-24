//
//  DivisionWC.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit
import SnapKit

///
/// Manages in-window navigations.
///
final class DivisionVC: NSViewController, WorkspaceFeatureDependent {
    weak var features: WorkspaceFeatures? {
        didSet {
            navigator.features = features
            utility.features = features
            editor.features = features
            console.features = features
        }
    }

    private typealias RS = Resources.Storyboard
    private let navigator = RS.navigator.instantiate()
    private let utility = RS.utility.instantiate()
    private let editor = RS.editor.instantiate()
    private let console = RS.console.instantiate()

    private func installPane(content: NSViewController, container: NSView?) {
        addChildViewController(content)
        container?.addSubview(content.view)
        content.view.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(leftPaneContainer != nil)
        assert(rightPaneContainer != nil)
        assert(centerTopPaneContainer != nil)
        assert(centerBottomPaneContainer != nil)
        installPane(content: navigator, container: leftPaneContainer)
        installPane(content: utility, container: rightPaneContainer)
        installPane(content: editor, container: centerTopPaneContainer)
        installPane(content: console, container: centerBottomPaneContainer)
    }

    @IBOutlet private weak var leftPaneContainer: NSView?
    @IBOutlet private weak var rightPaneContainer: NSView?
    @IBOutlet private weak var centerTopPaneContainer: NSView?
    @IBOutlet private weak var centerBottomPaneContainer: NSView?
}

//final class DivisionVC: NSViewController, WorkspaceFeatureDependent {
//    weak var features: WorkspaceFeatures?
//
//    private let navigator = RS.navigator.instantiate()
//    private let utility = RS.utility.instantiate()
//    private let editor = RS.editor.instantiate()
//    private let console = RS.console.instantiate()
//
//    var config = Config() {
//        didSet {
//            replaceAllPaneContents(old: oldValue, new: config)
//        }
//    }
//
//    private func replaceAllPaneContents(old: Config, new: Config) {
//        replacePaneContent(old: old.leftPaneContent, new: new.leftPaneContent, container: leftPaneContainer)
//        replacePaneContent(old: old.rightPaneContent, new: new.rightPaneContent, container: leftPaneContainer)
//        replacePaneContent(old: old.centerTopPaneContent, new: new.centerTopPaneContent, container: leftPaneContainer)
//        replacePaneContent(old: old.centerBottomPaneContent, new: new.centerBottomPaneContent, container: leftPaneContainer)
//    }
//    private func replacePaneContent(old: NSViewController?, new: NSViewController?, container: NSView?) {
//        guard old !== new else { return }
//        if let old = old {
//            assert(old.view.superview === container)
//            old.view.superview?.removeFromSuperview()
//            old.removeFromParentViewController()
//        }
//        if let new = new {
//            addChildViewController(new)
//            container?.addSubview(new.view)
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        assert(leftPaneContainer != nil)
//        assert(rightPaneContainer != nil)
//        assert(centerTopPaneContainer != nil)
//        assert(centerBottomPaneContainer != nil)
//        replaceAllPaneContents(old: DivisionVC.Config(), new: config)
//    }
//
//    @IBOutlet private weak var leftPaneContainer: NSView?
//    @IBOutlet private weak var rightPaneContainer: NSView?
//    @IBOutlet private weak var centerTopPaneContainer: NSView?
//    @IBOutlet private weak var centerBottomPaneContainer: NSView?
//}
//extension DivisionVC {
//    struct Config {
//        var leftPaneContent: NSViewController?
//        var rightPaneContent: NSViewController?
//        var centerTopPaneContent: NSViewController?
//        var centerBottomPaneContent: NSViewController?
//    }
//}
//private extension DivisionVC.Config {
//    func collectNonNilVCs() -> [NSViewController] {
//        let vcs = [leftPaneContainer, rightPaneContainer, centerTopPaneContainer, centerBottomPaneContainer]
//        return vcs.flatMap({$0})
//    }
//}

