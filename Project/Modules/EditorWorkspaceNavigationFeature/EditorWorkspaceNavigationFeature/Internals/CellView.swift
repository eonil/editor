//
//  CellView.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/22.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon
import EditorUIComponents



internal enum WorkspaceNavigationTreeColumnIdentifier: String {
	case	Name		=	"NAME"
	case	Comment		=	"COMMENT"
}



internal final class CellView: NSTableCellView {
	var	columnIdentifier:WorkspaceNavigationTreeColumnIdentifier	=	WorkspaceNavigationTreeColumnIdentifier.Name
	
	init(_ columnIdentifier:WorkspaceNavigationTreeColumnIdentifier) {
		super.init(frame: CGRect.zeroRect)
		self.columnIdentifier	=	columnIdentifier
		
		switch self.columnIdentifier {
		case WorkspaceNavigationTreeColumnIdentifier.Name:
			let	v1	=	NSImageView()
			let	v2	=	NSTextField()
			self.addSubview(v1)
			self.addSubview(v2)
			
			v2.editable			=	true
			v2.bordered			=	false
			v2.bezeled			=	false				//	This property is essential to provide clear look in dark vibrancy mode.
			v2.drawsBackground	=	false				//	This property is essential to provide clear look in dark vibrancy mode.
			(v2.cell() as! NSCell).lineBreakMode	=	NSLineBreakMode.ByTruncatingTail
			
			self.imageView		=	v1
			self.textField		=	v2
			
		case WorkspaceNavigationTreeColumnIdentifier.Comment:
			let	v2	=	NSTextField()
			self.addSubview(v2)
			
			v2.editable			=	false
			v2.bordered			=	false
			v2.bezeled			=	false				//	This property is essential to provide clear look in dark vibrancy mode.
			v2.drawsBackground	=	false				//	This property is essential to provide clear look in dark vibrancy mode.
			(v2.cell() as! NSCell).lineBreakMode	=	NSLineBreakMode.ByTruncatingTail
			
			self.textField		=	v2
			
		default:
			fatalError("Unknown column identifier `\(self.columnIdentifier)` detected.")
		}
	}
	
	@availability(*,unavailable)
	required init() {
		super.init(frame: CGRect.zeroRect)
	}
	
	@availability(*,unavailable)
	required init?(coder: NSCoder) {
		fatalError("Unsupported initializer.")
	}
	
	@availability(*,unavailable)
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		
	}
	
	
	
	var nodeRepresentation:WorkspaceNode? {
		get {
			return	super.objectValue as! WorkspaceNode?
		}
		set(v) {
			super.objectValue	=	v
			
			switch self.columnIdentifier {
			case WorkspaceNavigationTreeColumnIdentifier.Name:
				let	n	=	v!.name
				let	c	=	v!.comment ?? ""
				let	t	=	c == "" ? n : "\(n) (\(c))"
				
				let	m	=	v!.kind == WorkspaceNodeKind.Folder ? Icons.folder : Icons.file
				
				imageView!.image		=	m
				textField!.objectValue	=	t
				
			case WorkspaceNavigationTreeColumnIdentifier.Comment:
				textField!.objectValue	=	v!.comment ?? ""
				
			default:
				fatalError("Unknown column identifier `\(self.columnIdentifier)` detected.")
			}
		}
	}
	
	@availability(*,unavailable)
	override var objectValue:AnyObject? {
		willSet(v) {
			precondition(v == nil || v is WorkspaceNode, "Only `WorkspaceNode` type is acceptable.")
		}
		//		get {
		//
		//		}
		//		set(v) {
		//
		//		}
	}
}














private class CellTextField: NSTextField {
	@objc
	override var acceptsFirstResponder:Bool {
		get {
			return	true
		}
	}
	
//	///	Called when user pressed ESC key.
//	@objc
//	override func cancelOperation(sender: AnyObject?) {
//		super.cancelOperation(sender)
//	}
}













private extension NSImage {
	var templateImage:NSImage {
		get {
			let	m	=	self.copy() as! NSImage
			m.setTemplate(true)
			return	m
		}
	}
}



private struct Icons {
	static let	folder	=	IconPalette.FontAwesome.WebApplicationIcons.folder.image.templateImage
	static let	file	=	IconPalette.FontAwesome.WebApplicationIcons.fileO.image.templateImage
}





