//
//  AppDelegate.swift
//  TestApplication
//
//  Created by Hoon H. on 11/9/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Cocoa
import EonilCancellableBlockingIO


class Tester {
	let	cancellation	=	Trigger()
	func run() {
		let	q1	=	HTTP.AtomicTransmission.Request(security: false, method: "GET", host: "apple.com", port: 80, path: "/", headers: [], body: NSData())
		
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
			let	a1	=	HTTP.transmit(q1, self.cancellation)
			
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				debugPrintln(a1)
			})
		})
	}
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	let	tester	=	Tester()

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		tester.run()
	}
	
	@IBAction
	func cancelIO(sender:AnyObject?) {
		tester.cancellation.set()
	}

}

