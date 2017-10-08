//
//  REPORT_missingIBOutletViewAndFatalError.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/18.
//  Copyright © 2017 Eonil. All rights reserved.
//

func REPORT_missingIBOutletViewAndFatalError() -> Never {
    let msg = "Some `@IBOutet` views are missing."
    DEBUG_log(msg)
    fatalError(msg)
}
