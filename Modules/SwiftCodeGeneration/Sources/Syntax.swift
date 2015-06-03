
//
//  SwiftCodeGeneration3.swift
//  DataConverterClassGenerator
//
//  Created by Hoon H. on 11/16/14.
//
//

import Foundation




public typealias	Statements	=	NodeList<Statement>

public enum Statement : NodeType {
	case Expression(SwiftCodeGeneration.Expression)
	case Declaration(SwiftCodeGeneration.Declaration)
	case LoopStatement(SwiftCodeGeneration.LoopStatement)
	
	public func writeTo<C : CodeWriterType>(inout w: C) {
		switch self {
		case .Expression(let s):	s.writeTo(&w)
		case .Declaration(let s):	s.writeTo(&w)
		case .LoopStatement(let s):	s.writeTo(&w)
		}
		w.writeToken(";")
	}
}

public enum LoopStatement : NodeType {
//	case ForStatement
	case ForInStatement(pattern:Pattern, expression:Expression, codeBlock:CodeBlock)
//	case WhileStatement
//	case DoWhileStatement
	
	public func writeTo<C : CodeWriterType>(inout w: C) {
		switch self {
		case .ForInStatement(let s):	w	<<<	"for" ~ s.pattern ~ "in" ~ s.expression ~ s.codeBlock
		
		}
	}
}

public struct Pattern : NodeType {
	public var	text:String
	
	public func writeTo<C:CodeWriterType>(inout w:C) {
		w.writeToken(text)
	}
}

///	https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/swift/grammar/code-block
public struct CodeBlock : NodeType {
	public var	statements	:	Statements
	
	public init() {
		self.statements	=	Statements()
	}
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	"{" ~ statements ~ "}"
	}
}
public enum ForInStatement {
	public func writeTo<C : CodeWriterType>(inout w: C) {
	}
}

public enum Expression : NodeType {
	public func writeTo<C : CodeWriterType>(inout w: C) {
	}
}

///	https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/swift/grammar/declaration
public enum Declaration : NodeType {
	case Import(ImportDeclaration)
//	case Constant
	case Variable(VariableDeclaration)
//	case Typealias
	case Function(FunctionDeclaration)
//	case Enum
	case Struct(StructDeclaration)
	case Class(ClassDeclaration)
//	case Protocol
	case Initializer(InitializerDeclaration)
//	case Deinitializer
	case Extension(ExtensionDeclaration)
//	case Subscript(SubscriptDeclaration)
//	case Operator
	public func writeTo<C : CodeWriterType>(inout w: C) {
		switch self {
		case .Import(let s):		w	<<<	s
		case .Variable(let s):		w	<<<	s
		case .Function(let s):		w	<<<	s
		case .Struct(let s):		w	<<<	s
		case .Class(let s):			w	<<<	s
		case .Initializer(let s):	w	<<<	s
		case .Extension(let s):		w	<<<	s
		}
	}
}

public typealias	Declarations		=	NodeList<Declaration>


public struct ImportDeclaration: NodeType {
	public var	attributes	:	Attributes
	public var	importKind	:	String
	public var	importPath	:	String
	
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	attributes ~ importKind ~ importPath
	}
}

///	Simplified.
public struct VariableDeclaration: NodeType {
	public var	variableDeclarationHead	:	VariableDeclarationHead
	public var	name					:	String
	public var	type					:	Type
	
	public init(name:String, type:String) {
		self.variableDeclarationHead	=	VariableDeclarationHead(attributes: Attributes(), declarationModifiers: DeclarationModifier.AccessLevel(AccessLevelModifier.Internal))
		self.name	=	name
		self.type	=	Type(text: type)
	}
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	variableDeclarationHead
		w.writeToken(name)
		w.writeToken(":")
		w	<<<	type
	}
}

public struct VariableDeclarationHead: NodeType {
	public var	attributes				:	Attributes
	public var	declarationModifiers	:	DeclarationModifier
	
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	attributes ~ declarationModifiers ~ "var"
	}
}

///	https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/swift/grammar/function-declaration
public struct FunctionDeclaration: NodeType {
	var	functionHead			:	FunctionHead
	var	functionName			:	FunctionName
	var	genericParameterClause	:	GenericParameterClause?
	var	functionSignature		:	FunctionSignature
	var	functionBody			:	FunctionBody
	
	///	Creates `()->()` function.
	public init(name:String) {
		self.init(name: name, resultType: "()")
	}
	///	Creates `()->T` function.
	public init(name:String, resultType:String) {
		self.init(name: name, inputParameters: ParameterList(), resultType: resultType)
	}
	///	Creates `T->T` function.
	public init(name:String, inputParameters:ParameterList, resultType:String) {
		self.functionHead			=	FunctionHead(attributes: Attributes(), declarationModifiers: DeclarationModifiers())
		self.functionName			=	FunctionName.Identifier(Identifier(name))
		self.genericParameterClause	=	GenericParameterClause(dummy: "")
		self.functionSignature		=	FunctionSignature(parameterClauses: ParameterClauses([ParameterClause(parameters: inputParameters, variadic: false)]), functionResult: FunctionResult(attributes: Attributes(), type: Type(text: resultType)))
		self.functionBody			=	FunctionBody()
	}
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	functionHead ~ functionName ~ genericParameterClause ~ functionSignature ~ functionBody
	}
}
public struct FunctionHead: NodeType {
	var	attributes				:	Attributes
	var	declarationModifiers	:	DeclarationModifiers
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	attributes ~ declarationModifiers ~ "func"
	}
}
public enum FunctionName: NodeType {
	case Identifier(SwiftCodeGeneration.Identifier)
//	case Operator
	public func writeTo<C : CodeWriterType>(inout w: C) {
		switch self {
		case .Identifier(let s):	w.writeToken(s)
		}
	}
}
public struct FunctionSignature: NodeType {
	public var	parameterClauses		:	ParameterClauses
	public var	functionResult			:	FunctionResult
	
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	parameterClauses ~ functionResult
	}
}
public struct FunctionResult: NodeType {
	var	attributes		:	Attributes
	var	type			:	Type
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	"->" ~ attributes ~ type
	}
}
public struct FunctionBody: NodeType {
	public var	codeBlock		:	CodeBlock
	
	public init() {
		self.codeBlock	=	CodeBlock()
	}
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	codeBlock
	}
}



public struct StructDeclaration: NodeType {
	public var	attributes				:	Attributes?
	public var	accessLevelModifier		:	AccessLevelModifier?
	public var	structName				:	Identifier
	public var	genericParameterClause	:	GenericParameterClause?
	public var	typeInheritanceClause	:	TypeInheritanceClause?
	public var	structBody				:	Declarations
	
	public init(name:String) {
		self.structName			=	Identifier(name)
		self.structBody			=	Declarations()
	}
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	attributes ~ accessLevelModifier ~ "struct" ~ structName ~ genericParameterClause ~ typeInheritanceClause ~ "{" ~ structBody ~ "}"
	}
}

///	https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/swift/grammar/class-declaration
public struct ClassDeclaration: NodeType {
	public var	attributes				:	Attributes?
	public var	accessLevelModifier		:	AccessLevelModifier?
	public var	className				:	Identifier
	public var	genericParameterClause	:	GenericParameterClause?
	public var	typeInheritanceClause	:	TypeInheritanceClause?
	public var	classBody				:	Declarations
	
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	attributes ~ accessLevelModifier ~ "class" ~ className ~ genericParameterClause ~ typeInheritanceClause ~ "{" ~ classBody ~ "}"
	}
}

//	enum ImportKind: NodeType {
//		public func writeTo<C : CodeWriterType>(inout w: C) {
//		}
//	}

public struct Attribute: NodeType {
	public func writeTo<C : CodeWriterType>(inout w: C) {
	}
}
public typealias	Attributes	=	NodeList<Attribute>



///	Disabled due to compiler bug.
public enum AccessLevelModifier: NodeType {
	case Internal
	case InternalSet
	case Private
	case PrivateSet
	case Public
	case PublicSet
	
	public func writeTo<C : CodeWriterType>(inout w: C) {
		switch self {
		case .Internal:		w.writeToken("internal")
		case .InternalSet:	w.writeToken("internal ( set )")
		case .Private:		w.writeToken("private")
		case .PrivateSet:	w.writeToken("private ( set )")
		case .Public:		w.writeToken("public")
		case .PublicSet:	w.writeToken("public ( set )")
		}
	}
}

public struct GenericParameterClause: NodeType {
	public var	dummy:String
	public func writeTo<C : CodeWriterType>(inout w: C) {
	}
}

//	Simplified... too much of needless works.
public typealias	TypeInheritanceClause	=	String
//	public struct TypeInheritanceClause: NodeType {
//		public var	dummy:String
//		public func writeTo<C : CodeWriterType>(inout w: C) {
//		}
//	}
public struct StructBody: NodeType {
	public var	declarations:Declarations
	public func writeTo<C : CodeWriterType>(inout w: C) {
	}
}
public struct ClassBody: NodeType {
	public var	declarations:Declarations
	public func writeTo<C : CodeWriterType>(inout w: C) {
	}
}



///	https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/swift/grammar/initializer-declaration
public struct InitializerDeclaration: NodeType {
	public var	initializerHead:InitializerHead
	public var	genericParameterClause:GenericParameterClause?
	public var	parameterClause:ParameterClause
	public var	initializerBody:CodeBlock
	
	public init() {
		self.init(failable: false)
	}
	public init(failable:Bool) {
		self.init(failable: false, parameters: ParameterList())
	}
	public init(failable:Bool, parameters:ParameterList) {
		self.initializerHead	=	InitializerHead(attributes: Attributes(), declarations: nil, failable: failable)
		self.parameterClause	=	ParameterClause(parameters: parameters, variadic: false)
		self.initializerBody	=	CodeBlock()
	}
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	initializerHead ~ genericParameterClause ~ parameterClause ~ initializerBody
	}
}

public struct InitializerHead: NodeType {
	public var	attributes		:	Attributes
	public var	declarations	:	DeclarationModifiers?
	public var	failable		:	Bool
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	attributes ~ declarations ~ "init" ~ (failable ? "?" : "")
	}
}

public enum DeclarationModifier: NodeType {
	case AccessLevel(AccessLevelModifier)
//	case Class
//	case Convenience
//	case Dynamic
//	case Final
//	case Infix
//	case Lazy
//	case Mutating
//	case NonMutating
//	case Optional
//	case Override
//	case Postfix
//	case Prefix
//	case Required
//	case Static
//	case Unowned
//	case UnownedSafe
//	case UnownedUnsafe
//	case Weak
	
	public func writeTo<C : CodeWriterType>(inout w: C) {
		switch self {
		case .AccessLevel(let s):	w	<<<	s
		}
	}
}
public typealias	DeclarationModifiers	=	NodeList<DeclarationModifier>

///	https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/swift/grammar/parameter-clause
public struct ParameterClause: NodeType {
	public var	parameters		:	ParameterList
	public var	variadic		:	Bool
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	"(" ~ parameters ~ (variadic ? "..." : "") ~ ")"
	}
}
///	https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/swift/grammar/parameter-clauses
public typealias	ParameterClauses		=	NodeList<ParameterClause>

public struct ParameterList: NodeType {
	public var	items			:	[Parameter]
	
	public init() {
		items	=	[]
	}
	public func writeTo<C : CodeWriterType>(inout w: C) {
		for i in 0..<items.count {
			let	m	=	items[i]
			w	<<<	m
			if i < items.count-1 {
				w.writeToken(",")
			}
		}
	}
}

///	https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/swift/grammar/parameter
public struct Parameter: NodeType {
	public var	byref					:	Bool
	public var	mutable					:	Bool
	public var	hashsign				:	Bool
	public var	externalParameterName	:	Identifier?
	public var	localParameterName		:	Identifier
	public var	typeAnnotation			:	TypeAnnotation
	public var	defaultArgumentClause	:	Expression?
	
//		public var	attributes	=	NodeList<Attribute>()
//		public var	type		:	Type
	
	public init(name:String, type:String) {
		byref		=	false
		mutable		=	false
		hashsign	=	false
		
		localParameterName	=	Identifier(name)
		typeAnnotation		=	TypeAnnotation(attributes: Attributes(), type: Type(text: type))
	}
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w.writeToken(byref ? "inout" : "")
		w.writeToken(mutable ? "var" : "let")
		w.writeToken(hashsign ? "#" : "")
		
		if externalParameterName != nil { w.writeToken(externalParameterName!) }
		w.writeToken(localParameterName)
		
		w	<<<	typeAnnotation ~ defaultArgumentClause
	}
}

///	https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Types.html#//apple_ref/swift/grammar/type-annotation
public struct TypeAnnotation: NodeType {
	public var	attributes	:	Attributes?
	public var	type		:	Type
	
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	":" ~ attributes ~ type
	}
}
public struct Type: NodeType {
	public var	text:String
	
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w.writeToken(text)
	}
}
//	enum Type: NodeType {
////		case Array
////		case Dictionary
////		case Function
//		case TypeIdentifier(expression:String)
////		case Tuple
////		case Optional
////		case ImplicitlyUnwrappedOptional
////		case ProtocolCOmposition
////		case Metatype
//		
//		public func writeTo<C : CodeWriterType>(inout w: C) {
//			switch self {
//			case .TypeIdentifier(let s):	w.writeToken(s)
//			}
//		}
//	}


///	https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/doc/uid/TP40014097-CH34-XID_704
public struct ExtensionDeclaration: NodeType {
	public var	accessLevelModifier:AccessLevelModifier?
	public var	typeIdentifier:TypeIdentifier
	public var	typeInheritanceClause:TypeInheritanceClause?
	public var	extensionBody:Declarations
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	accessLevelModifier ~ typeInheritanceClause ~ "{" ~ extensionBody ~ "}"
	}
}

///	https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Types.html#//apple_ref/swift/grammar/type-identifier
public struct TypeIdentifier: NodeType {
	public var	typeName:Identifier
	public var	genericArgumentClause:GenericArgumentClause?
	public var	subtypeIdentifier:(()->TypeIdentifier)?
	public init(typeName:Identifier, genericArgumentClause:GenericArgumentClause?) {
		self.typeName				=	typeName
		self.genericArgumentClause	=	genericArgumentClause
	}
	public init(_ parts:[(typeName:Identifier, genericArgumentClause:GenericArgumentClause?)]) {
		precondition(parts.count >= 1)
		switch parts.count {
		case 0:
			fatalError("Bad input.")
		case 1:
			self.init(parts[0])
			subtypeIdentifier	=	nil
		default:
			self.init(parts[0])
			let	a	=	TypeIdentifier(parts.rest.array)
			subtypeIdentifier	=	{ a }
		}
	}
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	typeName ~ genericArgumentClause
		if let x1 = subtypeIdentifier {
			w.writeToken(".")
			w	<<<	x1()
		}
	}
}

///	https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/GenericParametersAndArguments.html#//apple_ref/doc/uid/TP40014097-CH37-XID_872
public struct GenericArgumentClause: NodeType {
	public var	genericArguments	:	Type
	public var	additionalArgument	:	(()->GenericArgumentClause)?
	public init(_ argument:Type) {
		genericArguments	=	argument
		additionalArgument	=	nil
	}
	public init(_ arguments:[Type]) {
		precondition(arguments.count >= 1)
		genericArguments	=	arguments.first!
		if arguments.count > 1 {
			let	rest	=	GenericArgumentClause(arguments.rest.array)
			additionalArgument	=	{ rest }
		}
		additionalArgument	=	nil
	}
	public func writeTo<C : CodeWriterType>(inout w: C) {
		w	<<<	genericArguments
		if let a1 = additionalArgument {
			w.writeToken(",")
			w	<<<	a1()
		}
	}
}






//public struct SubscriptDeclaration {
//	
//}








public typealias	Identifier	=	String












