//
//  RustCompilerDTO.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/01.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

enum RustCompilerDTO {
    struct Diagnostic {
        var level: Level
        var message: [(String, Style)]
        var code: String?
        var span: MultiSpan
        var children: [SubDiagnostic]
    }

    struct SubDiagnostic {
        var level: Level
        var message: [(String, Style)]
        var span: MultiSpan
        var render_span: RenderSpan?
    }

    enum Level {
        // Unknown...
    }

    enum Style {
        // Unknown...
    }

    ///
    /// https://github.com/rust-lang/rust/blob/e4eea733065ec39ba6031d856ace002c70035c44/src/libsyntax_pos/lib.rs#L70
    ///
    struct MultiSpan {
        var primary_spans: [Span]
        var span_labels: [(Span, String)]
    }

    ///
    /// https://github.com/rust-lang/rust/blob/e4eea733065ec39ba6031d856ace002c70035c44/src/libsyntax_pos/lib.rs#L55
    ///
    struct Span {
        var lo: BytePos
        var hi: BytePos
        var expn_id: ExpnId
    }

    ///
    /// https://github.com/rust-lang/rust/blob/e4eea733065ec39ba6031d856ace002c70035c44/src/librustc_errors/lib.rs#L54
    ///
    enum RenderSpan {
        case FullSpan(MultiSpan)
        case Suggestion(CodeSuggestion)
    }

    ///
    /// https://github.com/rust-lang/rust/blob/e4eea733065ec39ba6031d856ace002c70035c44/src/librustc_errors/lib.rs#L68
    ///
    struct CodeSuggestion {
        var msp: MultiSpan
        var substitutes: [String]
    }

    /// Must be newtype later.
    typealias BytePos = UInt32

    /// Must be newtype later.
    typealias CharPos = UInt

    /// Must be newtype later.
    typealias ExpnId = UInt32
}
