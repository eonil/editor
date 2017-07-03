//
//  WorkspaceWindowController.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class WorkspaceWindowController: NSWindowController {
    private let fileNavigatorVC = FileNavigatorViewController()
    private let consoleVC = ConsoleViewController()
    @IBOutlet weak var navigationPaneView: NSView?
    @IBOutlet weak var consolePaneView: NSView?

    weak var features: WorkspaceFeatures? {
        didSet {
            fileNavigatorVC.features = features
            consoleVC.features = features
        }
    }

//    convenience init() {
//        let n = NSStringFromClass(type(of: self))
//        let n1 = n.components(separatedBy: ".")
//        let n2 = n1.dropFirst().joined(separator: ".")
//        let c = "Controller"
//        precondition(n2.hasSuffix(c))
//        let dist = c.distance(from: c.startIndex, to: c.endIndex)
//        let range = n2.startIndex..<(n2.index(n2.endIndex, offsetBy: -dist))
//        self.init(windowNibName: n2[range])
//    }
    convenience init() {
        let n = NSStringFromClass(type(of: self))
        let n1 = n.components(separatedBy: ".")
        let n2 = n1.dropFirst().joined(separator: ".")
        self.init(windowNibName: n2)
    }

    private func step() {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func windowDidLoad() {
        super.windowDidLoad()
        guard let navigationPaneView = navigationPaneView else { REPORT_missingServicesAndFatalError() }
        navigationPaneView.addSubview(fileNavigatorVC.view)
        consolePaneView?.addSubview(consoleVC.view)
        fileNavigatorVC.view.pinToFillSuperview()
        consoleVC.view.pinToFillSuperview()
    }
}
