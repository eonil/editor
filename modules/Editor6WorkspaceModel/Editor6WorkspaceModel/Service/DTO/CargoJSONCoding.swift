//
//  CargoJSONCoding.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/04.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilJSON

extension CargoDTO.FromCompiler: JSONDecodable {
    init(json: JSONValue) throws {
        reason      =   try json.ed6_getField("reason")
        package_id  =   try json.ed6_getField("package_id")
        target      =   try json.ed6_getField("target")
        message     =   json.object?["message"] ?? JSONValue.null()
    }
}
extension CargoDTO.Artifact: JSONDecodable {
    init(json: JSONValue) throws {
        reason      =   try json.ed6_getField("reason")
        package_id  =   try json.ed6_getField("package_id")
        target      =   try json.ed6_getField("target")
        profile     =   try json.ed6_getField("profile")
        feature     =   try json.ed6_getField("feature")
        filenames   =   try json.ed6_getField("filenames")
    }
}
extension CargoDTO.BuildScript: JSONDecodable {
    init(json: JSONValue) throws {
        reason      	=   try json.ed6_getField("reason")
        package_id      =   try json.ed6_getField("package_id")
        linked_libs     =   try json.ed6_getField("linked_libs")
        linked_paths    =   try json.ed6_getField("linked_paths")
        cfgs            =   try json.ed6_getField("cfgs")
    }
}
extension CargoDTO.PackageId: JSONDecodable {
    init(json: JSONValue) throws {
        inner       =   try json.ed6_getField("inner")
    }
}
extension CargoDTO.PackageIdInner: JSONDecodable {
    init(json: JSONValue) throws {
        name        =   try json.ed6_getField("name")
        version     =   try json.ed6_getField("version")
        source_id   =   try json.ed6_getField("source_id")
    }
}
extension CargoDTO.Target: JSONDecodable {
    init(json: JSONValue) throws {
        kind        =   try json.ed6_getField("kind")
        name        =   try json.ed6_getField("name")
        src_path    =   try json.ed6_getField("src_path")
        tested      =   try json.ed6_getField("tested")
        benched     =   try json.ed6_getField("benched")
        doc         =   try json.ed6_getField("doc")
        doctest     =   try json.ed6_getField("doctest")
        harness     =   try json.ed6_getField("harness")
        for_host    =   try json.ed6_getField("for_host")
    }
}
extension CargoDTO.TargetKind: JSONDecodable {
    init(json: JSONValue) throws {
        guard let a = json.array else { throw JSONDecodingError.typeMismatch(expected: JSONArray.self, reality: json) }
        guard a.count >= 1 else { throw JSONDecodingError.badlyFormedEnum }
        guard let s = a[0].string else { throw JSONDecodingError.typeMismatch(expected: String.self, reality: a[0]) }
        func makeValue() throws -> CargoDTO.TargetKind {
            switch s {
            case "lib":
                let params = Array(a.dropFirst())
                return .Lib(try params.map(CargoDTO.LibKind.init))
            case "bin":
                return .Bin
            case "test":
                return .Test
            case "bench":
                return .Bench
            case "example":
                return .Example
            case "custombuild":
                return .CustomBuild
            default:
                throw JSONDecodingError.badlyFormedEnum
            }
        }
        self = try makeValue()
    }
}
extension CargoDTO.LibKind: JSONDecodable {
    init(json: JSONValue) throws {
        fatalError("I have no idea how this would be encoded, so I cannot decode now... Implement this once I get a sample.")
    }
}
extension CargoDTO.Profile: JSONDecodable {
    init(json: JSONValue) throws {
        opt_level           =   try json.ed6_getField("opt_level")
        debuginfo           =   try json.ed6_getField("debuginfo")
        debug_assertions    =   try json.ed6_getField("debug_assertions")
        test                =   try json.ed6_getField("test")

    }
}
extension CargoDTO.SourceId: JSONDecodable {
    init(json: JSONValue) throws {
        inner               =   try json.ed6_getField("inner")
    }
}
extension CargoDTO.SourceIdInner: JSONDecodable {
    init(json: JSONValue) throws {
        url             =   try json.ed6_getField("url")
        canonical_url   =   try json.ed6_getField("canonical_url")
        kind            =   try json.ed6_getField("kind")
        precise         =   try json.ed6_getField("precise")
    }
}
extension CargoDTO.Kind: JSONDecodable {
    init(json: JSONValue) throws {
        fatalError("I have no idea how this would be encoded, so I cannot decode now... Implement this once I get a sample.")
    }
}
extension CargoDTO.GitReference: JSONDecodable {
    init(json: JSONValue) throws {
        fatalError("I have no idea how this would be encoded, so I cannot decode now... Implement this once I get a sample.")
    }
}
extension CargoDTO.Message: JSONDecodable {
    init(json: JSONValue) throws {
        fatalError("I have no idea how this would be encoded, so I cannot decode now... Implement this once I get a sample.")
    }
}
