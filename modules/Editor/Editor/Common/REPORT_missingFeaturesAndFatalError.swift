//
//  REPORT_missingFeaturesAndFatalError.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/18.
//  Copyright © 2017 Eonil. All rights reserved.
//

func REPORT_missingFeaturesAndFatalError() -> Never {
    let msg = "`features` is missing. Anyway, operation becomes no-op."
    DEBUG_log(msg)
    fatalError(msg)
}
