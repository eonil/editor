//
//  CargoMessage.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/01.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilJSON

protocol CargoDTOMessage {
    ///
    /// Says type of this message.
    ///
    var reason: String { get set }
}
///
/// Uses 0.16.0 source code.
/// https://github.com/rust-lang/cargo/tree/6e0c18cccc8b0c06fba8a8d76486f81a792fb420
///
enum CargoDTO {
    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/util/machine_message.rs#L21
    ///
    struct FromCompiler: CargoDTOMessage {
        var reason: String
//        var package_id: PackageId
        var package_id: String // Hotfixed. Unexpected string type.
        var target: Target
        var message: JSON
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/util/machine_message.rs#L34
    ///
    struct Artifact: CargoDTOMessage {
        var reason: String
//        var package_id: PackageId
        var package_id: String // Hotfixed. Unexpected string type.
        var target: Target
        var profile: Profile
        var feature: [String]
        var filenames: [String]
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/util/machine_message.rs#L49
    ///
    struct BuildScript: CargoDTOMessage {
        var reason: String
//        var package_id: PackageId
        var package_id: String // Hotfixed. Unexpected string type.
        var linked_libs: [String]
        var linked_paths: [String]
        var cfgs: [String]
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/core/package_id.rs#L17
    ///
    struct PackageId {
        var inner: PackageIdInner
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/core/package_id.rs#L22
    ///
    struct PackageIdInner {
        var name: String
        var version: Version
        var source_id: SourceId
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/core/manifest.rs#L178
    ///
    struct Target {
        var kind: TargetKind
        var name: String
        /// This was `PathBuf`, but I couldn't find the definition...
        var src_path: String
        var tested: Bool? // Hotfix due to missing field with no good reason.
        var benched: Bool? // Hotfix due to missing field with no good reason.
        var doc: Bool? // Hotfix due to missing field with no good reason.
        var doctest: Bool? // Hotfix due to missing field with no good reason.
        var harness: Bool? // Hotfix due to missing field with no good reason.
        var for_host: Bool? // Hotfix due to missing field with no good reason.
    }
    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/core/manifest.rs#L102
    ///
    enum TargetKind {
        case Lib([LibKind])
        case Bin
        case Test
        case Bench
        case Example
        case CustomBuild
    }
    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/core/manifest.rs#L60
    ///
    enum LibKind {
        case Lib
        case Rlib
        case Dylib
        case ProcMacro
        case Other(String)
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/be0b4992aa6c25a58720f28f48c4fa3a34e5790d/src/cargo/core/manifest.rs#L153
    ///
    struct Profile {
        var opt_level: String
        var debuginfo: UInt32
        var debug_assertions: Bool
        var test: Bool
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/core/source.rs#L102
    ///
    struct SourceId {
        var inner: SourceIdInner
    }
    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/core/source.rs#L107
    ///
    struct SourceIdInner {
        var url: URL
        var canonical_url: URL
        var kind: Kind
        var precise: String?
    }
    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/core/source.rs#L80
    ///
    enum Kind {
        case Git(GitReference)
        case Path
        case Registry
        case LocalRegistry
        case Directory
    }
    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/core/source.rs#L94
    ///
    enum GitReference {
        case Tag(String)
        case Branch(String)
        case Rev(String)
    }

    enum Message {
        case compilerMessage
        case rust(Diagnostic)
    }

    typealias Version = SemverDTO.Version
    typealias Diagnostic = RustCompilerDTO.Diagnostic
    typealias JSON = JSONValue
}
