//
//  EditorVC.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class EditorVC: NSViewController, WorkspaceFeatureDependent {
    private let loop = ReactiveLoop()
    private let watch = Relay<()>()

    weak var features: WorkspaceFeatures? {
        didSet {
            render()
            features?.codeEditing.changes += watch
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        watch += loop
        loop.step = { [weak self] in self?.render() }
        render()
        codeView?.textViewDelegate = self
    }

    private func render() {
        codeView?.isEnabled = features?.codeEditing.state.content != nil
        codeView?.isEditable = features?.codeEditing.state.content != nil
        codeView?.string = features?.codeEditing.state.content ?? ""
    }

    @IBOutlet private weak var codeView: CodeView?
}
extension EditorVC: NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        guard let features = features else { return }
        guard let s = codeView?.string else { return }
        features.process(.codeEditing(.setContent(s)))
    }
}
