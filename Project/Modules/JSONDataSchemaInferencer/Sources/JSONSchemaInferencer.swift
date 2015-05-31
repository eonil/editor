//
//  JSONSchemaInferencer.swift
//  IrregularDataSchemaInferencingMachine
//
//  Created by Hoon H. on 11/16/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//


import Foundation
import Standards



func inferJSONSchema(v:JSON.Value) -> JSONSchemaInference {
	let	p1	=	JSONSchemaInference()
	var	c1	=	0
	walkJSONTree(DiscoveryPath(), v) { (path:DiscoveryPath, value:JSON.Value) -> () in
		p1.notifyValueDiscoveryAtPath(path, value: value)
		c1++
	}
	
	for (path,types) in p1.pathSampleMap {
		Debug.log("discover path = \(path), type = \(types.allKeys)")
	}
	Debug.log("path samples: \(c1)")
	return	p1
}

private func walkJSONTree(path:DiscoveryPath, v:JSON.Value, f:(path:DiscoveryPath, value: JSON.Value)->()) {
	f(path: path, value: v)
	switch v {
	case .Object(let s):
		f(path: path, value: v)
		for (k,v2) in s {
			let	p2	=	path.pathByAppendingComponent(DiscoveryPathComponent.Field(name: k))
			walkJSONTree(p2, v2, f)
		}
		
	case .Array(let s):
		for i in 0..<s.count {
			let	m	=	s[i]
			let	p2	=	path.pathByAppendingComponent(DiscoveryPathComponent.Array)
			walkJSONTree(p2, m, f)
		}
		
	default:	break
	}
}














///	Assumes all elements in an array are instance of single entity except atomic types.
class JSONSchemaInference {
	typealias	TypeCountMap	=	DictionaryWithTimeOrder<DiscoveryDataType,Int>
	typealias	PathSampleMap	=	DictionaryWithTimeOrder<DiscoveryPath,TypeCountMap>
	
	var	pathSampleMap	=	PathSampleMap()
	
	init() {
		
	}
}

extension JSONSchemaInference {
	///	This includes paths with multiple data types.
	func queryAllPathsForDataType(t:DiscoveryDataType) -> [DiscoveryPath] {
		var	a1	=	[] as [DiscoveryPath]
		for (path,sample) in pathSampleMap {
			if sample[t] != nil {
				a1.append(path)
			}
		}
		return	a1
	}
	
	func queryDirectChildrenOfPath(p:DiscoveryPath) -> [DiscoveryPath] {
		var	a1	=	[] as [DiscoveryPath]
		for (path,sample) in pathSampleMap {
			if path.components.count > 0 && path.pathByDeletingLastComponent() == p {
				a1.append(path)
			}
		}
		return	a1
	}
}
extension JSONSchemaInference {
	
	func notifyValueDiscoveryAtPath(path:DiscoveryPath, value:JSON.Value) {
		switch value {
		case .Object(let s):	(path, DiscoveryDataType.Composite)	>>> add
		case .Array(let s):		(path, DiscoveryDataType.List)		>>> add
		case .String(let s):	(path, DiscoveryDataType.Text)		>>> add
		case .Number(let s):
			switch s {
			case .Integer(_):	(path, DiscoveryDataType.Int)		>>> add
			case .Float(_):		(path, DiscoveryDataType.Real)		>>> add
			}
		case .Boolean(let s):	(path, DiscoveryDataType.Bool)		>>> add
		case .Null:				(path, DiscoveryDataType.Nil)		>>> add
		}
	}
	
	private func add(path:DiscoveryPath, _ type:DiscoveryDataType) {
		var	m1	=	pathSampleMap.valueForKey(path, setIfDoesNotExists: TypeCountMap())
		var	m2	=	m1.valueForKey(type, setIfDoesNotExists: 0)
		m1[type]			=	m2 + 1
		pathSampleMap[path]	=	m1
	}
}








struct DiscoveryPath {
	var	components	=	[] as [DiscoveryPathComponent]
	
	init() {
	}
}
enum DiscoveryPathComponent {
	case Array
	case Field(name:String)
}
func == (left:DiscoveryPath, right:DiscoveryPath) -> Bool {
	return	left.components == right.components
}
func == (left:DiscoveryPathComponent, right:DiscoveryPathComponent) -> Bool {
	switch (left, right) {
	case (DiscoveryPathComponent.Array,	DiscoveryPathComponent.Array):						return	true
	case (DiscoveryPathComponent.Field(let a), DiscoveryPathComponent.Field(let b)):		return	a == b
	default:																				return	false
	}
}
extension DiscoveryPathComponent : Printable, Hashable {
	var fieldName:String? {
		get {
			switch self {
			case .Field(let s):	return	s.name
			default:			return	nil
			}
		}
	}
	var description:String {
		get {
			switch self {
			case .Array(let s):	return	"[]"
			case .Field(let s):	return	".\(s.name)"
			}
		}
	}
	var hashValue:Int {
		get {
			switch self {
			case .Array(let s):	return	0
			case .Field(let s):	return	s.name.hashValue
			}
		}
	}
}
extension DiscoveryPath : Printable, Hashable {
	var description:String {
		get {
			return	components.map({$0.description}).reduce("", combine: +)
		}
	}
	var hashValue:Int {
		get {
			return	components.count == 0 ? 0 : components.last!.hashValue
		}
	}
	func pathByAppendingComponent(c:DiscoveryPathComponent) -> DiscoveryPath {
		var	p2	=	self
		p2.components.append(c)
		return	p2
	}
	func pathByDeletingLastComponent() -> DiscoveryPath {
		var	p2	=	self
		p2.components.removeLast()
		return	p2
	}
	var lastComponent:DiscoveryPathComponent? {
		get {
			return	components.last
		}
	}
	var	pathByStrippingAwayArrayComponents:DiscoveryPath {
		get {
			var	p2	=	DiscoveryPath()
			for c1 in self.components {
				if c1.fieldName != nil {
					p2.components.append(c1)
				}
			}
			return	p2
		}
	}
}









enum DiscoveryDataType {
	case Composite
	case List
	case Text
	case Int
	case Real
	case Bool
	case Nil
}
extension DiscoveryDataType : Printable {
	var description:String {
		get {
			switch self {
			case .Composite:	return	"Composite"
			case .List:			return	"List"
			case .Text:			return	"Text"
			case .Int:			return	"Int"
			case .Real:			return	"Real"
			case .Bool:			return	"Bool"
			case .Nil:			return	"Nil"
			}
		}
	}
}















//class TupleDiscovery {
//	var	path		:	DiscoveryPath
//	
//	init(path:DiscoveryPath) {
//		self.path		=	path
//	}
//}
//
//
//
//
//
//
//class ListDiscovery {
//	var	path			:	DiscoveryPath
//	var	possibleTypes	=	[] as [DiscoveryDataType]
//	
//	init(path:DiscoveryPath) {
//		self.path	=	path
//	}
//}
//
//
//
//
//
//
//class FieldDiscovery {
//	var	name			:	String
//	var	possibleTypes	=	[] as [DiscoveryDataType]
//	var	occurrence		=	0
//	
//	init(name:String) {
//		self.name	=	name
//	}
//}























































infix operator >>> {
}
func >>> <T,U> (v:T, f:T->U) -> U {
	return	f(v)
}
