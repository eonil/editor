//
//  ObjectiveCRuntime.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/10.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation



struct ObjectiveC {
	struct Runtime {
		static func getStrongAssociationOf(host:NSObject, key:UnsafePointer<()>) -> AnyObject? {
			return	objc_getAssociatedObject(host, key)
		}
		static func setStrongAssociationOf(host:NSObject, key:UnsafePointer<()>, guest:AnyObject?) {
			objc_setAssociatedObject(host, key, guest, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
		}
//		static func getWeakAssociationOf(host:NSObject, key:UnsafePointer<()>) -> AnyObject? {
//			return	objc_getAssociatedObject(host, key)
//		}
//		static func setWeakAssociationOf(host:NSObject, key:UnsafePointer<()>, guest:AnyObject?) {
//			objc_setAssociatedObject(host, key, guest, objc_AssociationPolicy(OBJC_ASSOCIATION_ASSIGN))
//		}
	}
}
