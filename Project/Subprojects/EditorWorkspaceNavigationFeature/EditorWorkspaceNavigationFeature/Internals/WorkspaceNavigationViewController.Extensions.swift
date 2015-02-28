//
//  WorkspaceNavigationViewController.Extensions.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/28.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

extension WorkspaceNavigationViewController {
	func nodeForAbsoluteFileURL(u:NSURL) -> WorkspaceNode? {
		precondition(internalController.repository != nil)
		assert(u.fileURL)
		assert(u.absoluteString != nil)
		
		if u.existingAsAnyFile == false {
			return	nil
		}
		if self.URLRepresentation == nil {
			return	nil
		}
		
		assert(URLRepresentation!.fileURL)
		assert(URLRepresentation!.absoluteString != nil)
		assert(URLRepresentation!.existingAsDirectoryFile)
		
		let	root_path	=	self.URLRepresentation!.path!
		let	node_path	=	u.path!
		if node_path.hasPrefix(root_path) == false {
			return	nil
		}
		
		let	node_url	=	NSURL(scheme: WorkspacePath.URLScheme, host: nil, path: node_path)!
		let	node_path1	=	WorkspacePath(URL: node_url)
		
		return	internalController.repository!.nodeForPath(node_path1)
	}
//	func nodeForAbsolutePath(p:String) -> WorkspaceNode? {
//		
//	}
}