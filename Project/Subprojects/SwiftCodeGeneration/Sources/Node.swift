//
//  Node.swift
//  SwiftCodeGeneration
//
//  Created by Hoon H. on 11/16/14.
//
//

import Foundation


public struct NodeList<T:NodeType> : NodeType {
	private var	items	=	[] as [T]
	public init() {
	}
	public init(_ items:[T]) {
		self.items	=	items
	}
	public subscript(index:Int) -> T {
		get {
			return	items[index]
		}
		set(v) {
			items[index]	=	v
		}
	}
	
	public mutating func append(v:T) {
		items.append(v)
	}
	
	public func writeTo<C : CodeWriterType>(inout w: C) {
		for m in items {
			m.writeTo(&w)
		}
	}
}


public protocol NodeType : Codifiable {
}





public struct Token : NodeType {
	public var	text:String?
	
	public func writeTo<C : CodeWriterType>(inout w: C) {
		if text != nil { w.writeToken(text!) }
	}
}

public struct Sequence<N1:NodeType, N2:NodeType> : NodeType {
	public var	left:N1?
	public var	right:N2?
	
	public func writeTo<C : CodeWriterType>(inout w: C) {
		left?.writeTo(&w)
		right?.writeTo(&w)
	}
}













func ~ <N1:NodeType> (left:N1?, right:String?) -> Sequence<N1,Token> {
	return	left ~ Token(text: right)
}

func ~ <N1:NodeType> (left:String?, right:N1?) -> Sequence<Token, N1> {
	return	Token(text: left) ~ right
}

func ~ <N1:NodeType,N2:NodeType> (left:N1?, right:N2?) -> Sequence<N1,N2> {
	return	Sequence(left: left, right: right)
}

infix operator ~ {
precedence		255
associativity	left
}

func <<< <C:CodeWriterType, N:NodeType> (inout left:C, right:N) {
	right.writeTo(&left)
}












