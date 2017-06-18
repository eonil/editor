//
//  main.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/08.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Darwin

let exitCode: Int32
do {
    let app = App()
    exitCode = app.run()
}
exit(exitCode)
