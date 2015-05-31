//
//  EDXC.swift
//  EDXC
//
//  Created by Hoon H. on 10/14/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

struct EDXC {
	struct Syntax {
		struct Characters {
			static let	whitespace		=	any([" ", "\t", "\n"])
			static let	listOpener		=	one("(")
			static let	listCloser		=	one(")")
			static let	escaper			=	one("\\")
			static let	escapee			=	any(["\\", "\"", " ", "(", ")"])
//				static let	escapee			=	any(["\\", "\"", " ", "(", ")", "t", "n", "u"])
			static let	doubleQuote		=	one("\"")
			static let	nonWhitespace	=	not(whitespace)
			static let	nonEscaper		=	not(escaper)
			
			static let	symbolic		=	not(or([whitespace, escaper, listOpener, listCloser]))
			static let	quotable		=	not(or([doubleQuote, escaper]))
			
			////
			
			private typealias	P		=	CharacterSubset
			private static let	or		=	P.or
			private static let	not		=	P.not
			private static let	any		=	P.any
			private static let	one		=	P.one
		}
		
		static let	whitespaceStrip			=	chs(Characters.whitespace) * (1...Int.max)
		static let	maybeWhitespaceStrip	=	whitespaceStrip * (0...Int.max)
//			static let	whitespaceExpression	=	sub(whitespaceStrip)
		
		static let	escapingSequence		=	lit("\\") + chs(Characters.escapee)
		static let	symbolicUnit			=	chs(Characters.symbolic) | escapingSequence
		static let	symbolForm				=	symbolicUnit * (1...Int.max)
		static let	quotableUnit			=	chs(Characters.quotable) | escapingSequence
		static let	quotationForm			=	lit("\"") + (quotableUnit * (1...Int.max)) + lit("\"")
		static let	valueExpression			=	"value-expr"	~~~	symbolForm | quotationForm
		
		static let	atomExpression			=	"atom-expr"		~~~	sub(valueExpression) | Lazy.listExpression()
		
		static let	atomSeparator			=	whitespaceStrip
		static let	atomWithSeparator		=	atomSeparator + sub(atomExpression)
		static let	atomList				=	sub(atomExpression) + atomWithSeparator * (0...Int.max)
		static let	maybeAtomList			=	atomList * (0...1)
		static let	listExpression			=	"list-expr"		~~~	mk(lit("(")) + maybeWhitespaceStrip + maybeAtomList + maybeWhitespaceStrip + lit(")")
		
		struct Lazy {
			static func listExpression()(cursor:Cursor) -> Parsing.Stepping {
				return	sub(Syntax.listExpression)(cursor: cursor)
			}
		}
		
		private typealias	Stepping			=	Parsing.Stepping
		private typealias	Rule				=	Parsing.Rule
		
		private typealias	C	=	Parsing.Rule.Component
		private static let	lit	=	C.literal
		private static let	chs	=	C.chars
		private static let	sub	=	C.subrule
		private static let	mk	=	C.mark
		
		private struct Marks {
			static let	listStarter	=	Marks.exp("list expression")
			
			private static let	exp	=	Marks.exp_
			private static func	exp_(expectation:String)(composition c1:Rule.Composition)(cursor:Cursor) -> Stepping {
				return	C.expect(composition: c1, expectation: expectation)(cursor: cursor)
			}
			
		}
	}
}

