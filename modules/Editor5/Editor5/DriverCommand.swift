//
//  DriverCommand.swift
//  Editor5
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

/// Commands that are accepted by `Driver`.
enum DriverCommand {
    case openWorkspace(at: URL)
    case closeWorkspace(at: URL)
}
