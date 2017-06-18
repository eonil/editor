//
//  REPORT_fatalError.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

public func REPORT_fatalError() -> Never  {
    fatalError()
}
public func REPORT_fatalError(_ message: String) -> Never  {
    fatalError(message)
}

