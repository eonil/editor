//
//  Dialogues.swift
//  Precompilation
//
//  Created by Hoon H. on 2015/01/11.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

public struct UIDialogues {
}

public extension UIDialogues {
	
	
	///	Queries using NSWindow sheet with "OK" and "Cancel" button.
	public static func queryDeletingFilesUsingWindowSheet(window:NSWindow, files:[NSURL], handler:(UIDialogueButton)->()) {
		precondition(files.count > 0)
		func msg() -> String {
			switch files.count {
			case 1:
				let	name	=	NSFileManager.defaultManager().displayNameAtPath(files[0].path!)
				return	"Do you want to move the file “\(name)” to the Trash?"
			default:
				return	"Do you want to move the “\(files.count)” files to the Trash?"
			}
		}
		let	cmt	=	"This operation is not undoable."
		queryUsingWindowSheet(window, message: msg(), comment: cmt, style: NSAlertStyle.WarningAlertStyle, handler: handler)
	}
	
	///	Queries using NSWindow sheet with "OK" and "Cancel" button.
	public static func queryUsingWindowSheet(window:NSWindow, message:String, comment:String, style:NSAlertStyle, handler:(UIDialogueButton)->()) {
		let	a	=	NSAlert()
		a.addButtonWithTitle("OK")
		a.addButtonWithTitle("Cancel")
		a.messageText		=	message
		a.informativeText	=	comment
		a.alertStyle		=	style
		
		a.beginSheetModalForWindow(window, completionHandler: { (r:NSModalResponse) -> Void in
			switch r {
			case NSAlertFirstButtonReturn:
				handler(UIDialogueButton.OKButton)
				
			case NSAlertSecondButtonReturn:
				handler(UIDialogueButton.CancelButton)
				
			case NSAlertThirdButtonReturn:
				fallthrough
			default:
				fatalError("This shouldn't happen.")
			}
		})
	}
	
	public static func alertModally(message:String, comment:String?, style:NSAlertStyle) {
		let	a	=	NSAlert()
		a.addButtonWithTitle("OK")
		a.messageText		=	message
		a.informativeText	=	comment
		a.alertStyle		=	style
		a.runModal()
	}
}

public enum UIDialogueButton {
	case OKButton
	case CancelButton
}


















