//
//  SemverDTO.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/01.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

public struct SemverDTO {
    ///
    /// https://github.com/steveklabnik/semver/blob/master/src/version.rs#L57
    ///
    public struct Version {
        public var major: UInt64
        public var minor: UInt64
        public var patch: UInt64
        public var pre: [Identifier]
        public var build: [Identifier]
    }
    ///
    /// https://github.com/steveklabnik/semver/blob/master/src/version.rs#L29
    ///
    public enum Identifier {
        case Numeric(UInt64)
        case AlphaNumeric(String)
    }

}
