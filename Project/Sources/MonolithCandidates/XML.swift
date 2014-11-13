//
//  XMLParser1.swift
//  RFC Formaliser
//
//  Created by Hoon H. on 10/28/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


///	Provides DOM based read access to XML document.
public struct XML {
	
	public struct Configurations {
		///	Filter element node to keep in DOM tree.
		///
		///	:returns:	`false` if you want to filter out the discovered element.
		///
		///	This function will be called with a fully established element.
		///	the element is fully read, and already added to building DOM tree.
		///	If you return `false`, the passed element will be removed from
		///	the DOM tree.
		public var	shouldKeepElementNode	=	nil as (XML.Element->Bool)?
		
		///	If this set to non-nil function, then it will be called for every
		///	parsing events. If it returns `true`, then the parsing cancels, and
		///	`nil` will be returned.
		public var	shouldCancel			=	nil as (()->Bool)?
		
		public init() {
		}
		public init(shouldKeepElementNode:(XML.Element->Bool)?, shouldCancel:(()->Bool)?) {
			self.shouldKeepElementNode	=	shouldKeepElementNode
			self.shouldCancel			=	shouldCancel
		}
	}
	
	
	
	public class Root: Branch {
		
	}
	public class Branch: Node {
		var	subnodes	=	[] as [Node]
	}
	public class Node {
	}

	
	
	
	public final class Document: Root {
		
	}
	///	Represents an XML element node.
	public final class Element: Branch {
		var	name:String
		var	attributes:[String:String]
		init(name:String, attributes:[String:String]) {
			self.name		=	name
			self.attributes	=	attributes
		}
	}
	public final class Text: Node {
		var	characters:String
		init(characters:String) {
			self.characters	=	characters
		}
	}
	public final class Comment: Node {
		var	characters:String
		init(characters:String) {
			self.characters	=	characters
		}
	}
	public final class CDATA: Node {
		var	data:NSData
		init(data:NSData) {
			self.data	=	data
		}
	}

	///	Scans XML document into DOM from a binary data.
	public static func scan(data:NSData) -> Document? {
		return	scan(data, configurations: XML.Configurations())
	}
	
	///	Scans XML document into DOM from a binary data.
	///	
	///	:data:				A byte array which contains an XML document. Parser will determine the text encoding.
	///	:configurations:	Set delegate functions.
	///
	///	If the XML document too big, then parsing will take very long time
	///	and consumes huge memory. That might not acceptable on mobile environment.
	///	You can specify a delegate function to decide to keep an element or not.
	public static func scan(data:NSData, configurations:Configurations) -> Document? {
		return	parse(data, configurations)
	}
}














































private func parse(data:NSData, config:XML.Configurations) -> XML.Document? {
	let	c1		=	ParsingController(parser: NSXMLParser(data: data))
	c1.config	=	config
	let	ok1		=	c1.parser.parse()
	assert(ok1 == (c1.production != nil))
	return	c1.production
}







private final class ParsingController: NSObject, NSXMLParserDelegate {
	let	parser:NSXMLParser
	
	var	config		=	XML.Configurations()
	var	production	=	nil as XML.Document?
	var	levels		=	[] as [XML.Node]
	var	error		=	nil as String?
	
	init(parser:NSXMLParser) {
		self.parser				=	parser
		super.init()
		self.parser.delegate	=	self
	}
	
	
	func queryCancellation() -> Bool {
		let	answer1	=	config.shouldCancel?()
		return	answer1 == nil ? false : answer1!
	}
	func cancelProcessing() {
		parser.abortParsing()
		error	=	"Cancelled by user request."
	}
	
	var topBranch:XML.Branch {
		get {
			assert(levels.last! is XML.Branch)
			return	levels.last! as XML.Branch
		}
	}
	
	func parserDidStartDocument(parser: NSXMLParser!) {
		assert(production == nil)
		assert(levels.first == nil)
		if queryCancellation() { return cancelProcessing() }
		
		//	Reference.
//		levels	+=	[XML.Document()]
		
		//	Optimisation.
		levels.append(XML.Document())
		
		debugLog("DOC begin")
	}
	func parserDidEndDocument(parser: NSXMLParser!) {
		assert(production == nil)
		assert(levels.first! is XML.Document)
		if queryCancellation() { return cancelProcessing() }
		
		production	=	(levels.first! as XML.Document)
		levels.removeLast()
		
		debugLog("DOC end")
	}
	func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
		if queryCancellation() { return cancelProcessing() }
		autoreleasepool { [unowned self]()->() in
			func attributes() -> [String:String] {
				//	Optimisation.
				if attributeDict.count == 0 {
					return	[:]
				}
				
				var	as1	=	[:] as [String:String]
				for (k,v) in attributeDict {
					as1[k as NSString as String]	=	v as NSString as String
				}
				return	as1
			}
			
			let	e1	=	XML.Element(name: elementName, attributes: attributes())
			
//			//	Reference.
//			self.topBranch.subnodes		+=	[e1]
//			self.levels					+=	[e1]
			
			//	Optimsation.
			self.topBranch.subnodes.append(e1)
			self.levels.append(e1)
			
			debugLog("ELE \(elementName) begin")
		}
	}
	func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
		assert(topBranch is XML.Element)
		assert((topBranch as XML.Element).name == elementName)
		if queryCancellation() { return cancelProcessing() }
		
		autoreleasepool { [unowned self]()->() in
			let	e1	=	self.levels.last! as XML.Element
			self.levels.removeLast()
			
			if let ok1 = self.config.shouldKeepElementNode?(e1) {
				if !ok1 {
					assert(e1 === self.topBranch.subnodes.last!)
					self.topBranch.subnodes.removeLast()
				}
			}
			
			debugLog("ELE \(elementName) end")
		}
	}
	func parser(parser: NSXMLParser!, foundCharacters string: String!) {
		if queryCancellation() { return cancelProcessing() }
		
		autoreleasepool { [unowned self]()->() in
			if self.topBranch.subnodes.last is XML.Text {
				let	t1			=	self.topBranch.subnodes.last as XML.Text
				t1.characters	+=	string
			} else {
				let	n1	=	XML.Text(characters: string)
				
//				//	Reference.
//				self.topBranch.subnodes	+=	[n1]
				
				//	Optimisation.
				self.topBranch.subnodes.append(n1)
			}
			
			debugLog("TEXT: \(string)")
		}
	}
	func parser(parser: NSXMLParser!, foundCDATA CDATABlock: NSData!) {
		if queryCancellation() { return cancelProcessing() }
		
		func merge(a:NSData, b:NSData) -> NSData {
			let	d1	=	NSMutableData(data: a)
			d1.appendData(b)
			return	d1
		}
		
		autoreleasepool { [unowned self]()->() in
			if self.topBranch.subnodes.last is XML.CDATA {
				let	t1			=	self.topBranch.subnodes.last as XML.CDATA
				t1.data			=	merge(t1.data, CDATABlock)
			} else {
				let	n1	=	XML.CDATA(data: CDATABlock)

//				//	Reference.
//				self.topBranch.subnodes	+=	[n1]
				
				//	Optimisation.
				self.topBranch.subnodes.append(n1)
			}
			
			debugLog("CDATA: \(CDATABlock.length) byte")
		}
	}
	
	
	
//	func parser(parser: NSXMLParser!, foundElementDeclarationWithName elementName: String!, model: String!) {
//		
//	}
//	func parser(parser: NSXMLParser!, foundAttributeDeclarationWithName attributeName: String!, forElement elementName: String!, type: String!, defaultValue: String!) {
//		
//	}
//	func parser(parser: NSXMLParser!, foundExternalEntityDeclarationWithName name: String!, publicID: String!, systemID: String!) {
//		
//	}
//	func parser(parser: NSXMLParser!, foundInternalEntityDeclarationWithName name: String!, value: String!) {
//		
//	}
//	func parser(parser: NSXMLParser!, foundNotationDeclarationWithName name: String!, publicID: String!, systemID: String!) {
//		
//	}
//	func parser(parser: NSXMLParser!, foundUnparsedEntityDeclarationWithName name: String!, publicID: String!, systemID: String!, notationName: String!) {
//		
//	}
	
	
//	func parser(parser: NSXMLParser!, foundProcessingInstructionWithTarget target: String!, data: String!) {
//		
//	}
//	func parser(parser: NSXMLParser!, foundComment comment: String!) {
//		
//	}
//	func parser(parser: NSXMLParser!, foundIgnorableWhitespace whitespaceString: String!) {
//		
//	}
	
	
	
//	func parser(parser: NSXMLParser!, resolveExternalEntityName name: String!, systemID: String!) -> NSData! {
//		
//	}
//	func parser(parser: NSXMLParser!, didStartMappingPrefix prefix: String!, toURI namespaceURI: String!) {
//		
//	}
//	func parser(parser: NSXMLParser!, didEndMappingPrefix prefix: String!) {
//		
//	}
	
	
	
	func parser(parser: NSXMLParser!, parseErrorOccurred parseError: NSError!) {
		self.error	=	parseError.debugDescription
	}
	func parser(parser: NSXMLParser!, validationErrorOccurred validationError: NSError!) {
		self.error	=	validationError.debugDescription
	}
	
	
}





private func debugLog<T>(v:@autoclosure()->T) {
//	#if DEBUG
//		debugPrintln(v())
//	#endif
}








