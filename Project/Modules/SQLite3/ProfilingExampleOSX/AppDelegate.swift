//
//  AppDelegate.swift
//  ProfilingExampleOSX
//
//  Created by Hoon H. on 11/9/14.
//
//

import Cocoa
import Foundation
import EonilSQLite3

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


	func applicationDidFinishLaunching(aNotification: NSNotification) {
		let	db1	=	Database(location: Connection.Location.TemporaryFile, editable: true)
		db1.apply {
			
			db1.schema.create(tableName: "T1", keyColumnNames: ["k1"], dataColumnNames: ["v1", "v2", "v3"])
			
			let	t1	=	db1.tables["T1"]
			let	ds1	=	t1.dictionaryView
			
			for i in 0..<8192 {
				ds1[Value.Integer(Int64(i))]	=	[
					"v1": "Here be dragons.",
					"v2": "Here be dragons.",
					"v3": "Here be dragons.",
				]
			}
			
			println("DONE!")
		}
	}

	

}




