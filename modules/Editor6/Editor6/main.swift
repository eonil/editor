//
//  main.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/08.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Darwin

var exitCode = Int32?.none
do {
    let driver = Driver2()
    exitCode = driver.run()
}
guard let exitCode = exitCode else { fatalError("Could not resolve exit-code.") }
exit(exitCode)
