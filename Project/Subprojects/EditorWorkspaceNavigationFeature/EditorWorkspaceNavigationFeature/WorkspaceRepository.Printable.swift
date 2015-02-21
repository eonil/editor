//
//  WorkspaceRepository.Printable.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/22.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation








extension WorkspaceNode: Printable {
	public var description:String {
		get {
			return	"(node: path = \(path), kind = \(kind), flags = \(flags))"
		}
	}
}











extension WorkspaceNodeKind: Printable {
	public var description:String {
		get {
			switch self {
			case .File:		return	"file"
			case .Folder:	return	"folder"
			}
		}
	}
}

extension WorkspaceNodeFlags: Printable {
	public var description:String {
		get {
			var	a	=	[] as [String]
			if lazySubtree {
				a.append("lazy-subtree")
			}
//			if subworkspace {
//				a.append("subproject")
//			}
			let	s	=	join(", ", a)
			let	s1	=	"[\(s)]"
			
			return	s1
		}
	}
}












extension WorkspacePath: Printable {
	public var description:String {
		get {
			
			let	ps	=	components.map({ c in "/\(c)" })
			let	ps1	=	join("", ps)
			return	"eews:/\(ps)"
		}
	}
}
