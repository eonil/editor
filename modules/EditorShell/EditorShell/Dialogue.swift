//
//  Dialogue.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

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


	static func runSavingWorkspace(completion: NSURL?->()) {
		let	saveP			=	NSSavePanel()
		saveP.canCreateDirectories	=	true

		let	result			=	saveP.runModal()

		switch result {
		case NSFileHandlingPanelOKButton:
			if let u = saveP.directoryURL {
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

}










