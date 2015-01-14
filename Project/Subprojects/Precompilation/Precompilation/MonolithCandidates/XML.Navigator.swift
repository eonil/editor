//
//  XML.Navigator.swift
//  RFC Formaliser
//
//  Created by Hoon H. on 10/28/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

extension XML {
	
	///	A convenient XML data structure navigator.
	///
	///	Typical usage
	///	-------------
	///
	///	In this given example XML;
	///
	///		<a>
	///			<b>CC</b>
	///		</a>
	///
	///	You can do this to get the `CC`.
	///
	///		let	a1	=	Navigator(element: getA())		//	Gets `<a/>` node (`XML.Element`).
	///		let	b2	=	a1["b"]
	///		let	c3	=	b2!.text
	///
	///	Or in one-liner.
	///
	///		let	c3	=	a1["b"]!.text
	///
	public struct Navigator {
		///	Current target element in DOM tree.
		public var	element:XML.Element

		public init(_ element:XML.Element) {
			self.element	=	element
		}
		
		public var name:String {
			get {
				return	element.name
			}
		}
		
		///	Reads concatenated characters of all direct text subnodes.
		public var text:String {
			get {
				//	Optimisation.
				if element.subnodes.count == 0 {
//				if element.subnodes.first == nil {		//	no diff in perf.
					return ""
				}
				//	Optimisation.
				if element.subnodes.count == 1 {
//				if element.subnodes.first! === element.subnodes.last! {		//	no diff in perf.
					if let t2 = element.subnodes.first as? XML.Text {
						return	t2.characters
					} else {
						return	""
					}
				}
				
				let	s1	=	element.subnodes.map({($0 as? XML.Text)?.characters}).filter({$0 != nil}).map({$0!}).reduce("", combine: +)
				return	s1
			}
		}
		
		///	Pick element for the name from subnodes.
		///	If there're many subnodes for the name, anyone can be picked.
		public subscript(name:String) -> Navigator? {
			get {
				//	Optimisation.
				if element.subnodes.count == 0 {
//				if element.subnodes.first == nil {		//	no diff in perf.
					return nil
				}
				//	Optimisation.
				if element.subnodes.count == 1 {
//				if element.subnodes.first! === element.subnodes.last! {		//	no diff in perf.
					if let e2 = element.subnodes.first as? XML.Element {
						if e2.name == name {
							return	Navigator(e2)
						} else {
							return	nil
						}
					}
				}
				
				let	subelementsForName	=	element.subnodes.filter({($0 is XML.Element) && ($0 as XML.Element).name == name}).map({$0 as XML.Element})	//	Faster path.
//				let	subelementsForName	=	element.subnodes.map {$0 as? XML.Element}.filter {$0 != nil && $0!.name == name}.map {$0!}	//	Slower path.
				
				if subelementsForName.first == nil {
					return	nil
				}
				return	Navigator(subelementsForName[0])
			}
		}
		///	Pick all elements for the name from subnodes.
		///	This can be selected by inferencing return type.
		public subscript(name:String) -> [Navigator] {
			get {
				//	Optimisation.
				if element.subnodes.count == 0 {
//				if element.subnodes.first == nil {		//	no diff in perf.
					return	[]
				}
				//	Optimisation.
				if element.subnodes.count == 1 {
//				if element.subnodes.first! === element.subnodes.last! {		//	no diff in perf.
					if let e2 = element.subnodes.first as? XML.Element {
						if e2.name == name {
							return	[Navigator(e2)]
						} else {
							return	[]
						}
					}
				}
				
				let	subelementsForName	=	element.subnodes.filter({($0 is XML.Element) && ($0 as XML.Element).name == name}).map({$0 as XML.Element})	//	Faster path.
//				let	subelementsForName	=	element.subnodes.map {$0 as? XML.Element}.filter {$0 != nil && $0!.name == name}.map {$0!}	//	Slower path.
				return	subelementsForName.map {Navigator($0)}
			}
		}
		
		private func subelementsForName(name:String) -> [XML.Element] {
			return	element.subnodes.filter({($0 is XML.Element) && ($0 as XML.Element).name == name}).map({$0 as XML.Element})
		}
	}
	
	
	
	
}

	
	
	
	
	
	
	
	
	
	
	
































extension XML {
	///	Array based navigator is too slow to be used...
	
//	///	Version 2 navigator.
//	///	This is based on collection of nodes.
//	///	Navigator never become an empty list of elements.
//	///	Instead, use `nil` to represent an empty navigator.
//	struct Navigator {
//		
//		init(_ element:XML.Element) {
//			self.items	=	[element]
//		}
//		
//		var name:String {
//			get {
////				if empty { return nil }
//				assert(({
//					if self.items.count == 0 { return true }
//					let	v1	=	self.items.first!.name
//					return	self.items.filter {$0.name == v1}.count == self.items.count
//				} as ()->Bool)())
//				
//				return	items.first!.name
//			}
//		}
//		var text:String {
//			get {
//				let	allDirectSubnodes			=	items.map {$0.subnodes}.reduce([], combine: +)
//				let	allDirectSubtexts			=	allDirectSubnodes.filter {$0 is XML.Text}.map {$0 as XML.Text}
//				
//				return	allDirectSubtexts.map {$0.characters}.reduce ("", combine: +)
//			}
//		}
//		
//		subscript(name:String) -> Navigator? {
//			get {
//				let	allDirectSubnodes			=	items.map {$0.subnodes}.reduce([], combine: +)
//				let	allDirectSubelements		=	allDirectSubnodes.filter {$0 is XML.Element}.map {$0 as XML.Element}
//				let	allDirectSubelementsForName	=	allDirectSubelements.filter {$0.name == name }
//				return	allDirectSubelementsForName.first == nil ? nil : Navigator(allDirectSubelementsForName)
//			}
//		}
//		subscript(name:String) -> [Navigator] {
//			get {
//				let	allDirectSubnodes			=	items.map {$0.subnodes}.reduce([], combine: +)
//				let	allDirectSubelements		=	allDirectSubnodes.filter {$0 is XML.Element}.map {$0 as XML.Element}
//				let	allDirectSubelementsForName	=	allDirectSubelements.filter {$0.name == name }
//				return	allDirectSubelementsForName.map {Navigator($0)}
////				return	Navigator(allDirectSubelementsForName)
//			}
//		}
//		
//		func map<U>(transform:XML.Navigator -> U) -> [U] {
//			return	items.map {Navigator($0)}.map(transform)
//		}
//		func reduce<U>(initial:U, combine:(U,XML.Navigator)->U) -> U {
//			return	items.map {Navigator($0)}.reduce(initial, combine: combine)
//		}
//		func filter(includeElement:XML.Navigator->Bool) -> Navigator {
//			let	ns1	=	items.map {Navigator($0)}.filter(includeElement).map {$0.items}.reduce([], combine: +)
//			return	Navigator(ns1)
//		}
//		
//		////
//		
//		private let	items:[XML.Element]
//		
//		private init(_ items:[XML.Element]) {
//			assert(items.first != nil)
//			self.items	=	items
//		}
//	}
	
	
	
	
}















