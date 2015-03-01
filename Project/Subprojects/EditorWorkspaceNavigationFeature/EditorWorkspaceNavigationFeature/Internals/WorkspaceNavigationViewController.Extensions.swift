//
//  WorkspaceNavigationViewController.Extensions.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/28.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

extension WorkspaceNavigationViewController {
	///	This just calculate node for proposed location,
	///	and does not check existence of file at URL.
	func nodeForAbsoluteFileURL(u:NSURL) -> WorkspaceNode? {
		precondition(URLRepresentation != nil)
		precondition(internalController.repository != nil)
		assert(URLRepresentation!.fileURL)
		assert(URLRepresentation!.absoluteString != nil)
		assert(URLRepresentation!.existingAsDirectoryFile)
		assert(u.fileURL)
		assert(u.absoluteString != nil)
		assert(u.absoluteString!.hasPrefix(self.URLRepresentation!.absoluteString!))
		
		////
		
		let	root_file_path	=	self.URLRepresentation!.path!
		let	node_file_path	=	u.path!
		if node_file_path.hasPrefix(root_file_path) == false {
			return	nil
		}
		
		let	node_path	=	node_file_path.substringFromIndex(root_file_path.endIndex)
		let	node_url	=	NSURL(scheme: WorkspacePath.URLScheme, host: nil, path: node_path)!
		let	node_path1	=	WorkspacePath(URL: node_url)
		
		return	internalController.repository!.nodeForPath(node_path1)
	}
	func URLForNode(n:WorkspaceNode) -> NSURL {
		assert(URLRepresentation != nil)
		
		return	URLRepresentation!.URLByAppendingPath(n.path)
	}
//	func nodeForAbsolutePath(p:String) -> WorkspaceNode? {
//		
//	}
}










