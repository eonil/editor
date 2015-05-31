//
//  Entity.swift
//  EDXC
//
//  Created by Hoon H. on 10/14/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

struct Entity: Printable {
	let	name:String
	let	type:String
	let	parameters:[Parameter]
	
	enum Parameter {
		case Expression(String)
		case Subentity(Entity)
		
		var expression:String? {
			get {
				switch self {
				case let Expression(state):	return	state
				default:					return	nil
				}
			}
		}
		var subentity:Entity? {
			get {
				switch self {
				case let Subentity(state):	return	state
				default:					return	nil
				}
			}
		}
	}
}




extension Entity {
	var description:String {
		get {
			let	a1	=	ListConverter.print(self)
			return	a1.description
		}
	}
	
	func listify() -> Atom {
		return	ListConverter.print(self)
	}
}
extension Atom {
	func tryEntitifying() -> Entity? {
		return	Entity.ListConverter.scan(self)
	}
}






private extension Entity {
	struct ListConverter {
		static func print(v:Entity) -> Atom {
			func parameterToAtom(p:Entity.Parameter) -> Atom {
				switch p {
				case let Entity.Parameter.Expression(state):	return	Atom.Value(expression: state)
				case let Entity.Parameter.Subentity(state):		return	self.print(state)
				}
			}
			let	as1	=	[Atom.Value(expression: v.name), Atom.Value(expression: v.type)] + v.parameters.map(parameterToAtom)
			let	a1	=	Atom.List(atoms: as1)
			return	a1
		}
		static func scan(v:Atom) -> Entity? {
			func tryEntitification(as1:[Atom]) -> Entity? {
				func symbolify(a:Atom) -> String? {
					switch a {
					case let Atom.Value(state):	return	state
					case let Atom.List(state):	return	nil
					}
				}
				func parameteriseAll(as1:ArraySlice<Atom>) -> [Parameter]? {
					func parameterise(a:Atom) -> Parameter? {
						switch a {
						case let Atom.Value(state):	return	Parameter.Expression(state)
						case let Atom.List(state):
							if let e1 = ListConverter.scan(a) {
								return	Parameter.Subentity(e1)
							} else {
								return	nil
							}
						}
					}
					
					var	ps1	=	[] as [Parameter]
					for a1 in as1 {
						if let p1 = parameterise(a1) {
							ps1.append(p1)
						} else {
							return	nil
						}
					}
					return	ps1
				}
				
				if as1.count < 3 {
					return	nil
				}
				let	name1	=	symbolify(as1[0])
				let	type1	=	symbolify(as1[1])
				let	params1	=	parameteriseAll(as1[2..<as1.count])
				if name1 != nil && type1 != nil && params1 != nil {
					return	Entity(name: name1!, type: type1!, parameters: params1!)
				}
				return	nil
			}
			
			switch v {
			case let Atom.Value(state):	return	nil
			case let Atom.List(state):	return	tryEntitification(state)
			}
		}
	}
}




