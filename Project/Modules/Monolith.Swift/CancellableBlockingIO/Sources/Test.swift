//
//  Test.swift
//  EonilCancellableBlockingIO
//
//  Created by Hoon H. on 11/7/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation



//func testProgressiveDownload() {
//	
//	
//	let	s1	=	Semaphore()
//	
//	background {
//		let	c1				=	Cancellation()
//		let	downloading1	=	HTTP.downloadProgressively(NSURL(string: "https://www.ietf.org/rfc/rfc-index.xml")!, cancellation: c1)
//		
//		background {
//			let	s2	=	Semaphore()
//			s2.wait(1)
////			downloading1.cancel()
//			c1.signalCancel()
//		}
//		
//		var cont1			=	true
//		PROGRESS: while true {
//			switch downloading1.progress() {
//			case let .Continue(s):	println(s)
//			case .Done:				break PROGRESS
//			}
//		}
//		let	cmpl1			=	downloading1.complete()
//		println(cmpl1)
//		
//		s1.signal()
//	}
//	
//	sleep(2)
//	s1.wait()
//	
//}

func testProgressiveDownload1() {
	let	s1	=	Semaphore()
	background {
		let	c1				=	Trigger()
		let	downloading1	=	HTTP.downloadProgressively2(NSURL(string: "https://www.ietf.org/rfc/rfc-index.xml")!, cancellation: c1)
		
		var cont1			=	true
		PROGRESS: while true {
			switch downloading1.progress() {
			case .Continue(let s):	println(s)
			case .Done:				break PROGRESS
			}
		}
		let	cmpl1			=	downloading1.complete()
		println(cmpl1)
		
		s1.signal()
	}
	s1.wait()
}
//func testProgressiveDownload2() {
//	
//	let	s1	=	Semaphore()
//	
//	background {
//		let	c1				=	PromiseOf<()>()
//		let	downloading1	=	HTTP.downloadProgressively2(NSURL(string: "https://www.ietf.org/rfc/rfc-index.xml")!, cancellation: c1.future)
//		
//		background {
//			let	s2	=	Semaphore()
//			s2.wait(2)
//			c1.set()
//		}
//		
//		var cont1			=	true
//		PROGRESS: while true {
//			switch downloading1.progress() {
//			case .Continue(let s):	println(s)
//			case .Done:				break PROGRESS
//			}
//		}
//		let	cmpl1			=	downloading1.complete()
//		println(cmpl1)
//		
//		s1.signal()
//	}
//	
//	sleep(2)
//	s1.wait()
//	
//}



func testAtomicTransmission() {
	let	c1	=	Trigger()
	let	r1	=	HTTP.AtomicTransmission.Request(security: false, method: "GET", host: "www.ietf.org", port: 80, path: "/rfc/rfc-index.xml", headers: [], body: NSData())

	switch HTTP.transmit(r1, c1) {
	case .Cancel:			println("CANCELED by PROGRAMMER!")
	case .Abort(let s):		println("Abort: \(s)")
	case .Done(let s):
		println("Done: \(s)")
		let	s3	=	NSString(data: s.body!, encoding: NSUTF8StringEncoding)
		println(s3)
	}
}



















