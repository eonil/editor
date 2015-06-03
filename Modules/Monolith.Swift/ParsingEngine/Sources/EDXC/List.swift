//
//  List.swift
//  EDXC
//
//  Created by Hoon H. on 10/14/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

enum Atom {
	case Value(expression:String)
	case List(atoms:[Atom])
}

extension Atom: Printable {
	var description:String {
		get {
			return	print()
		}
	}
}

private extension Atom {
	var valueExpression:String? {
		get {
			switch self {
			case let Atom.Value(state):		return	state.expression
			default:						return	nil
			}
		}
	}
	var sublistAtoms:[Atom]? {
		get {
			switch self {
			case let Atom.List(state):	return	state.atoms
			default:						return	nil
			}
		}
	}
	var deep:Bool {
		get {
			if let a1 = sublistAtoms {
				return	a1.map({ n in return n.sublistAtoms != nil }).reduce(false, combine: |)
			}
			return	false
		}
	}
	var shallow:Bool {
		get {
			return	!deep
		}
	}
	
	func print() -> String {
		let	expr1	=	valueExpression
		let	as1		=	sublistAtoms
		
		if let expr1 = valueExpression {
			return	EscapeString.WithDoubleQuote.escape(expr1)
		}
		if let as1 = sublistAtoms {
			let	j1	=	deep ? "\n" : " "
			return	PrettyPrinter.print(as1, joiner: j1)
		}
		fatalError()
	}
	
	struct PrettyPrinter {
		static func print(atoms:[Atom], joiner:String) -> String {
			let	ns1	=	atoms.map({ n in return n.description }) as [String]
			let	s1	=	"(" + join(joiner, ns1) + ")"
			let	s2	=	indentAllEachLines(s1)
			return	s2
		}
		static func indentAllEachLines(s:String) -> String {
			let	ss1	=	splitIntoLines(s)
			let	ss2	=	indent(ss1)
			return	join("\n", ss2)
		}
		static func splitIntoLines(s:String) -> [String] {
			return	s.componentsSeparatedByString("\n")
		}
		static func indent(ss:[String]) -> [String] {
			return	ss.map(indent)
		}
		static func indent(s:String) -> String {
			return	"\t" + s
		}
	}
	
	struct EscapeString {
		struct WithDoubleQuote {
			static func escape(s:String) -> String {
				var	s1	=	""
				for ch in s {
					if ch == "\"" {
						s1	+=	"\\"
					}
					s1.append(ch)
				}
				return	"\"" + s1 + "\""
			}
			static func unescape(s:String) -> String? {
				if s == "" {
					return	""
				}
				func rest(s:String) -> String {
					return	s[s.startIndex.successor()..<s.endIndex]
				}
				
				let	ch1	=	s[s.startIndex]
				let	re1	=	rest(s)
				
				if ch1 == "\\" {
					let	ch2	=	re1[re1.startIndex]
					let	re2	=	rest(re1)
					let	s2	=	unescape(re1)
					return	s2 == nil ? nil : String(ch2) + s2!
					
				} else {
					let	s2	=	unescape(re1)
					return	s2 == nil ? nil : String(ch1) + s2!
				}
			}
		}
//		struct SymbolStyle {
//			static func escape(s:String) -> String {
//				
//			}
//			static func unescape(s:String) -> String {
//				
//			}
//		}
	}
	
}











