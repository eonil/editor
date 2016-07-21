//
//  TextEditingModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2016/01/01.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon

public final class TextEditingModel {

        // MARK: -
        internal init() {
                storage.delegate = delegate
        }
        deinit {
        }

        // MARK: -
        public let storage: NSTextStorage = DelegationLockedTextStorage()

        // MARK: -
        private let delegate = OBJCTextStorageDelegate()
        private func willProcessEditingImpl(editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {

        }
        private func didProcessEditingImpl(editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {

        }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Private Helpers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
private final class DelegationLockedTextStorage: NSTextStorage {
        override var delegate: NSTextStorageDelegate? {
                willSet {
			assert(delegate == nil, "You cannot replace delegate once it's been set.")
                }
                didSet {

                }
        }
}

private final class OBJCTextStorageDelegate: NSObject, NSTextStorageDelegate {
        weak var owner: TextEditingModel?
        @objc
        func textStorage(textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
		checkAndReportFailureToDevelopers(owner != nil)
                guard let owner = owner else { return }
                owner.willProcessEditingImpl(editedMask, range: editedRange, changeInLength: delta)
        }
        @objc
        func textStorage(textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
                checkAndReportFailureToDevelopers(owner != nil)
                guard let owner = owner else { return }
                owner.didProcessEditingImpl(editedMask, range: editedRange, changeInLength: delta)
        }
}




