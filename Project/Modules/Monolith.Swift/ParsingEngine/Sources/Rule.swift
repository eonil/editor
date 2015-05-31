//
//  Rule.swift
//  EDXC
//
//  Created by Hoon H. on 10/14/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation




public class Rule {
	public typealias	Composition	=	(cursor:Cursor) -> Stepping
	
	let	name:String
	let	composition:Composition

	init(name:String, composition:Composition) {
		self.name			=	name
		self.composition	=	composition
	}
	
	var description:String {
		get {
			return	name
		}
	}
	
	func parse(cursor:Cursor) -> Stepping {
		func resolutionNode(p1:Stepping) -> Stepping.Node {
			assert(p1.match)
			
			func resolveSubnodes(ns1:NodeList) -> NodeList {
				assert(ns1.count > 0)
				return	ns1.filter({ n in return n.origin != nil })
			}
			func resolveRange(ns1:NodeList) -> (start:Cursor, end:Cursor) {
				let	nz1	=	ns1.count > 0
				let	c1	=	nz1 ? ns1.first!.startCursor : p1.location
				let	c2	=	nz1 ? ns1.last!.endCursor : p1.location
				assert(c2 == p1.location)
				return	(c1, c2)
			}
			
			let	ns1	=	p1.nodes
			let	ns2	=	ns1.count == 0 ? NodeList() : resolveSubnodes(ns1)
			let	cs2	=	resolveRange(ns1)
			let	n2	=	Stepping.Node(start: cs2.start, end: cs2.end, origin: self, subnodes: ns2)
			return	n2
		}
		
		let	p1	=	composition(cursor: cursor)
		return	p1.match == false ? p1 : Stepping.match(location: p1.location, nodes: NodeList([resolutionNode(p1)]))
	}
	
	public enum Component {
		public static func literal(string:String) -> Composition {
			var	a1	=	[] as [Character]
			for ch in string {
				a1	+=	[ch]
			}
			
			let	a2	=	a1.map({ n in return self.pattern(Pattern.one(n)) }) as [Composition]
			let	s1	=	sequence(a2)
			return	s1
		}
		public static func pattern(pattern:Pattern.Test)(cursor:Cursor) -> Stepping {
			let	ok	=	pattern(cursor.current)
			if ok {
				let c2	=	cursor.continuation
				let	n1	=	Stepping.Node(start: cursor, end:c2)
				return	Stepping.match(location: c2, nodes: NodeList([n1]))
			}
			return	Stepping.mismatch(location: cursor)
		}
		public static func subrule(r1:Rule)(cursor:Cursor) -> Stepping {
			return	r1.parse(cursor)
		}
		///	A marker component marks special concern.
		///	If a marker component discovered at an expected position
		///	then the syntax rule becomes *requirement*, and the
		///	rule pattern recognition will emit errors rather than
		///	skipping on unmatching on other parts.
		///	Usually keywords and punctuators are marked using this.
		///	This is the only way to produce errors.
		public static func expect(composition c1:Composition, expectation e1:String?)(cursor:Cursor) -> Stepping {
			let	p1	=	c1(cursor: cursor)
			let	p2	=	p1.match ? p1.remark(Node.Mark(expectation: e1)) : p1
			return	p2
		}
		public static func mark(composition c1:Composition)(cursor:Cursor) -> Stepping {
			let	p1	=	c1(cursor: cursor)
			let	p2	=	p1.match ? p1.remark(Node.Mark(expectation: nil)) : p1
			return	p2
		}

		///	if `require` is `true`, repetition with insufficient occurrence will be treated as error
		///	instead of non-matching.
		static func sequence(components:[Composition])(cursor:Cursor) -> Stepping {
			assert(components.count > 0)
			
			var	c2	=	cursor
			var	ns1	=	NodeList()
			for comp in components {
				///	Exit immediately on unexpected end of source.
				if c2.available == false {
					///	Add an error if marked at current level.
					if ns1.marking {
						return	Stepping.error(location: c2, nodes: ns1, message: "Some component is marked, and unexpected end of stream has been found.")
					}
					return	Stepping.mismatch(location: c2)
				}
				
				let	p1	=	comp(cursor: c2)
				c2		=	p1.location
				ns1		+=	p1.nodes ||| NodeList()
				assert(ns1.count == 0 || c2 >= ns1.last!.endCursor)
				
				///	Exit early on any error.
				if p1.error {
					return	p1
				}
				
				///	Exit early on any mismatch.
				if p1.mismatch {
					///	Add an error if marked at current level.
					if ns1.marking {
						return	Stepping.error(location: c2, nodes: ns1, message: "Some node is marked, but current sequence was not fully satisfied.")
					}
					return	Stepping.mismatch(location: c2)
				}
			}
			
			///	All green. Returns OK.
			return	Stepping.match(location: c2, nodes: ns1)
		}
		///	if `require` is `true`, repetition with insufficient occurrence will be treated as error
		///	instead of non-matching.
		static func choice(components:[Composition])(cursor:Cursor) -> Stepping {
			var	c2	=	cursor
			var	ns1	=	NodeList()
			for comp in components {
				let	p1	=	comp(cursor: c2)
				
				///	Exit early on any error.
				if p1.error {
					return	p1
				}
				
				///	Exit early on exact matching.
				if p1.match {
					return	p1
				}
				
				c2		=	p1.location
			}
			
			///	No need to concern about marking.
			///	It's not related to choice rules.
			///	Returns mismatch on no matching.
			assert(ns1.count == 0)
			return	Stepping.mismatch(location: c2)
		}
		///	if `require` is `true`, repetition with insufficient occurrence will be treated as error
		///	instead of non-matching.
		static func repetition(unit:Composition, range:ClosedInterval<Int>)(cursor:Cursor) -> Stepping {
			var	c2	=	cursor
			var	ns1	=	NodeList()
			
			while c2.available {
				let	p1	=	unit(cursor: c2)
				ns1		+=	p1.nodes ||| NodeList()
				c2		=	p1.location
				
				///	Exit early on any error.
				if p1.error {
					return	p1
				}
				
				//	Stops on mismatch or overflow.
				let	over_max	=	ns1.count > range.end
				let	should_stop	=	p1.mismatch | over_max
				if	should_stop {
					break
				}
			}
			
			//	Returns mismatch on underflow.
			let	under_min	=	ns1.count < range.start
			if	under_min {
				return	Stepping.mismatch(location: c2)
			}
			
			///	All green. Returns OK.
			///	Node-list can be empty.
			///	No need to concern about marking.
			///	It's not related to choice rules.
			return	Stepping.match(location: c2, nodes: ns1)
		}
	}
	
	private typealias	Node		=	Stepping.Node
	private typealias	NodeList	=	Stepping.NodeList
}





















extension Cursor {
	
	///	Disabled due to compiler bug.
	
	//	///	Empty-range node. Used for error or virtual tokens.
	//	func nodify<T:Node>() -> T {
	//		return	T(start: self, end: self)
	//	}
	//	func nodify<T:Node>(from c1:Cursor) -> T {
	//		return	T(start: c1, end: self)
	//	}
	//	func nodify<T:Node>(to c1:Cursor) -> T {
	//		return	T(start: self, end: c1)
	//	}
	//	func errify(message:String) -> Node.Error {
	//		let	n1		=	nodify() as Node.Error
	//		n1.message	=	message
	//		return	n1
	//	}
	//	func errify(message:String) -> Stepping.Node {
	//		return	Parsing.Node(location: self, error: message)
	//	}
	
	
}









infix operator ~~~ {

}

public func ~~~ (left:String, right:Rule.Composition) -> Rule {
	return	Rule(name: left, composition: right)
}

public func + (left:Rule.Composition, right:Rule.Composition) -> Rule.Composition {
	return	Rule.Component.sequence([left, right])
}
public func | (left:Rule.Composition, right:Rule.Composition) -> Rule.Composition {
	return	Rule.Component.choice([left, right])
}
public func * (left:Rule.Composition, right:ClosedInterval<Int>) -> Rule.Composition {
	return	Rule.Component.repetition(left, range:right)
}
