//
//  CargoMessage.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/01.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilJSON

public protocol CargoDTOMessage {
    ///
    /// Says type of this message.
    ///
    var reason: String { get set }
}
///
/// Uses 0.16.0 source code.
/// https://github.com/rust-lang/cargo/tree/6e0c18cccc8b0c06fba8a8d76486f81a792fb420
///
public enum CargoDTO {
    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/util/machine_message.rs#L21
    ///
    public struct FromCompiler: CargoDTOMessage {
        public var reason: String
//        public var package_id: PackageId
        public var package_id: String // Hotfixed. Unexpected string type.
        public var target: Target
        public var message: JSON
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/util/machine_message.rs#L34
    ///
    public struct Artifact: CargoDTOMessage {
        public var reason: String
//        var package_id: PackageId
        public var package_id: String // Hotfixed. Unexpected string type.
        public var target: Target
        public var profile: Profile
        public var feature: [String]
        public var filenames: [String]
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
    public struct Target {
        public var kind: TargetKind
        public var name: String
        /// This was `PathBuf`, but I couldn't find the definition...
        public var src_path: String
        public var tested: Bool? // Hotfix due to missing field with no good reason.
        public var benched: Bool? // Hotfix due to missing field with no good reason.
        public var doc: Bool? // Hotfix due to missing field with no good reason.
        public var doctest: Bool? // Hotfix due to missing field with no good reason.
        public var harness: Bool? // Hotfix due to missing field with no good reason.
        public var for_host: Bool? // Hotfix due to missing field with no good reason.
    }
    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/core/manifest.rs#L102
    ///
    public enum TargetKind {
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
    public enum LibKind {
        case Lib
        case Rlib
        case Dylib
        case ProcMacro
        case Other(String)
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/be0b4992aa6c25a58720f28f48c4fa3a34e5790d/src/cargo/core/manifest.rs#L153
    ///
    public struct Profile {
        public var opt_level: String
        public var debuginfo: UInt32
        public var debug_assertions: Bool
        public var test: Bool
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/core/source.rs#L102
    ///
    public struct SourceId {
        public var inner: SourceIdInner
    }
    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/core/source.rs#L107
    ///
    public struct SourceIdInner {
        public var url: URL
        public var canonical_url: URL
        public var kind: Kind
        public var precise: String?
    }
    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/core/source.rs#L80
    ///
    public enum Kind {
        case Git(GitReference)
        case Path
        case Registry
        case LocalRegistry
        case Directory
    }
    ///
    /// https://github.com/rust-lang/cargo/blob/6e0c18cccc8b0c06fba8a8d76486f81a792fb420/src/cargo/core/source.rs#L94
    ///
    public enum GitReference {
        case Tag(String)
        case Branch(String)
        case Rev(String)
    }

    public enum Message {
        case compilerMessage
        case rust(Diagnostic)
    }

    public typealias Version = SemverDTO.Version
    public typealias Diagnostic = RustCompilerDTO.Diagnostic
    public typealias JSON = JSONValue
}
