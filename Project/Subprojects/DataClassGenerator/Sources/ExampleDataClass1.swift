
//
//  ExampleDataClass1.swift
//  DataConverterClassGenerator
//
//  Created by Hoon H. on 11/16/14.
//
//

import Foundation





struct Root {
	
}

extension Root {
	struct ExampleDataEntity1 {
		var	field1:String
		var	field2:Int?
		var	field3:Root.ExampleDataEntity1.Subentity1
		
		init(field1:String, field2:Int?, field3:Root.ExampleDataEntity1.Subentity1) {
			self.field1	=	field1
			self.field2	=	field2
			self.field3	=	field3
		}
		init?(field1:String?, field2:Int?, field3:Root.ExampleDataEntity1.Subentity1?) {
			if field1 == nil { return nil }
			if field3 == nil { return nil }
			self.field1	=	field1!
			self.field2	=	field2!
			self.field3	=	field3!
		}
	}
}
extension Root.ExampleDataEntity1 {
	struct Subentity1 {
		var	field1:String
		var	field2:Int?
		
		init(field1:String, field2:Int?) {
			self.field1	=	field1
			self.field2	=	field2
		}
		init?(field1:String?, field2:Int?) {
			if field1 == nil { return nil }
			self.field1	=	field1!
			self.field2	=	field2!
		}
	}
}



struct DynamicExampleDataEntity1 {
	var	data:Root.ExampleDataEntity1
	func valueForName(name:String) -> Any? {
		switch name {
		case "field1":	data.field1
		case "field2":	data.field2
		case "field3":	data.field3
		default:		break
		}
		fatalError("Bad name.")
	}
	mutating func setValueForName(name:String, value:Any?) {
		switch name {
		case "field1":	data.field1	=	value as String
		case "field2":	data.field2	=	value as Int?
		case "field3":	data.field3	=	value as Root.ExampleDataEntity1.Subentity1
		default:		break
		}
		fatalError("Bad name.")
	}
}

func readValueDynamically(inout data:Root.ExampleDataEntity1, name:String) -> Any? {
	switch name {
	case "field1":	return	data.field1
	case "field2":	return	data.field2
	case "field3":	return	data.field3
	default:		break
	}
	fatalError("Bad name.")
}
func writeValueDynamically(inout data:Root.ExampleDataEntity1, name:String, value:Any?) {
	switch name {
	case "field1":	data.field1	=	value as String
	case "field2":	data.field2	=	value as Int?
	case "field3":	data.field3	=	value as Root.ExampleDataEntity1.Subentity1
	default:		fatalError("Bad name.")
	}
}









