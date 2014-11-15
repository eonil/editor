//
//  DataSchema.swift
//  Editor
//
//  Created by Hoon H. on 11/16/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

class DataSchema {
	
	struct Entity {
		var	name:String
		var	properties		=	[] as [Property]
		var	subentities		=	[] as [Entity]
	}
	struct Property {
		var	name			=	""
		var	type			=	""
		var	description		=	Description()
	}
	
	struct Description {
		var	summary:String	=	""
		var	body:String		=	""
	}
	
}

class DataSchemaInferencer {
	func inferFromSample(
}