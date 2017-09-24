//
//  Codable.extension.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilJSON

extension Decodable {
    static func from(jsonCode s: String) throws -> Self {
        guard let d = s.data(using: .utf8) else { throw DecodableFromJSONCodeIssue.cannotEncodeIntoData }
        let d1 = try JSONDecoder().decode(Self.self, from: d)
        return d1
    }
}

private enum DecodableFromJSONCodeIssue: Error {
    case cannotEncodeIntoData
}
