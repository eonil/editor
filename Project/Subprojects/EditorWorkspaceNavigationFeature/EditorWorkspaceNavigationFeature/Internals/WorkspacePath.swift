//
//  WorkspacePath.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/28.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

///	Represents full-path from repository root.
///
///	For example, assume that we have a repository at `/sample1/repo2`
///	with these files.
///
///		/sample1
///			/repo2
///				/folder3
///					/file4
///					/file5
///				/file6
///
///	You will get these entries in the repository.
///
///		/folder3/file4
///		/folder3/file5
///		/file6
///
public struct WorkspacePath {
	///	Represents path expression.
	///	This will be built with `path` part only with string that starting with `/`.
	///	For example, `file5` will be stored like this.
	///
	///		eews://folder3/file5
	///
	var components:[String]
}


public extension WorkspacePath {
	public static let	URLScheme	=	PATH_URL_SCHEME
}





extension WorkspacePath: Equatable, Hashable {
	public var hashValue:Int {
		get {
			switch components.count {
			case 0:		return	0
			case 1:		return	components[0].hashValue
			default:	return	components[components.count-1].hashValue + components[components.count-2].hashValue
			}
		}
	}
	
	public var isRoot:Bool {
		get {
			return	components.count == 0
		}
	}
	
	///	Calling this when current object's `isRoot == true` will crash the program.
	public var parentPath:WorkspacePath {
		get {
			precondition(isRoot == false, "Current path is root. Parent cannot be defined.")
			return	WorkspacePath(components: Array(components[components.startIndex..<components.endIndex.predecessor()]))
		}
	}
	public func childPathWithComponent(component:String) -> WorkspacePath {
		return	WorkspacePath(components: self.components + [component])
	}
	public func pathByDeletingFirstComponent() -> WorkspacePath {
		precondition(components.count > 0)
		return	WorkspacePath(components: Array(components[1..<components.count]))
	}
	public func pathByDeletingLastComponent() -> WorkspacePath {
		precondition(components.count > 0)
		return	WorkspacePath(components: Array(components[0..<components.count-1]))
	}
}

public extension WorkspacePath {
	public var URL:NSURL {
		get {
			var u	=	NSURL(scheme: PATH_URL_SCHEME, host: nil, path: "/")!
			for c in components {
				u	=	u.URLByAppendingPathComponent(c)
			}
			return	u
		}
	}
}

public func == (left:WorkspacePath, right:WorkspacePath) -> Bool {
	///	TODO: Optimise this. Paths are very likely to share suffix components, so compare from back to front.
	return	left.components == right.components
}





internal extension WorkspacePath {
	///	Creates a path using supplied URL.
	///	The URL must have `nil` host.
	///	The URL must have `PATH_URL_SCHEME` scheme.
	///	The URL must have rooted `path`. That starts with `/`.
	internal init(URL:NSURL) {
		precondition(URL.host == nil)
		precondition(URL.scheme == PATH_URL_SCHEME)
		precondition(URL.path != nil)
		precondition(URL.path!.hasPrefix("/"))
		
		let	cs	=	URL.path!.pathComponents
		assert(cs.count >= 1)
		assert(cs[0] == "/")
		
		components	=	Array(cs[1..<cs.endIndex])
	}
}




//private let NODE_URL_SCHEME	=	"eonil.editor.workspace.node"
private let PATH_URL_SCHEME	=	"eonil.editor.workspace.path"





