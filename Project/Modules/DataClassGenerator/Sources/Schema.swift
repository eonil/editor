//
//  Schema.swift
//  DataConverterClassGenerator
//
//  Created by Hoon H. on 11/16/14.
//
//

import Foundation





class Schema {
	var	entities	=	[] as [Entity]
}

class Entity {
	var	space	=	Path()
	var	type	=	""
	var	name	=	""
	var	slots	=	[] as [Slot]
}

class Slot {
	var	name		=	""
	var	type		=	""
	var	optional	=	false
	var	collection	=	false
}

class Path {
	var	components	=	[] as [String]
}