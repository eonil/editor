//
//  Common.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 10/31/14.
//
//

import Foundation



func combine <K,V> (keys:[K], values:[V]) -> [K:V] {
	precondition(keys.count == values.count)
	
	var	d	=	[:] as [K:V]
	for i in 0..<keys.count {
		d[keys[i]]	=	values[i]
	}
	return	d
}

func collect <T:GeneratorType> (g:T) -> [T.Element] {
	var	c	=	[] as [T.Element]
	var g2	=	g
	while let m = g2.next() {
		c.append(m)
	}
	return	c
}
//func collect <T:SequenceType> (c:T) -> [T.Generator.Element] {
//	return	collect(c.generate())
//}

func linkWeakly <T where T: AnyObject> (target:T) -> ()->T? {
	weak var	value	=	target as T?
	return	{
		return	value
	}
}







///	MARK:
///	MARK:	Operators

infix operator >>>> {

}
//infix operator >>>>? {
//
//}
//infix operator >>>>! {
//
//}

internal func >>>> <T,U> (value:T, function:T->U) -> U {
	return	function(value)
}
//func >>>>? <T,U> (value:T?, function:T->U) -> U? {
//	return	value == nil ? nil : function(value!)
//}
//func >>>>! <T,U> (value:T!, function:T->U) -> U {
//	precondition(value != nil, "Supplied value `T` shouldn't be `nil`.")
//	return	function(value!)
//}





infix operator ||| {

}

internal func ||| <T> (value:T?, substitude:T) -> T {
	return	value == nil ? substitude : value!
}


















