//
//  RustCompilerDTO.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/01.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

///
/// Based on Rust compiler release 1.20.0.
/// https://github.com/rust-lang/rust/commit/f3d6973f41a7d1fb83029c9c0ceaf0f5d4fd7208
/// https://github.com/rust-lang/rust/blob/f3d6973f41a7d1fb83029c9c0ceaf0f5d4fd7208/src/tools/compiletest/src/json.rs
///
struct RustCompilerDTO {
    typealias usize = UInt
    typealias Option<T> = Optional<T>
    typealias bool = Bool
    typealias Vec<T> = Array<T>

    final class Box<T>: Decodable where T: Decodable {
        let value: T
        init(from decoder: Decoder) throws {
            value = try T(from: decoder)
        }
    }

    ///
    /// https://github.com/rust-lang/rust/blob/f3d6973f41a7d1fb83029c9c0ceaf0f5d4fd7208/src/tools/compiletest/src/json.rs#L21
    ///
    struct Diagnostic: Decodable {
        var message: String
        var code: DiagnosticCode?
        var level: Level
        var spans: [DiagnosticSpan]
        var children: [Diagnostic]
        var rendered: String?
    }

    ///
    /// https://github.com/rust-lang/rust/blob/f3d6973f41a7d1fb83029c9c0ceaf0f5d4fd7208/src/tools/compiletest/src/json.rs#L31
    ///
    struct DiagnosticSpan: Decodable {
        var file_name: String
        var line_start: usize
        var line_end: usize
        var column_start: usize
        var column_end: usize
        var is_primary: bool
        var label: Option<String>
        var expansion: Option<Box<DiagnosticSpanMacroExpansion>>
    }

    ///
    /// https://github.com/rust-lang/rust/blob/f3d6973f41a7d1fb83029c9c0ceaf0f5d4fd7208/src/tools/compiletest/src/json.rs#L43
    ///
    struct DiagnosticSpanMacroExpansion: Decodable {
        /// span where macro was applied to generate this code
        var span: DiagnosticSpan
        /// name of macro that was applied (e.g., "foo!" or "#[derive(Eq)]")
        var macro_decl_name: String
    }

    ///
    /// https://github.com/rust-lang/rust/blob/f3d6973f41a7d1fb83029c9c0ceaf0f5d4fd7208/src/tools/compiletest/src/json.rs#L52
    ///
    struct DiagnosticCode: Decodable {
        /// The code itself.
        var code: String
        /// An explanation for the code.
        var explanation: Option<String>
    }

    ///
    /// Type of level is actually undefined, but I just speculated one.
    /// I'm not sure this is the correct one.
    /// https://github.com/rust-lang/rust/blob/f3d6973f41a7d1fb83029c9c0ceaf0f5d4fd7208/src/librustc_errors/lib.rs#L554
    ///
    enum Level: String, Decodable {
        case bug
        case fatal
        // An error which while not immediately fatal, should stop the compiler
        // progressing beyond the current phase.
        case phaseFatal
        case error
        case warning
        case note
        case help
        case cancelled
    }
}
