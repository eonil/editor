//
//  Parsing.swift
//  EDXC
//
//  Created by Hoon H. on 10/14/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


extension Parsing {

	///	Represents  parsing state.
	///
	///	Parsing state is represneted node-list.
	///	Node-list can be empty by a result of successful parsing. (in case
	///	of repetition rule)
	///	
	///	If parsing is unsuccessful, the node-list will be `nil`. contain one or more
	///	error-node. Upper rule can decide what to do with errors.
	///	If parsing is successful, the resulting node list can be empty or

	///	If node-list is empty (`count == 0`), it means parser couldn't find
	///	any matching, and the composition is ignored to try next pattern.
	///	This is a normal pattern matching procedure, and the parser will
	///	continue parsing.
	///
	///	If node-list is non-empty and contains any error-node, it just means
	///	*error* state. Error-node must be placed at the end of the node-list.
	///	Parser will stop parsing ASAP.
	///
	///	If node-list is non-empty and contains no error-node, it means *ready*
	///	state. Parser found propr matching pattern, and continues parsing.
	///
	///	If node-list is non-empty and contains some mark-node, it means one
	///	or more marker has been found at proper position, and that means
	///	current syntax pattern must be satisfied. Parser will force to find 
	///	current pattern, and will emit an error if current pattern cannot be
	///	completed. This marking-effect will be applied only to current rule
	///	composition, and disappear when parser switches to another rule.
	public struct Stepping : Printable {
		public let	status:Status
		public let	location:Cursor
		public let	nodes:NodeList
		
		init(status:Status, location:Cursor, nodes:NodeList) {
			assert(status != Status.Match || nodes.count == 0 || nodes.last!.endCursor <= location)
			
			self.status		=	status
			self.location	=	location
			self.nodes		=	nodes
		}
		init(status:Status, location:Cursor, nodes:[Node]) {
			self.init(status: status, location: location, nodes: NodeList(nodes))
		}
		
		var match:Bool {
			get {
				return	status == Status.Match
			}
		}
		///	Mismatch means the pattern does not fit to the source.
		var	mismatch:Bool {
			get {
				return	status == Status.Mismatch
			}
		}
		///	Error is defined only when there's some node result.
		var error:Bool {
			get {
				assert(status != Status.Error || nodes.hasAnyError())
				
				return	status == Status.Error
			}
		}
		var marking:Bool {
			get {
				return	nodes.hasAnyMarkingAtCurrentLevel()
			}
		}
		
		func reoriginate(rule r1:Rule) -> Stepping {
			precondition(match)
			func reoriginateAll(n:Stepping.Node) -> Stepping.Node {
				return	n.reorigination(rule: r1)
			}
			
			let	ns2	=	nodes.map(reoriginateAll)
			return	Stepping(status: status, location: location, nodes: ns2)
		}
		func remark(m:Node.Mark) -> Stepping {
			assert(match)
			
			let	ns1	=	self.nodes
			let	ns2	=	ns1.map({ n in return n.remark(m) }) as NodeList
			return	Stepping.match(location: self.location, nodes: ns2)
		}
		
		static func mismatch(location l1:Cursor) -> Stepping {
			return	Stepping(status: Status.Mismatch, location: l1, nodes: NodeList())
		}
		static func match(location l1:Cursor, nodes ns1:NodeList) -> Stepping {
			assert(ns1.count == 0 || l1 >= ns1.last!.endCursor)
			assert(ns1.hasAnyError() == false)
			
			return	Stepping(status: Status.Match, location: l1, nodes: ns1)
		}
		///	Error status should return some parsed node to provide debugging information to users.
		static func error(location l1:Cursor, nodes ns1:NodeList, message m1:String) -> Stepping {
			assert(ns1.count == 0 || l1 >= ns1.last!.endCursor)
	//		assert(ns1.hasAnyError() == false)	//	Discovered
			
			return	Stepping(status: Status.Error, location: l1, nodes: ns1 + NodeList([Node(location: l1, error: m1)]))
		}
	//	static func discover(location l1:Cursor, nodes ns1:NodeList) -> Stepping {
	//		assert(ns1.count == 0 || l1 >= ns1.last!.endCursor)
	//
	//		if ns1.hasAnyError() {
	//			return	Parsing.error(location: l1, nodes: ns1, message m1:String)
	//		} else {
	//			return	Parsing.match(location: l1, nodes: ns1)
	//		}
	//	}
		
		
		
		
		
		public enum Status {
			case Mismatch		///<	No match with no error. Parser will return no result and this status can be ignored safely.
			case Match			///<	Exact match found. Good result. Parser will return fully established tree.
			case Error			///<	No match with some error. Parser quit immediately and will return some result containing error information in tree.
		}
		public struct NodeList : Printable {
			init() {
				_items	=	[]
			}
			init(_ ns1:[Node]) {
				_items	=	ns1
			}
			public var count:Int {
				get {
					return	_items.count
				}
			}
			public var first:Node? {
				get {
					return	_items.first
				}
			}
			public var last:Node? {
				get {
					return	_items.last
				}
			}
			public var description:String {
				get {
					return	"\(_items)"
				}
			}
			public subscript(index:Int) -> Node {
				get {
					return	_items[index]
				}
			}
			public func map(t:Node->Node) -> NodeList {
				return	NodeList(map(t))
			}
			public func map<U>(t:Node->U) -> [U] {
				return	_items.map(t)
			}
			public func reduce<U>(v:U, combine c:(U,Node)->U) -> U {
				return	_items.reduce(v, combine: c)
			}
			public func filter(f:Node->Bool) -> NodeList {
				return	NodeList(_items.filter(f))
			}
			
			////
			
			private let	_items:[Node]
			private func hasAnyError() -> Bool {
				///	TODO:	Optimisation.
				return	_items.reduce(false, combine: { u, n in return u || n.hasAnyError() })
			}
			private func hasAnyMarkingAtCurrentLevel() -> Bool {
				///	TODO:	Optimisation.
				return	_items.reduce(false, combine: { u, n in return u || (n.marking != nil) })
			}
		}
		
		public struct Node {
			var	startCursor:Cursor
			var	endCursor:Cursor
			var	origin:Rule?
			var	marking:Mark?
			var	subnodes:NodeList		=	NodeList()
			
			let	error:String?			//	Read-only for easier optimization. Once error-node will be eternally an error.

			
			init(start:Cursor, end:Cursor, origin:Rule?, subnodes:NodeList) {
				self.init(start: start, end: end, origin: origin, marking: nil, subnodes: subnodes, error: nil)
			}
	//		init(start:Cursor, end:Cursor) {
	//			self.init(start: start, end: end, origin: nil, marking: nil, subnodes: NodeList())
	//		}
			init(start:Cursor, end:Cursor) {
				self.init(start: start, end: end, origin: nil, subnodes: NodeList([]))
			}
			init(location:Cursor, error:String) {
				self.init(start: location, end: location, origin: nil, marking: nil, subnodes: NodeList(), error: error)
			}
			
			var content:String {
				get {
					return	startCursor.content(to: endCursor)
				}
			}
			
			func reorigination(rule r1:Rule) -> Node {
				var	n2		=	self
				n2.origin	=	r1
				return	n2
			}
			func remark(m:Mark) -> Node {
				var	n2		=	self
				n2.marking	=	m
				return	n2
			}
			
			///	Rule name will be reported if `expectation` is `nil`.
			struct Mark {
				let	expectation: String?
				
				init(expectation: String?) {
					self.expectation	=	expectation
				}
			}
			
	//		enum Mark {
	//			case None
	//			case Flag(expectation:String)
	//			
	//			private var none:Bool {
	//				get {
	//					switch self {
	//					case let None:	return	true
	//					default:		return	false
	//					}
	//				}
	//			}
	//			private var expectation:String? {
	//				get {
	//					switch self {
	//					case let Flag(state):	return	state.expectation
	//					default:				return	nil
	//					}
	//				}
	//			}
	//		}
			
			////
			
			private var	_cache_any_error	=	false
			
			private init(start:Cursor, end:Cursor, origin:Rule?, marking:Mark?, subnodes:NodeList, error:String?) {
				assert(start <= end)
				
				self.startCursor	=	start
				self.endCursor		=	end
				self.origin			=	origin
				self.marking		=	marking
				self.subnodes		=	subnodes
				self.error			=	error
			}
			
			private func hasAnyError() -> Bool {
				return	(error != nil) || subnodes.hasAnyError()
			}
		}

	//	struct Error {
	//		let	message:String
	//	}
	}
}























extension Parsing.Stepping {
	public var description:String {
		get {
			return	"Parsing(status: \(status), location: \(location), nodes: \(nodes))"
		}
	}
}












func + (left:Parsing.Stepping.NodeList, right:Parsing.Stepping.NodeList) -> Parsing.Stepping.NodeList {
	return	Parsing.Stepping.NodeList(left._items + right._items)
}
func += (inout left:Parsing.Stepping.NodeList, right:Parsing.Stepping.NodeList) {
	left	=	left + right
}



extension Parsing.Stepping.NodeList {
	var marking:Bool {
		get {
			return	hasAnyMarkingAtCurrentLevel()
		}
	}
}

