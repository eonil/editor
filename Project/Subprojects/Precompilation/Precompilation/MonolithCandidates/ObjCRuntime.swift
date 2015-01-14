//
//  ObjCRuntime.swift
//  Editor
//
//  Created by Hoon H. on 11/14/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


public struct ObjC {
	public static func getStrongAssociationOf(host:NSObject, key:UnsafePointer<()>) -> AnyObject? {
		return	objc_getAssociatedObject(host, key)
	}
	public static func setStrongAssociationOf(host:NSObject, key:UnsafePointer<()>, value:AnyObject?) {
		objc_setAssociatedObject(host, key, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
	}
	
//	public static func associationsOf<K:Hashable,V>(host:NSObject) -> ObjCAssociationsOf<K,V> {
//		return	ObjCAssociationsOf<K,V>(host)
//	}
}

//public struct ObjCAssociationsOf<K:Hashable,V> {
//	private let	host:AnyObject
//	private init<T:NSObject>(_ host:T) {
//		self.host	=	host
//	}
//	
//	public subscript(k:K) -> V? {
//		get {
//			if let c1 = objc_getAssociatedObject(host, AssociationsOf____KEY_FOR_STRONG_MAP) as Capsule<K,V>? {
//				return	c1.map[k]?
//			} else {
//				return	nil
//			}
//		}
//		set(v) {
//			var c1	=	objc_getAssociatedObject(host, AssociationsOf____KEY_FOR_STRONG_MAP) as Capsule<K,V>?
//			if c1 == nil {
//				c1	=	Capsule()
//				objc_setAssociatedObject(host, AssociationsOf____KEY_FOR_STRONG_MAP, c1, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
//			}
//			
//			c1!.map[k]	=	v
//			
//			if c1!.map.count == 0 {
//				objc_setAssociatedObject(host, AssociationsOf____KEY_FOR_STRONG_MAP, nil, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
//			}
//		}
//	}
//	
//}
//
//private final class Capsule<K:Hashable,V> : NSObject {
//	var	map	=	[:] as [K:V]
//}
//
//private let	AssociationsOf____KEY_FOR_STRONG_MAP	=	UnsafeMutablePointer<()>.alloc(1)