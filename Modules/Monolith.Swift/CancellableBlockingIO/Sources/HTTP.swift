//
//  HTTP.swift
//  EonilBlockingAsynchronousIO
//
//  Created by Hoon H. on 11/7/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


public struct HTTP {
	
	///	Performs progressvive HTTP download in asynchronous manner.
	///
	///	Usage:
	///
	///		let	downloading1	=	HTTP.downloadProgressively(NSURL(string: "https://www.ietf.org/rfc/rfc-index.xml")!)
	///
	///		background {
	///			let	s2	=	Semaphore()
	///			s2.wait(1)
	///			downloading1.cancel()
	///		}
	///
	///		var cont1			=	true
	///		PROGRESS: while true {
	///			switch downloading1.progress() {
	///			case let .Continue(s):	println(s)
	///			case .Done:				break PROGRESS
	///			}
	///		}
	///		let	cmpl1			=	downloading1.complete()
	///		println(cmpl1)
	///
	///	This uses `NSURLSessionDownloadTask` internally.
	///
	public static func downloadProgressively2(location:NSURL, cancellation:Trigger) -> ProgressiveDownloading2 {
		return	ProgressiveDownloading2(address: location, cancellation: cancellation)
	}
	
//	public static func downloadProgressively(location:NSURL, cancellation:Cancellation) -> ProgressiveDownloading {
//		return	ProgressiveDownloading(cancellation: cancellation, address: location)
//	}
	
	
	public static func transmit(request:AtomicTransmission.Request, _ cancellation:Trigger) -> AtomicTransmission.Complete {
		return	AtomicTransmission.execute(request, cancellation: cancellation)
	}
}























