//
//  ConsoleVC.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class ConsoleVC: NSViewController, WorkspaceFeatureDependent {
    private let logChangeWatch = Relay<LogFeature.Change>()

    weak var features: WorkspaceFeatures? {
        didSet {
            resetRendering()
            features?.log.changes += logChangeWatch
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        resetRendering()
        logChangeWatch.delegate = { [weak self] in self?.processLogChanges($0) }
    }
    private func processLogChanges(_ cx: LogFeature.Change) {
        DEBUG_log("Receive log change: \(cx)")
        guard let features = features else { return }
        switch cx {
        case .items(let m):
            switch m {
            case .insert(let r):
                let items = features.log.production.items[r]
                let addition = items.map({ "\($0)\n" }).joined()
                codeTextView?.string = (codeTextView?.string ?? "") + addition
            case .update(_):
                MARK_unimplemented()
            case .delete(_):
                MARK_unimplemented()
            }
        }
    }

    private func resetRendering() {
        DEBUG_log("Reset logs: \(features?.log.production.items ?? [])")
        let newText = features?.log.production.items.map({ "\($0)\n" }).joined()
        codeTextView?.string = newText ?? "" // `NSTextView` does not accept nil for valid input. Bullshit.
    }



    @IBOutlet private weak var codeTextView: CodeTextView2?
}
