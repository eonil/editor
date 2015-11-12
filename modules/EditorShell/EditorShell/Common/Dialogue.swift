//
//  Dialogue.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon

struct Dialogue {
	/*!

	
	- Parameters:
  	  - completion:	Called when the opening sequence has been finished.


	*/


	/// Runs a workspace selecting sequence.
	///
	/// - Parameters:
	///
	///	- completion:
	///
	///		Called when the opening sequence has been finished.
	///		`nil` if user cancelled opening sequence.
	///		A valid URL if user finally chose a location.
	///
	static func runOpeningWorkspace(completion: NSURL?->()) {
		let	openP			=	NSOpenPanel()
		openP.canChooseFiles		=	false
		openP.canChooseDirectories	=	true
		let	result			=	openP.runModal()

		switch result {
			case NSFileHandlingPanelOKButton:
				if let u = openP.directoryURL {
					completion(u)
					return
				}

			case NSFileHandlingPanelCancelButton:
				fallthrough

			default:
				///	WTF?
				break
		}

		completion(nil)
		return
	}


	/// Runs a save-panel and returns a absolute file path URL
	/// to a selected file including file name part.
	static func runSavingWorkspace(completion: NSURL?->()) {
		let	saveP			=	NSSavePanel()
		saveP.canCreateDirectories	=	true

		let	result			=	saveP.runModal()

		switch result {
		case NSFileHandlingPanelOKButton:
			if let u = saveP.URL {
				completion(u)
				return
			}

		case NSFileHandlingPanelCancelButton:
			fallthrough

		default:
			/// WTF?
			reportToDevelopers()
			break
		}

		completion(nil)
		return
	}

	static func runSavingNewFile(continuation: NSURL?->()) {
		let	saveP			=	NSSavePanel()
		saveP.canCreateDirectories	=	true

		let	result			=	saveP.runModal()

		switch result {
		case NSFileHandlingPanelOKButton:
			if let u = saveP.URL {
				continuation(u)
				return
			}

		case NSFileHandlingPanelCancelButton:
			fallthrough

		default:
			/// WTF?
			reportToDevelopers()
			break
		}

		continuation(nil)
		return
	}



	static func runErrorAlertModally(error: ErrorType) {
		NSAlert(error: error as NSError).runModal()
	}
}










