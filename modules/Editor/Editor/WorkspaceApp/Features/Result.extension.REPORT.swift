//
//  Result.extension.REPORT.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/27.
//Copyright © 2017 Eonil. All rights reserved.
//

extension Result {
    var isFailure: Bool {
        switch self {
        case .failure(_):   return true
        default:            return false
        }
    }
}
