////
////  CodeTextStorage.swift
////  Editor
////
////  Created by Hoon H. on 2014/12/26.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//
//final class CodeTextStorage: NSTextStorage {
//	enum SyntacticType: UInt8 {
//		case None		//	Plain typical text.
//		case Attribute	//	Attributes.
//		case Keyword	
////		case Identifier	//	Identifier.
//		case String		//	String literal.
////		case Number		//	Numeric literal.
////		case Macro		//	Macro invocation.
//		case Comment	//	Comment.
//	}
//
//	
//	func syntacticTypeAtIndex(index:Int) -> SyntacticType {
//		return	aa[index]
//	}
//	func setSyntacticType(type:SyntacticType, range:NSRange, notify:Bool) {
//		Debug.log("\(range)")
//		
//		for i in range.toRange()! {
//			aa[i]	=	type
//		}
//		
//		if notify {
//			//
//			//	Changes must be notified!
//			//
//			self.edited(Int(NSTextStorageEditedOptions.Attributes.rawValue), range: range, changeInLength: 0)
//		}
//	}
//	
//	func beginSettingSyntacticType() {
//		lazyNotifyFlag	=	true
//	}
//	func endSettingSyntacticType() {
//		lazyNotifyFlag	=	false
//	}
//	
//	
//	
//	override var string:String {
//		get {
//			return	s
//		}
//	}
//	override func attributesAtIndex(location: Int, longestEffectiveRange range: NSRangePointer, inRange rangeLimit: NSRange) -> [NSObject : AnyObject] {
//		let	aaa	=	self.attributesAtIndex(location, effectiveRange: range)
//		let	r2	=	rangeLimit.toRange()!
//		var	r3	=	range.memory.toRange()!
//		
//		var	c1	=	r3.startIndex
//		let	m1	=	max(0, r2.startIndex)
//		while c1 >= m1 {
//			if aa[c1] == aa[location] {
//				r3.startIndex	=	c1
//				c1--
//			} else {
//				break
//			}
//		}
//		var	c2	=	r3.endIndex
//		let	m2	=	min(s.utf16Count, r2.endIndex)
//		while c2 < m2 {
//			if aa[c2] == aa[location] {
//				r3.endIndex	=	c2
//				c2++
//			} else {
//				break
//			}
//		}
//		
//		range.memory	=	NSRange(location: r3.startIndex, length: r3.endIndex-r3.startIndex)
//		return	aaa
//	}
//	override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [NSObject : AnyObject] {
//		//
//		//	`range` is an output parameter! You must set it to a proper value.
//		//
//		if range != nil {
////			range.memory	=	NSRange(location: 0, length: self.length)
//			range.memory	=	NSRange(location: location, length: 1)
//		}
//		
//		return	attributesForType(aa[location])
//	}
//	
//	override func replaceCharactersInRange(range: NSRange, withString str: String) {
//		s	=	(s as NSString).stringByReplacingCharactersInRange(range, withString: str)
//		
//		let	newas1	=	Array<SyntacticType>(count: str.utf16Count, repeatedValue: SyntacticType.None)
//		aa.replaceRange(range.toRange()!, with: newas1)
//		
//		let	d	=	range.length - (str as NSString).length
//		let	d1	=	abs(d)
//		
//		//
//		//	Changes must be notified!
//		//
//		self.edited(Int(NSTextStorageEditedOptions.Characters.rawValue), range: range, changeInLength: d1)
//	}
//	override func setAttributes(attrs: [NSObject : AnyObject]?, range: NSRange) {
//		//	No-op. Will be ignored. Use `setSyntacticType` instead of.
////		fatalError("You cannot set attributes directly. Instead, use `setSyntacticType` instead of.")
//	}
//	override func fixAttachmentAttributeInRange(range: NSRange) {
//		//	No-op.
//	}
//	override func fixAttributesInRange(range: NSRange) {
//		//	No-op.
//	}
//	
//	////
//	
//	private var	s	=	String()
//	private var	aa	=	[] as [SyntacticType]		//	Syntactic type is noted for all each Unicode code-units.
//	
//	private var	lazyNotifyFlag		=	false
//	private var	idxsToNotify		=	NSMutableIndexSet()
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
////@objc
////class CodeDocumentString: NSMutableString {
////	
////	var	blocks	=	[] as [CodeBlockString]
////	
////	override var length:NSInteger {
////		get {
////			
////		}
////	}
////	override func characterAtIndex(index: Int) -> unichar {
////		
////	}
////	override func replaceCharactersInRange(range: NSRange, withString aString: String) {
////		
////	}
////}
////
////@objc
////class CodeBlockString: NSMutableString {
////	
////	override var length:NSInteger {
////		get {
////			
////		}
////	}
////	override func characterAtIndex(index: Int) -> unichar {
////		
////	}
////	override func replaceCharactersInRange(range: NSRange, withString aString: String) {
////		
////	}
////	
////}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
/////	MARK:	Data Section
//
//private func attributesForType(t:CodeTextStorage.SyntacticType) -> [NSObject:AnyObject] {
//	switch t {
//	case .None:
//		return	textAttributes
//	case .Keyword:
//		return	keywordAttributes
//	case .Attribute:
//		return	attributeAttributes
//	case .String:
//		return	stringAttributes
//	case .Comment:
//		return	commentAttributes
//	}
//}
//
//
//
//private let	textAttributes	=	[
//	NSFontAttributeName:				Palette.current.codeFont,
//	NSForegroundColorAttributeName:		NSColor.textColor(),
//]
//private let	stringAttributes	=	[
//	NSFontAttributeName:				Palette.current.codeFont,
//	NSForegroundColorAttributeName:		stringColor(),
//]
//private let	attributeAttributes	=	[
//	NSFontAttributeName:				Palette.current.codeFont,
//	NSForegroundColorAttributeName:		attributeColor(),
//]
//private let	keywordAttributes	=	[
//	NSFontAttributeName:				Palette.current.codeFont,
//	NSForegroundColorAttributeName:		keywordColor(),
//]
//private let	commentAttributes	=	[
//	NSFontAttributeName:				Palette.current.codeFont,
//	NSForegroundColorAttributeName:		commentColor(),
//]
//
//
//
//private func stringColor() -> NSColor {
//	return	NSColor.withUInt8Components(red: 196, green: 26, blue: 22, alpha: 255)
//}
//private func attributeColor() -> NSColor {
//	return	NSColor.withUInt8Components(red: 131, green: 108, blue: 40, alpha: 255)
//}
//private func commentColor() -> NSColor {
//	return	NSColor.withUInt8Components(red: 0, green: 116, blue: 0, alpha: 255)
//}
//private func keywordColor() -> NSColor {
//	return	NSColor.withUInt8Components(red: 170, green: 13, blue: 145, alpha: 255)
//}
//
//
//
