//
//  Target.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

struct Target {
    var name: String
    ///
    /// Location to file which defines this target.
    ///
    var definedIn: URL
    ///
    /// Where the executable file to be placed.
    ///
    var executableLocation: URL
}
