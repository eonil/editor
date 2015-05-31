//
//  Test.swift
//  EDXC
//
//  Created by Hoon H. on 10/15/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

struct Test {
	
	static func run() {
		typealias	Rule		=	Parsing.Rule
		typealias	Stepping	=	Parsing.Stepping
		
		let	run	=	Parsing.run
		func tx(x:()->()) {
			x()
		}
		func ok(b:Bool) {
			assert(b)
		}
		

		
		
		
		
		
		tx{
			let	e1	=	Entity(name: "mine1", type: "String1", parameters: [Entity.Parameter.Expression("My name is \"John\"...")])
			let	l1	=	e1.listify()
			println(l1)
		}
			
		tx {
			let	s1	=	" \t\n"
			let	r1	=	run(data: s1, using: "test-rule" ~~~ EDXC.Syntax.whitespaceStrip)
			println(r1)
			
			ok(r1.nodes.count == 1)
			
			let	n1	=	r1.nodes[0]
			ok(n1.content == s1)
			println(n1.content)
		}
		
		tx{
			let	s1	=	" "
			let	r1	=	run(data: s1, using: "test-rule" ~~~ EDXC.Syntax.symbolForm)
			
			println(r1)
			ok(r1.match == false)
		}
		
		tx{
			struct Example {
				static let	list	=	"example-rule" ~~~ mk(lit("(")) + mk(lit(")"))
				
				private typealias	C	=	Rule.Component
				private static let	lit	=	C.literal
				private static let	chs	=	C.chars
				private static let	sub	=	C.subrule
				private static let	mk	=	C.mark
			}
			
			let	s1	=	"()"
			let	r1	=	run(data: s1, using: Example.list)
			println(r1)
			ok(r1.status == Stepping.Status.Match)
			ok(r1.nodes.count == 1)
			println(r1.nodes[0].content)
			ok(r1.nodes[0].content == "()")
		}
		
		tx{
			struct Example {
				static let	list	=	"example-rule" ~~~ mk(lit("(")) + lit(")")
				
				private typealias	C	=	Rule.Component
				private static let	lit	=	C.literal
				private static let	chs	=	C.chars
				private static let	sub	=	C.subrule
				private static let	mk	=	C.mark
			}
			
			let	s1	=	"("
			let	r1	=	run(data: s1, using: Example.list)
			println(r1)
			ok(r1.status == Stepping.Status.Error)
			ok(r1.nodes.count == 2)
			println(r1.nodes[0].content)
			ok(r1.nodes[0].content == "(")
			ok(r1.nodes[0].error == nil)
			ok(r1.nodes[1].error != nil)
			ok(r1.error)
		}
		
		tx{
			let	s1	=	" "
			let	r1	=	run(data: s1, using: EDXC.Syntax.valueExpression)
			
			println(r1)
			ok(r1.match == false)
		}
		
		tx{
			let	s1	=	"a b c"
			let	r1	=	run(data: s1, using: EDXC.Syntax.valueExpression)
			println(r1)
			
			//ok(r1.nodes != nil)
			ok(r1.nodes.count == 1)
			
			let	n1	=	r1.nodes[0]
			println(n1.content)
			ok(n1.content == "a")
		}
		
		tx{
			let	s1	=	"\"abc\""
			let	r1	=	run(data: s1, using: EDXC.Syntax.valueExpression)
			println(r1)
			
			//ok(r1.nodes != nil)
			ok(r1.nodes.count == 1)
			
			let	n1	=	r1.nodes[0]
			println(n1.content)
			ok(n1.content == s1)
		}

		tx{
			let	s1	=	"(a b c)"
			let	r1	=	run(data: s1, using: EDXC.Syntax.listExpression)
			println(r1)
			
			//ok(r1.nodes != nil)
			
			let	n1	=	r1.nodes[0]
			ok(n1.origin === EDXC.Syntax.listExpression)
			ok(n1.content == s1)
			println(n1.content)
			
			let	n2	=	{ (i:Int) -> Stepping.Node in return n1.subnodes[i] }
			ok(n1.subnodes.count == 3)
			ok(n2(0).origin === EDXC.Syntax.atomExpression)
			ok(n2(1).origin === EDXC.Syntax.atomExpression)
			ok(n2(2).origin === EDXC.Syntax.atomExpression)
			println(n2(0).content)
			println(n2(1).content)
			println(n2(2).content)
			ok(n2(0).content == "a")
			ok(n2(1).content == "b")
			ok(n2(2).content == "c")
		}
		
		tx{
			let	s1	=	"(a (b c d) e)"
			let	r1	=	run(data: s1, using: EDXC.Syntax.listExpression)
			println(r1)
			
			//ok(r1.nodes != nil)
			
			let	n1	=	r1.nodes[0]
			ok(n1.origin === EDXC.Syntax.listExpression)
			ok(n1.content == s1)
			println(n1.content)
			ok(n1.subnodes.count == 3)
			
			let	n2	=	{ (i:Int) -> Stepping.Node in return n1.subnodes[i] }
			ok(n2(0).origin === EDXC.Syntax.atomExpression)
			ok(n2(1).origin === EDXC.Syntax.atomExpression)
			ok(n2(2).origin === EDXC.Syntax.atomExpression)
			println(n2(0).content)
			println(n2(1).content)
			println(n2(2).content)
			ok(n2(0).content == "a")
			ok(n2(1).content == "(b c d)")
			ok(n2(1).subnodes.count == 1)
			ok(n2(2).content == "e")
			
			let	n3	=	{ (i:Int) -> Stepping.Node in return n2(1).subnodes[i] }
			ok(n3(0).origin === EDXC.Syntax.listExpression)
			ok(n3(0).subnodes.count == 3)
			
			let	n4	=	{ (i:Int) -> Stepping.Node in return n3(0).subnodes[i] }
			ok(n4(0).origin === EDXC.Syntax.atomExpression)
			ok(n4(1).origin === EDXC.Syntax.atomExpression)
			ok(n4(2).origin === EDXC.Syntax.atomExpression)
			ok(n4(0).content == "b")
			ok(n4(1).content == "c")
			ok(n4(2).content == "d")
		}
		
		tx{
			let	s1	=	"(a   (b\tc\t\td)\ne)"
			let	r1	=	run(data: s1, using: EDXC.Syntax.listExpression)
			println(r1)
			
			//ok(r1.nodes != nil)
			
			let	n1	=	r1.nodes[0]
			ok(n1.origin === EDXC.Syntax.listExpression)
			ok(n1.content == s1)
			println(n1.content)
			ok(n1.subnodes.count == 3)
			
			let	n2	=	{ (i:Int) -> Stepping.Node in return n1.subnodes[i] }
			ok(n2(0).origin === EDXC.Syntax.atomExpression)
			ok(n2(1).origin === EDXC.Syntax.atomExpression)
			ok(n2(2).origin === EDXC.Syntax.atomExpression)
			println(n2(0).content)
			println(n2(1).content)
			println(n2(2).content)
			ok(n2(0).content == "a")
			ok(n2(1).content == "(b\tc\t\td)")
			ok(n2(1).subnodes.count == 1)
			ok(n2(2).content == "e")
			
			let	n3	=	{ (i:Int) -> Stepping.Node in return n2(1).subnodes[i] }
			ok(n3(0).origin === EDXC.Syntax.listExpression)
			ok(n3(0).subnodes.count == 3)
			
			let	n4	=	{ (i:Int) -> Stepping.Node in return n3(0).subnodes[i] }
			ok(n4(0).origin === EDXC.Syntax.atomExpression)
			ok(n4(1).origin === EDXC.Syntax.atomExpression)
			ok(n4(2).origin === EDXC.Syntax.atomExpression)
			ok(n4(0).content == "b")
			ok(n4(1).content == "c")
			ok(n4(2).content == "d")
		}
		
		tx{
			let	s1	=	"( )"
			let	r1	=	run(data: s1, using: EDXC.Syntax.listExpression)
			println(r1)
			
			ok(r1.match)
			ok(r1.nodes.count == 1)
			ok(r1.nodes[0].origin === EDXC.Syntax.listExpression)
			ok(r1.nodes[0].content == s1)
		}
		
		
		tx{
			let	s1	=	"( a ( b ) c )"
			let	r1	=	run(data: s1, using: EDXC.Syntax.listExpression)
			println(r1)
			
			//ok(r1.nodes != nil)
			ok(r1.nodes.count == 1)
			
			let	n1	=	r1.nodes[0]
			ok(n1.origin === EDXC.Syntax.listExpression)
			println(n1.content)
			ok(n1.content == s1)
			ok(n1.subnodes.count == 3)
			
			let	n2	=	{ (i:Int) -> Stepping.Node in return n1.subnodes[i] }
			ok(n2(0).origin === EDXC.Syntax.atomExpression)
			ok(n2(1).origin === EDXC.Syntax.atomExpression)
			ok(n2(2).origin === EDXC.Syntax.atomExpression)
			println(n2(0).content)
			println(n2(1).content)
			println(n2(2).content)
			ok(n2(0).content == "a")
			ok(n2(1).content == "( b )")
			ok(n2(1).subnodes.count == 1)
			ok(n2(2).content == "c")
		}
		
		tx{
			let	s1	=	"abc"
			let	r1	=	run(data: s1, using: EDXC.Syntax.valueExpression)
			println(r1)
			
			//ok(r1.nodes != nil)
			ok(r1.nodes.count == 1)
			
			let	n1	=	r1.nodes[0]
			ok(n1.origin === EDXC.Syntax.valueExpression)
			println(n1.content)
			ok(n1.content == s1)
			ok(n1.subnodes.count == 0)
		}
		
		tx{
			let	s1	=	"abc2/23lr9$%3$x"
			let	r1	=	run(data: s1, using: EDXC.Syntax.valueExpression)
			println(r1)
			
			//ok(r1.nodes != nil)
			ok(r1.nodes.count == 1)
			
			let	n1	=	r1.nodes[0]
			ok(n1.origin === EDXC.Syntax.valueExpression)
			println(n1.content)
			ok(n1.content == s1)
			ok(n1.subnodes.count == 0)
		}
		
		///	Escape sequence.
		tx{
			let	s1	=	"ab\\ c d"
			let	r1	=	run(data: s1, using: EDXC.Syntax.valueExpression)
			println(r1)
			
			//ok(r1.nodes != nil)
			ok(r1.nodes.count == 1)
			
			let	n1	=	r1.nodes[0]
			ok(n1.origin === EDXC.Syntax.valueExpression)
			println(n1.content)
			ok(n1.content == "ab\\ c")
			ok(n1.subnodes.count == 0)
		}
		
		
		
		tx{
			let	s1	=	"(a )"
			let	r1	=	run(data: s1, using: EDXC.Syntax.listExpression)
			println(r1)
			
			//ok(r1.nodes != nil)
			ok(r1.nodes.count == 1)
			
			let	n1	=	r1.nodes[0]
			ok(n1.origin === EDXC.Syntax.listExpression)
			println(n1.content)
			ok(n1.content == s1)
			ok(n1.subnodes.count == 1)
			
			let	n2	=	{ (i:Int) -> Stepping.Node in return n1.subnodes[i] }
			ok(n2(0).origin === EDXC.Syntax.atomExpression)
			println(n2(0).content)
			ok(n2(0).content == "a")
		}
		
		tx{
			let	s1	=	"(a"
			let	r1	=	run(data: s1, using: EDXC.Syntax.listExpression)
			println(r1)
			ok(r1.error)
		}
	}
}
