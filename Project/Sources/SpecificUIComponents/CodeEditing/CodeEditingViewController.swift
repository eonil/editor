//
//  CodeEditingViewController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/11/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilDispatch

class CodeEditingViewController : TextScrollViewController {
	
	
	var	URLRepresentation:NSURL? {
		get {
			return	self.representedObject as NSURL?
		}
		set(v) {
			self.representedObject	=	v
		}
	}
	override var representedObject:AnyObject? {
		get {
			return	super.representedObject
		}
		set(v) {
			precondition(v == nil || v! is NSURL)
			
			//	Skip duplicated assignment.
			if v as NSURL? == super.representedObject as NSURL? {
				return
			}
			
			if let u1 = URLRepresentation {
				if _trySavingContentInPlace() {
				}
				_clearContent()
			}
			
			if let u1 = v as NSURL? {
				super.representedObject	=	v
				if _tryLoadingContentOfFileAtURL(u1) {
				} else {
					super.representedObject	=	nil
					return	//	Clear errorneous value.
				}
			}
		}
//		willSet(v) {
//			precondition(v == nil || v! is NSURL)
//			if let u1 = URLRepresentation {
//				precondition(u1.existingAsDataFile)	//	Do not set non-data-file to this editor.
//				_saveContentInPlace()
//				_clearContent()
//			}
//		}
//		didSet {
//			if let u1 = URLRepresentation {
//				_loadContentOfFileAtURL(u1)
//			}
//		}
	}
	
	
	
	
	
	func trySavingInPlace() -> Bool {
		return	_trySavingContentInPlace()
	}
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let	v	=	self.codeTextViewController.codeTextView
		
		v.font			=	Palette.current.codeFont
		v.typingAttributes	=	[
			NSFontAttributeName	:	Palette.current.codeFont,
		]
		v.allowsUndo	=	true
		v.delegate		=	self
		
		
//		v.layoutManager!.usesScreenFonts			=	true		//	This makes text looks very ugly. Don't use it.
		v.layoutManager!.usesFontLeading			=	true
		v.layoutManager!.allowsNonContiguousLayout	=	true		//	Critical to load massive amount of text fast. This allows fixed-height line based layout.
		v.layoutManager!.hyphenationFactor			=	0
		
		v.continuousSpellCheckingEnabled			=	false
		v.grammarCheckingEnabled					=	false
		v.automaticDashSubstitutionEnabled			=	false
		v.automaticDataDetectionEnabled				=	false
		v.automaticLinkDetectionEnabled				=	false
		v.automaticQuoteSubstitutionEnabled			=	false
		v.automaticSpellingCorrectionEnabled		=	false
		v.automaticTextReplacementEnabled			=	false
		v.incrementalSearchingEnabled				=	false
		v.enabledTextCheckingTypes					=	NSTextCheckingTypes.allZeros

		v.turnOffKerning(self)
		v.turnOffLigatures(self)
	}
	
	func highlightRangesOfIssues(ss:[Issue]) {
		var	rs1	=	[] as [NSRange]
		for s in ss {
			for i in s.range.start.line...s.range.end.line {
				let	r1	=	(codeTextViewController.codeTextView.string! as NSString).findNSRangeOfLineContentAtIndex(i)
				rs1.append(r1!)
			}
		}
		codeTextViewController.codeTextView.selectedRanges	=	rs1
		codeTextViewController.codeTextView.scrollRangeToVisible(rs1[0])
	}
	func navigateRangeOfIssue(s:Issue) {
		let	r1	=	codeTextViewController.codeTextView.string!.findNSRangeOfLineContentAtIndex(s.range.start.line)
		if let r2 = r1 {
			codeTextViewController.codeTextView.window!.makeFirstResponder(codeTextViewController.codeTextView)
			codeTextViewController.codeTextView.selectedRanges	=	[r1!]
			codeTextViewController.codeTextView.scrollRangeToVisible(r1!)
		} else {
		}
	}
	
	
	override func instantiateDocumentViewController() -> NSViewController {
		return	CodeTextViewController()
	}
	
	
	
	
	
//	private var	synhigh:SyntaxHighlighting?
//	private var	suspendsynhigh:Bool	=	false
}
extension CodeEditingViewController {
	var codeTextViewController:CodeTextViewController {
		get {
			return	super.textViewController as CodeTextViewController
		}
	}
	@availability(*,unavailable)
	override var textViewController:TextViewController {
		get {
			return	super.textViewController
		}
	}
}
//extension CodeEditingViewController: NSTextStorageDelegate {
//	func textStorageWillProcessEditing(notification: NSNotification) {
//		Debug.log("textStorageWillProcessEditing")
//		assert(notification.name == NSTextStorageWillProcessEditingNotification)
//		
//		if synhigh == nil {
//			synhigh	=	SyntaxHighlighting(targetTextView: self.codeTextViewController.codeTextView)
//		}
//		synhigh!.reset()
//		
//		if (UInt(self.codeTextViewController.codeTextView.textStorage!.editedMask) & NSTextStorageEditedOptions.Characters.rawValue) == NSTextStorageEditedOptions.Characters.rawValue {
//			suspendsynhigh	=	true
//		}
//	}
//	func textStorageDidProcessEditing(notification: NSNotification) {
//		Debug.log("textStorageDidProcessEditing")
//		if (UInt(self.codeTextViewController.codeTextView.textStorage!.editedMask) & NSTextStorageEditedOptions.Characters.rawValue) == NSTextStorageEditedOptions.Characters.rawValue {
//			suspendsynhigh	=	false
//			synhigh	=	SyntaxHighlighting(targetTextView: self.codeTextViewController.codeTextView)
//			queueSyntaxHighlightingStepping()
//		}
//	}
//	
//	private func queueSyntaxHighlightingStepping() {
//		weak var	o1	=	self
//		async(Queue.main) {
//			if let o = o1 {
//				if let sh = o.synhigh {
//					if o.suspendsynhigh == false && sh.available() {
//						sh.step()
//						o.queueSyntaxHighlightingStepping()
//					}
//				}
//			}
//		}
//	}
//}


















class CodeTextViewController: TextViewController {
}
extension CodeTextViewController {
	var codeTextView:CodeTextView {
		get {
			return	super.textView as CodeTextView
		}
	}
	@availability(*,unavailable)
	override var textView:NSTextView {
		get {
			return	super.textView
		}
	}
	
	override func instantiateTextView() -> NSTextView {
		return	CodeTextView()
	}
}
class CodeTextView: NSTextView {

	func instantiateAutocompletionController() -> CodeTextViewAutocompletionController {
		return	RustAutocompletion.WindowController()
	}
	
	override func complete(sender: AnyObject?) {
		if autocompletionC == nil {
			autocompletionC	=	instantiateAutocompletionController()
			autocompletionC!.presentForSelectionOfTextView(self)
		} else {
			autocompletionC!.dismiss()
			autocompletionC	=	nil
		}
	}
	override func keyDown(theEvent: NSEvent) {
		if let wc1 = autocompletionC {
			let	s	=	theEvent.charactersIgnoringModifiers!
			let	s1	=	s.unicodeScalars
			let	s2	=	s1[s1.startIndex].value
			let	s3	=	Int(s2)
			switch s3 {
			case NSUpArrowFunctionKey:
				wc1.navigateUp()
				return
			case NSDownArrowFunctionKey:
				wc1.navigateDown()
				return
			default:
				break
			}
		}
		super.keyDown(theEvent)
	}
	
	////
	
	private var	autocompletionC: CodeTextViewAutocompletionController?
}


protocol CodeTextViewAutocompletionController {
	func presentForSelectionOfTextView(textView:NSTextView)
	func dismiss()
	func navigateUp()
	func navigateDown()
}
	
	

























///	MARK:

extension CodeEditingViewController {
	
	///	I/O can fail at anytime.
	private func _tryLoadingContentOfFileAtURL(u:NSURL) -> Bool {
		assert(NSFileManager.defaultManager().fileExistsAtPath(u.path!))
		
		var	e1	=	nil as NSError?
		let	s1	=	NSString(contentsOfURL: u, encoding: NSUTF8StringEncoding, error: &e1)
		if let s2 = s1 {
			self.codeTextViewController.codeTextView.editable	=	true
			self.codeTextViewController.codeTextView.string		=	s2
			return	true
		} else {
			self.codeTextViewController.codeTextView.editable	=	false
			self.codeTextViewController.codeTextView.string		=	e1!.localizedDescription
			return	false
		}
	}
	
	///	I/O can fail at anytime.
	private func _trySavingContentInPlace() -> Bool {
		Debug.log(URLRepresentation)
		assert(URLRepresentation != nil)
		assert(NSFileManager.defaultManager().fileExistsAtPath(URLRepresentation!.path!))
		
		let	s1	=	self.codeTextViewController.codeTextView.string!
		var	e1	=	nil as NSError?
		let	ok1	=	s1.writeToURL(URLRepresentation!, atomically: true, encoding: NSUTF8StringEncoding, error: &e1)
		Debug.log("Code document saved.")
		
		if !ok1 {
			NSAlert(error: e1!).runModal()
		}
		
		return	ok1
	}
	private func _clearContent() {
		self.codeTextViewController.codeTextView.string		=	""
		self.codeTextViewController.codeTextView.editable	=	false
	}
}

























///	MARK:

extension CodeEditingViewController: NSTextViewDelegate {
	func textView(textView: NSTextView, shouldChangeTextInRange affectedCharRange: NSRange, replacementString: String) -> Bool {
		if contains(triggerSuffixes(), replacementString) {
//			textView.insertCompletion("AAA", forPartialWordRange: affectedCharRange, movement: NSWritingDirectionNatural, isFinal: false)
//			textView.complete(self)
		}
		return	true
	}
//	func textView(textView: NSTextView, completions words: [AnyObject], forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [AnyObject] {
//		Debug.log(words)
//		Debug.log(NSStringFromRange(charRange))
//		index.memory	=	1
//		let	ms	=	RacerExecutionController().resolve("std::")
//		let	ss	=	ms.map({ a in return a.matchString }) as [String]
//		return	ss as [AnyObject]
//	}
	
	private func triggerAutocompletion() {
		
	}
}

private func triggerSuffixes() -> [String] {
	return	[
		"::",
		".",
		"(",
		"-> ",
		":",
	]
}











let NSWritingDirectionNatural	=	-1

