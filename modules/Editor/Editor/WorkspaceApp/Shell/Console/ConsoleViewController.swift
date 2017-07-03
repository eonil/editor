//
//  Console.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/29.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

///
/// For now, this VC provides only output, no input.
///
final class ConsoleViewController: NSViewController {
    private let logChangeWatch = Relay<LogFeature.Change>()
    @IBOutlet weak var textView: NSTextView?

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
                textView?.string = (textView?.string ?? "") + addition
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
        textView?.string = newText
    }
}
