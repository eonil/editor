//
//  RustCompilerDataStructures.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

enum RustCompilerDataStructures {

    /// https://github.com/rust-lang/rust/blob/91f34c0c70746f5c938d25d02a8a66b41240b2f0/src/libsyntax/json.rs#L77
    struct Diagnostic {
        var message: String
        var code: DiagnosticCode?
        var level: String
        var spans: [DiagnosticSpan]
        var children: [Diagnostic]
        var rendered: String?
    }

    /// https://github.com/rust-lang/rust/blob/91f34c0c70746f5c938d25d02a8a66b41240b2f0/src/libsyntax/json.rs#L93
    struct DiagnosticSpan {
        var file_name: String
        var byte_start: UInt32
        var byte_end: UInt32
        var line_start: UInt
        var line_end: UInt
        var column_start: UInt
        var column_end: UInt
        var is_primary: Bool
        var text: [DiagnosticSpanLine]
        var label: String?
        var suggested_replacement: String?
        var expansion: Box<DiagnosticSpanMacroExpansion>?
    }

    /// https://github.com/rust-lang/rust/blob/91f34c0c70746f5c938d25d02a8a66b41240b2f0/src/libsyntax/json.rs#L120
    struct DiagnosticSpanLine {
        var text: String
        var highlight_start: UInt
        var highlight_end: UInt
    }

    /// https://github.com/rust-lang/rust/blob/91f34c0c70746f5c938d25d02a8a66b41240b2f0/src/libsyntax/json.rs#L130
    struct DiagnosticSpanMacroExpansion {
        var span: DiagnosticSpan
        var macro_decl_name: String
        var def_site_span: DiagnosticSpan?
    }

    /// https://github.com/rust-lang/rust/blob/91f34c0c70746f5c938d25d02a8a66b41240b2f0/src/libsyntax/json.rs#L144
    struct DiagnosticCode {
        var code: String
        var explanation: String?
    }

}
