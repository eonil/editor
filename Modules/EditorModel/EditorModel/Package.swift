//
//  Package.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/06/18.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

///	A pakcage means single product.
public class Package
{
	public let	location	:	ValueChannel<NSURL>
	
	public var workspace: Workspace {
		get {
			return	owner!
		}
	}
	
	///
	
	internal weak var owner: Workspace?
	
	internal init(location: NSURL)
	{
		self.location	=	ValueChannel(location)
	}
	
}

extension Package
{
	public class Target
	{
		public var project: Package {
			get {
				return	owner!
			}
		}
		
		///
		
		internal weak var owner: Package?
	}
}