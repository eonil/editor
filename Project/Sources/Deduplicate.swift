////
////  Deduplicate.swift
////  RustCodeEditor
////
////  Created by Hoon H. on 11/12/14.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//
//
//func deduplicate<T:AnyObject>(os:[T]) -> [T] {
//	var	d1	=	[:] as [ObjectIdentifier:T]
//	for	o in os {
//		d1[ObjectIdentifier(o)]	=	o
//	}
//	return	[T](d1.values)
//}
//
