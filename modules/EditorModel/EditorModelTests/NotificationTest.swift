//
//  NotificationTest.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/24.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorModel

class Test1: ModelNotificationObserver, SubcategoryNotificationObserver {
	func processNotification(n: ModelNotification) {
		print((self, n))
	}
	func processNotification(n: FileNodeNotification) {
		print((self, n))
	}
}
class Test2: ModelNotificationObserver, SubcategoryNotificationObserver {
	func processNotification(n: ModelNotification) {
		print((self, n))
	}
	func processNotification(n: FileNodeNotification) {
		print((self, n))
	}
}
class Test3: ModelNotificationObserver, SubcategoryNotificationObserver {
	func processNotification(n: ModelNotification) {
		print((self, n))
	}
	func processNotification(n: FileNodeNotification) {
		print((self, n))
	}
}

func runTest1() {
	let	o1	=	Test1()
	let	o2	=	Test2()
	let	o3	=	Test3()
	ModelNotification.registerObserver(o1)
	ModelNotification.registerObserver(o2)
	ModelNotification.registerObserver(o3)
	//ModelNotification.ApplicationNotification.broadcast()

	FileNodeNotification.registerObserver(o1)
	FileNodeNotification.registerObserver(o2)
	FileNodeNotification.registerObserver(o3)
	ModelNotification.FileNodeNotification(FileNodeNotification.DidChangeComment(node: FileNodeModel(), old: "A", new: "B")).broadcast()

	FileNodeNotification.deregisterObserver(o2)
	FileNodeNotification.deregisterObserver(o3)
	ModelNotification.FileNodeNotification(FileNodeNotification.DidChangeComment(node: FileNodeModel(), old: "A", new: "B")).broadcast()
	FileNodeNotification.deregisterObserver(o1)
	

}
