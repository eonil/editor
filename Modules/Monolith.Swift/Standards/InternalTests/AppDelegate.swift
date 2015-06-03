//
//  AppDelegate.swift
//  InternalTests
//
//  Created by Hoon H. on 11/15/14.
//
//

import Cocoa



struct Tests {
	static func runAll() {
		RFC1866.Test.run()
		RFC3339.Test.run()
		RFC2616.Test.run()
		RFC4627.Test.run()
		println("All test OK.")
	}
}





@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


	func applicationDidFinishLaunching(aNotification: NSNotification) {
		Tests.runAll()
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

