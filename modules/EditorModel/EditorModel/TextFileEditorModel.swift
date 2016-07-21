//
//  TextFileEditorModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2016/01/01.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon

/// Also performs platform I/O
public final class TextFileEditorModel {

        public enum Event {
                public typealias Notification = EditorModel.Notification<TextFileEditorModel,Event>
                case URLDidChange
                case EditingDidChange
        }
        public enum Error: ErrorType {
                case DataIsUndecodableAsUTF8
                case TextIsUnencodableAsUTF8
        }

        // MARK: -
        internal init() {

        }
        deinit {

        }

        // MARK: -
        public var URL: NSURL? {
                get {
                        return internals.URL
                }
        }
        public var editing: TextEditingModel? {
                get {
                        return internals.editing
                }
        }
        public func setURL(newURL: NSURL?) throws {
                try setURLImpl(newURL)
        }

        // MARK: -
        private var internals = InternalState()
        private func performInternalOnlyTransaction(@noescape t: () throws ->()) throws {
                let oldInternals = internals
                do {
                        try t()
                }
                catch let error {
                        // Rollback. Make it sure that you have no more side effects.
                        internals = oldInternals
                        throw error
                }
        }
        private func setURLImpl(newURL: NSURL?) throws {
                guard URL != newURL else { return }
                try performInternalOnlyTransaction {
                        if let URL = internals.URL {
				// Write.
                                guard let editing = internals.editing else { fatalErrorBecauseOfInconsistentInternalStateWithReportingToDevelopers() }
                                let text = editing.storage.string as NSString
                                guard let data = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) else {
                                        throw Error.TextIsUnencodableAsUTF8
                                }
                                try data.writeToURL(URL, options: [.DataWritingAtomic])
                                internals.editing = nil
                        }
                        internals.URL = newURL
                        if let URL = internals.URL {
				// Read.
                                let data = try Platform.thePlatform.fileSystem.contentOfFileAtURLAtomically(URL)
                                guard let text = NSString(data: data, encoding: NSUTF8StringEncoding) else {
                                        throw Error.DataIsUndecodableAsUTF8
                                }
                                let newEditing = TextEditingModel()
                                let text1 = text as String
                                newEditing.storage.appendAttributedString(NSAttributedString(string: text1))
                                internals.editing = newEditing
                        }
                }
                Event.Notification(sender: self, event: .EditingDidChange).broadcast()
                Event.Notification(sender: self, event: .URLDidChange).broadcast()
        }
}

private struct InternalState {
        var URL: NSURL?
        var editing: TextEditingModel?
}












