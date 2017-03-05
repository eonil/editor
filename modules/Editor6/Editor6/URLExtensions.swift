//
//  URLExtensions.swift
//  Editor6
//
//  Created by Hoon H. on 2017/03/05.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

extension URL {
    func editor6_makeRepoName() -> String? {
        return lastPathComponent.components(separatedBy: ".").first
    }
}
