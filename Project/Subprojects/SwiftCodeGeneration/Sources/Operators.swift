//
//  Operators.swift
//  DataConverterClassGenerator
//
//  Created by Hoon H. on 11/16/14.
//
//

import Foundation


infix operator <<< {
	precedence	0
}

func <<< <T,U> (a:T->U, b:T) -> U {
	return	a(b)
}







