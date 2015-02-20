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
import EonilFileSystemEvents
import EditorCommon

protocol CodeEditingViewControllerDelegate: class {
	func codeEditingViewControllerWillSetURL(NSURL)
	func codeEditingViewControllerDidSetURL(NSURL)
}

///	This handles file I/O. And file I/O can fail at any time.
class CodeEditingViewController : TextScrollViewController {
	weak var delegate:CodeEditingViewControllerDelegate?
	
	var	URLRepresentation:NSURL? {
		get {
			return	self.representedObject as! NSURL?
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
			Debug.log("Setting `CodeEditingViewController.representedObject` to \(v)...")
			precondition(self.isWaitingForUserResponse == false)
			precondition(v == nil || v is NSURL)
			if let u1 = v as? NSURL {
				Debug.log(u1)
				precondition(u1.existingAsAnyFile)
				precondition(u1.isFileReferenceURL() == false)
			}
			
			////
			
			let	from	=	super.representedObject as! NSURL?
			let	to		=	v as! NSURL?
			
			//	Skip fully duplicated assignment.
			if from == to {
				Debug.log("from == to, exits early")
				return	//	EXITS EARLY.
			}
			
			//	Skip duplicated assignment to a URL to a moved file.
			if to?.fileReferenceURL() == _fileRefURL {
				//	File has been moved to `to` location.
				//	Same URL. Nothing to be done except updating URL.
				_fileRefURL				=	to?.fileReferenceURL()!
				super.representedObject	=	to		//	Need to be updated because this must be non-ref URL.
				
				Debug.log("to?.fileReferenceURL == _fileRefURL, exits early")
				return	//	EXITS EARLY.
			}
		
			//	Now file is unrelated new one.
			//	Reload everything.
			
			//	Skip if old URL does not exists.
			//	And query user for what to do.
			//	And setting URL will be prevented until user responds.
			if let u1 = from {
				if u1.existingAsDataFile == false {
					_isWaitingForUserResponse	=	true
					func recreateQueryMessage(filepath:String) -> String {
						return	"The file for the document that was at \(filepath) has disappeared. The document has previously unsaved changes. Do you want to re-save the document or close it?"
					}
					
					let	m	=	recreateQueryMessage(u1.path!)
					UIDialogues.queryUsingWindowSheetModally(self.view.window!, message: "Warning", comment: m, style: NSAlertStyle.WarningAlertStyle, okButtonTitle: "Re-save", cancelButtonTitle: "Close", handler: { [weak self](selection) -> () in
						switch selection {
						case .OKButton:
							self?._trySavingAsFileAtURL(u1, allowRecreation: true)
							self?._setSuperRepresentedObject(u1)
							self?._isWaitingForUserResponse	=	false
							self?._fileRefURL				=	u1.fileReferenceURL()
							
						case .CancelButton:
							self?._clearContent()
							self?._setSuperRepresentedObject(nil)
							self?._isWaitingForUserResponse	=	false
							self?._fileRefURL				=	nil
						}
					})
					return	//	EXITS EARLY.
				}
			}
		
			////
			
			//	OK. Proceed normal process.
			if let u1 = from {
				if _trySavingAsFileAtURL(u1, allowRecreation: false) {
				}
				_clearContent()
			}
			
			super.representedObject	=	to

			if let u1 = to {
				self._fileRefURL		=	u1.fileReferenceURL()!
				if _tryLoadingContentOfFileAtURL(u1) {
					
				} else {
					super.representedObject	=	nil
					return	//	Clear errorneous value.
				}
			}
		}
	}
	
	private func _setSuperRepresentedObject(o:AnyObject?) {
		super.representedObject	=	o
	}
	
	
	
	
	
	var isWaitingForUserResponse:Bool {
		get {
			return	_isWaitingForUserResponse
		}
	}
	
	
	
	
	
	func trySavingInPlace() -> Bool {
		return	_trySavingAsFileAtURL(URLRepresentation!, allowRecreation: false)
	}
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let	v	=	self.codeTextViewController.codeTextView
		
		v.font			=	Palette.current.codeFont
		v.typingAttributes	=	[
			NSFontAttributeName				:	Palette.current.codeFont,
			NSForegroundColorAttributeName	:	NSColor.textColor(),
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
		
	
	override func instantiateDocumentViewController() -> NSViewController {
		return	CodeTextViewController()
	}
	
	@availability(*,unavailable)
	override var textViewController:TextViewController {
		get {
			return	super.textViewController
		}
	}	
	
	////
	
	private var	_fileRefURL:NSURL?									///	A file-ref URL that tracks movement of target file. Used to determine need for reloading.
	private var	_isWaitingForUserResponse:Bool		=	false		///	Currently this object is querying something from user with window sheet. Some operations will become no-op in this situation.
//	private var	synhigh:SyntaxHighlighting?
//	private var	suspendsynhigh:Bool	=	false
}
extension CodeEditingViewController {
	var codeTextViewController:CodeTextViewController {
		get {
			return	super.textViewController as! CodeTextViewController
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
	@availability(*,unavailable)
	override var textView:NSTextView {
		get {
			return	super.textView
		}
	}
}
extension CodeTextViewController {
	var codeTextView:CodeTextView {
		get {
			return	super.textView as! CodeTextView
		}
	}
	override func instantiateTextView() -> NSTextView {
		let	v				=	CodeTextView()
		v.backgroundColor	=	NSColor.textBackgroundColor()
		v.textColor			=	NSColor.textColor()
		return	v
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
	
	private func _snapshotOfCurrentEditingState() -> String {
		return	self.codeTextViewController.codeTextView.string!
	}
	private func _setCurrentEditingStateBySnapshot(s:String, editable:Bool) {
		self.codeTextViewController.codeTextView.editable	=	editable
		self.codeTextViewController.codeTextView.string		=	s
	}
	
	///	I/O can fail at anytime.
	private func _tryLoadingContentOfFileAtURL(u:NSURL) -> Bool {
		assert(NSFileManager.defaultManager().fileExistsAtPath(u.path!))
		
		var	e1	=	nil as NSError?
		let	s1	=	NSString(contentsOfURL: u, encoding: NSUTF8StringEncoding, error: &e1)
		if let s2 = s1 {
			_setCurrentEditingStateBySnapshot(s2 as! String, editable: true)
			return	true
		} else {
			_setCurrentEditingStateBySnapshot(e1!.localizedDescription, editable: false)
			return	false
		}
	}
	
	///	I/O can fail at anytime.
	///	You shouldn't call this with read-only content.
	private func _trySavingAsFileAtURL(u:NSURL, allowRecreation:Bool) -> Bool {
		Debug.log("_trySavingAsFileAtURL: \(u)")
		precondition(allowRecreation || u.existingAsDataFile)

		if codeTextViewController.codeTextView.editable == false {
			return	false
		}
		
		let	s1	=	_snapshotOfCurrentEditingState()
		var	e1	=	nil as NSError?
		let	ok1	=	s1.writeToURL(u, atomically: false, encoding: NSUTF8StringEncoding, error: &e1)
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

