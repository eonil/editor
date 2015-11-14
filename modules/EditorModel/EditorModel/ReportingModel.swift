//
//  ReportingModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import EditorCommon



public class ReportingModel: ModelSubnode<WorkspaceModel> {

	public var workspace: WorkspaceModel {
		get {
			assert(owner != nil)
			return	owner!
		}
	}

	///
	
	public private(set) var errors		=	[Issue]()
	public private(set) var warnings	=	[Issue]()
	public private(set) var informations	=	[Issue]()









	///

	internal func addIssue(issue: Issue) {
		switch issue.severity {
		case .Information:	errors.append(issue)
		case .Warning:		warnings.append(issue)
		case .Error:		informations.append(issue)
		}
	}

	internal func removeAllIssues() {
		errors		=	[]
		warnings	=	[]
		informations	=	[]
	}
}


public struct Issue {
	public var	severity	:	Severity
	public var	toolID		:	ToolID
	public var	fileURL		:	NSURL
	public var	message		:	String

	public enum Severity {
		case Information
		case Warning
		case Error
	}
}

public enum ToolID {
	case Cargo
	case Racer
}

