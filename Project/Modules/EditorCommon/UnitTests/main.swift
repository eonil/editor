//
//  main.swift
//  UnitTests
//
//  Created by Hoon H. on 2015/02/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

struct UnitTest {
	static func runAll() {
		testDiff()
		XML.Test.run()
	}
}

UnitTest.runAll()
