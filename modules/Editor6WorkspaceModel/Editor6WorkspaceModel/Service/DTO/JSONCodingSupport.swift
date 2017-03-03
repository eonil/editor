//
//  JSONCodingSupport.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/04.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilJSON

enum JSONDecodingError: Error {
    case missingField(String)
    case badlyFormedEnum
    case typeMismatch(expected: Any.Type, reality: JSONValue)
    case missingEnumCase(String, in: Any.Type)

}

protocol JSONDecodable {
    init(json: JSONValue) throws
}
extension JSONValue {
    func ed6_getField<T>(_ name: String) throws -> T where T: JSONDecodable {
        guard let v = object?[name] else { throw JSONDecodingError.missingField(name) }
        let o = try T(json: v)
        return o
    }
    func ed6_getField<T>(_ name: String) throws -> T? where T: JSONDecodable {
        guard let v = object?[name] else { return nil }
        let o = try T(json: v)
        return o
    }
    func ed6_getField<T>(_ name: String) throws -> [T] where T: JSONDecodable {
        guard let fieldValueJSON = object?[name] else { throw JSONDecodingError.missingField(name) }
        guard let a = fieldValueJSON.array else { throw JSONDecodingError.typeMismatch(expected: JSONArray.self, reality: fieldValueJSON) }
        let b = try a.map(T.init)
        return b
    }
    func ed6_getField<T>(_ name: String) throws -> T where T: JSONDecodable, T: RawRepresentable, T.RawValue == String {
        guard let fieldValueJSON = object?[name] else { throw JSONDecodingError.missingField(name) }
        guard let s = fieldValueJSON.string else { throw JSONDecodingError.typeMismatch(expected: String.self, reality: fieldValueJSON) }
        guard let v = T(rawValue: s) else { throw JSONDecodingError.missingEnumCase(s, in: T.self) }
        return v
    }
}

extension Bool: JSONDecodable {
    init(json: JSONValue) throws {
        guard let v = json.boolean else { throw JSONDecodingError.typeMismatch(expected: Bool.self, reality: json) }
        self = v
    }
}
extension UInt32: JSONDecodable {
    init(json: JSONValue) throws {
        guard let v = json.number?.int64 else { throw JSONDecodingError.typeMismatch(expected: Int64.self, reality: json) }
        guard let u = UInt32(exactly: v) else { throw JSONDecodingError.typeMismatch(expected: UInt32.self, reality: json) }
        self = u
    }
}
extension UInt64: JSONDecodable {
    init(json: JSONValue) throws {
        // - TODO: See below.
        // - FIXME: `Int64` cannot represent all range of `UInt64` value.
        //      This needs modificaiton of JSON decoding facility to support them properly.
        guard let v = json.number?.int64 else { throw JSONDecodingError.typeMismatch(expected: Int64.self, reality: json) }
        guard let u = UInt64(exactly: v) else { throw JSONDecodingError.typeMismatch(expected: UInt64.self, reality: json) }
        self = u
    }
}
extension String: JSONDecodable {
    init(json: JSONValue) throws {
        guard let v = json.string else { throw JSONDecodingError.typeMismatch(expected: String.self, reality: json) }
        self = v
    }
}
extension URL: JSONDecodable {
    init(json: JSONValue) throws {
        guard let v = json.string else { throw JSONDecodingError.typeMismatch(expected: String.self, reality: json) }
        guard let u = URL(string: v) else { throw JSONDecodingError.typeMismatch(expected: URL.self, reality: json) }
        self = u
    }
}
