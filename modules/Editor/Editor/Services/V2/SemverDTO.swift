//
//  SemverDTO.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/01.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

struct SemverDTO {
    ///
    /// https://github.com/steveklabnik/semver/blob/master/src/version.rs#L57
    ///
    struct Version: Codable {
        var major: UInt64
        var minor: UInt64
        var patch: UInt64
        var pre: [Identifier]
        var build: [Identifier]
    }
    ///
    /// https://github.com/steveklabnik/semver/blob/master/src/version.rs#L29
    ///
    enum Identifier: Codable {
        case Numeric(UInt64)
        case AlphaNumeric(String)

        init(from decoder: Decoder) throws {
            MARK_unimplemented()
        }
        func encode(to encoder: Encoder) throws {
            MARK_unimplemented()
        }
    }
}
