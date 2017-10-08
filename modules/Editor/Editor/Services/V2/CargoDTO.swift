//
//  CargoMessage.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/01.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilJSON

protocol CargoDTOMessageProtocol {
    ///
    /// Says type of this message.
    ///
    var reason: CargoDTO.Reason { get set }
}
///
/// Uses 0.21.1 source code.
/// https://github.com/rust-lang/cargo/tree/6084a2ba03aaa73794e6b86199e463ea6df290fe
///
enum CargoDTO {
    enum Message: Decodable {
        case compilerMessage(FromCompiler)
        case compilerArtifact(Artifact)
        case buildScript(BuildScript)

        init(from decoder: Decoder) throws {
            enum Field: String, CodingKey {
                case reason
            }
            let container = try decoder.container(keyedBy: Field.self)
            let rawReason = try container.decode(String.self, forKey: Field.reason)
            guard let reason = Reason(rawValue: rawReason) else {
                throw DecodingError.dataCorruptedError(forKey: Field.reason, in: container, debugDescription: "Unknown `reason` value: \(rawReason)")
            }
            switch reason {
            case .compiler_message:
                self = .compilerMessage(try FromCompiler(from: decoder))
            case .compiler_artifact:
                self = .compilerArtifact(try Artifact(from: decoder))
            case .build_script_executed:
                self = .buildScript(try BuildScript(from: decoder))
            }
        }
    }

    enum Reason: String, Decodable {
        case compiler_message = "compiler-message"
        case compiler_artifact = "compiler-artifact"
        case build_script_executed = "build-script-executed"
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6084a2ba03aaa73794e6b86199e463ea6df290fe/src/cargo/util/machine_message.rs#L17
    ///
    struct FromCompiler: CargoDTOMessageProtocol, Decodable {
        var reason: Reason
        var package_id: PackageId
        var target: Target
        var message: RustCompilerDTO.Diagnostic
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6084a2ba03aaa73794e6b86199e463ea6df290fe/src/cargo/util/machine_message.rs#L30
    ///
    struct Artifact: CargoDTOMessageProtocol, Decodable {
        var reason: Reason
        var package_id: PackageId
        var target: Target
        var profile: Profile
        var features: [String]
        var filenames: [String]
        var fresh: Bool
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6084a2ba03aaa73794e6b86199e463ea6df290fe/src/cargo/util/machine_message.rs#L49
    ///
    struct BuildScript: CargoDTOMessageProtocol, Decodable {
        var reason: Reason
        var package_id: PackageId
        var linked_libs: [String]
        var linked_paths: [String]
        var cfgs: [String]
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6084a2ba03aaa73794e6b86199e463ea6df290fe/src/cargo/core/package_id.rs#L17
    ///
    typealias PackageId = String
//    struct PackageId {
//        var inner: PackageIdInner
//    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6084a2ba03aaa73794e6b86199e463ea6df290fe/src/cargo/core/package_id.rs#L22
    ///
    struct PackageIdInner: Decodable {
        var name: String
        var version: Version
        var source_id: SourceId
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6084a2ba03aaa73794e6b86199e463ea6df290fe/src/cargo/core/manifest.rs#L178
    ///
    public struct Target: Decodable {
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
    /// https://github.com/rust-lang/cargo/blob/6084a2ba03aaa73794e6b86199e463ea6df290fe/src/cargo/core/manifest.rs#L102
    ///
    public enum TargetKind: Decodable {
        case lib([LibKind])
        case bin
        case test
        case bench
        case example
        case customBuild

        public init(from decoder: Decoder) throws {
            var c = try decoder.unkeyedContainer()
            let v = try c.decode(String.self)
            self = try {
                switch v {
                case "lib":
                    var ks = [LibKind]()
                    while c.isAtEnd == false {
                        let k = try c.decode(LibKind.self)
                        ks.append(k)
                    }
                    return .lib(ks)
                case "bin":         return .bin
                case "test":        return .test
                case "bench":       return .bench
                case "example":     return .example
                case "customBuild": return .customBuild
                default:
                    throw DecodingError.dataCorruptedError(in: c, debugDescription: "Unknown enum case: \(v)")
                }
            }()
        }
    }
    ///
    /// https://github.com/rust-lang/cargo/blob/6084a2ba03aaa73794e6b86199e463ea6df290fe/src/cargo/core/manifest.rs#L75
    ///
    public enum LibKind: Decodable {
        case Lib
        case Rlib
        case Dylib
        case ProcMacro
        case Other(String)

        public init(from decoder: Decoder) throws {
            MARK_unimplemented()
        }
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6084a2ba03aaa73794e6b86199e463ea6df290fe/src/cargo/core/manifest.rs#L153
    ///
    public struct Profile: Decodable {
        var opt_level: String
        var debuginfo: UInt32
        var debug_assertions: Bool
        var test: Bool
    }

    ///
    /// https://github.com/rust-lang/cargo/blob/6084a2ba03aaa73794e6b86199e463ea6df290fe/src/cargo/core/source.rs#L102
    ///
    public struct SourceId: Decodable {
        var inner: SourceIdInner
    }
    ///
    /// https://github.com/rust-lang/cargo/blob/6084a2ba03aaa73794e6b86199e463ea6df290fe/src/cargo/core/source.rs#L107
    ///
    public struct SourceIdInner: Decodable {
        var url: URL
        var canonical_url: URL
        var kind: Kind
        var precise: String?
    }
    ///
    /// https://github.com/rust-lang/cargo/blob/6084a2ba03aaa73794e6b86199e463ea6df290fe/src/cargo/core/source.rs#L80
    ///
    enum Kind: Decodable {
        case Git(GitReference)
        case Path
        case Registry
        case LocalRegistry
        case Directory

        init(from decoder: Decoder) throws {
            MARK_unimplemented()
        }
    }
    ///
    /// https://github.com/rust-lang/cargo/blob/6084a2ba03aaa73794e6b86199e463ea6df290fe/src/cargo/core/source.rs#L94
    ///
    enum GitReference: Decodable {
        case Tag(String)
        case Branch(String)
        case Rev(String)

        init(from decoder: Decoder) throws {
            MARK_unimplemented()
        }
    }

//    enum Message: Codable {
//        case compilerMessage
//        case rust(Diagnostic)
//
//        init(from decoder: Decoder) throws {
//            MARK_unimplemented()
//        }
//        func encode(to encoder: Encoder) throws {
//            MARK_unimplemented()
//        }
//    }

    typealias Version = SemverDTO.Version
    typealias Diagnostic = RustCompilerDTO.Diagnostic
    typealias JSON = JSONValue
}
