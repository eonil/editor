//
//  Result.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/16.
//  Copyright © 2017 Eonil. All rights reserved.
//

enum Result<Value,Issue> {
    case failure(Issue)
    case success(Value)
}
