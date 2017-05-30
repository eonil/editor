//
//  SemverJSONCoding.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/04.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilJSON

extension SemverDTO.Version: JSONDecodable {
    init(json: JSONValue) throws {
        major   =   try json.ed6_getField("major")
        minor   =   try json.ed6_getField("minor")
        patch   =   try json.ed6_getField("patch")
        pre     =   try json.ed6_getField("pre")
        build   =   try json.ed6_getField("build")

    }
}
extension SemverDTO.Identifier: JSONDecodable {
    init(json: JSONValue) throws {
        fatalError("I have no idea how this would be encoded, so I cannot decode now... Implement this once I get a sample.")
    }
}
