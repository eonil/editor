//
//  main.swift
//  InternalTests
//
//  Created by Hoon H. on 11/7/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation





//let	s1	=	Semaphore()
//let	s2	=	Semaphore()
//
//background {
//	s1.wait()
//	println("A")
//}
//background {
//	s2.wait()
//	println("B")
//	s2.wait()
//	println("C")
//}
//
//sleep(1)
//s1.signal()
//sleep(1)
//s2.signal()
//sleep(1)
//s2.signal()
//sleep(1)


//
//let	s1	=	Semaphore()
//let	s2	=	Semaphore()
//
//background {
//	s2.wait()
//	s1.wait()
//	println("A")
//}
//
//sleep(1)
//s1.signal()
//s2.signal()
//sleep(1)
//








//var	countner1	=	0
//func spawn1() {
//	let	n	=	++countner1
//	println("start = \(n)")
//	if n < 100 {
//		Fiber.spawn(spawn1)
//	}
//	println("end = \(n)")
//}
//
//let	s1	=	Semaphore()
//
//
//background {
//	spawn1()
//	
//	s1.wait()
//	println("DONE!")
//}
//
//
//sleep(100)












//testAtomicTransmission()
//testProgressiveDownload()
testProgressiveDownload1()
//testProgressiveDownload2()




