//
//  RustCompilerDTO.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/01.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

public enum RustCompilerDTO {
    public struct Diagnostic {
        public var level: Level
        public var message: [(String, Style)]
        public var code: String?
        public var span: MultiSpan
        public var children: [SubDiagnostic]
    }

    public struct SubDiagnostic {
        public var level: Level
        public var message: [(String, Style)]
        public var span: MultiSpan
        public var render_span: RenderSpan?
    }

    public enum Level {
        // Unknown...
    }

    public enum Style {
        // Unknown...
    }

    ///
    /// https://github.com/rust-lang/rust/blob/e4eea733065ec39ba6031d856ace002c70035c44/src/libsyntax_pos/lib.rs#L70
    ///
    public struct MultiSpan {
        public var primary_spans: [Span]
        public var span_labels: [(Span, String)]
    }

    ///
    /// https://github.com/rust-lang/rust/blob/e4eea733065ec39ba6031d856ace002c70035c44/src/libsyntax_pos/lib.rs#L55
    ///
    public struct Span {
        public var lo: BytePos
        public var hi: BytePos
        public var expn_id: ExpnId
    }

    ///
    /// https://github.com/rust-lang/rust/blob/e4eea733065ec39ba6031d856ace002c70035c44/src/librustc_errors/lib.rs#L54
    ///
    public enum RenderSpan {
        case FullSpan(MultiSpan)
        case Suggestion(CodeSuggestion)
    }

    ///
    /// https://github.com/rust-lang/rust/blob/e4eea733065ec39ba6031d856ace002c70035c44/src/librustc_errors/lib.rs#L68
    ///
    public struct CodeSuggestion {
        var msp: MultiSpan
        var substitutes: [String]
    }

    /// Must be newtype later.
    public typealias BytePos = UInt32

    /// Must be newtype later.
    public typealias CharPos = UInt

    /// Must be newtype later.
    public typealias ExpnId = UInt32
}
