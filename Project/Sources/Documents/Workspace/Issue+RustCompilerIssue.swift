//
//  Issue+RustCompilerIssue.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/18.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import EditorToolComponents
import EditorIssueListingFeature



extension Issue {
//	init(workspaceRootURL:NSURL, rust:RustCompilerIssue) {
	init(rust:RustCompilerIssue) {
		assert(NSFileManager.defaultManager().fileExistsAtPathAsDataFile(rust.location), "`location` must be a path to an existing file.")
		
		let	u	=	NSURL(fileURLWithPath: rust.location)!
		let	o	=	IssueOrigin(URL: u, range: rust.range)
		let	s	=	convertSeverity(rust.severity)
		let	m	=	rust.message
		self	=	Issue(origination: o, severity: s, message: m)
	}
}

private func convertSeverity(s:RustCompilerIssue.Severity) -> Issue.Severity {
	switch s {
	case .Error:		return	Issue.Severity.Error
	case .Help:			return	Issue.Severity.Information
	case .Note:			return	Issue.Severity.Information
	case .Warning:		return	Issue.Severity.Warning
	}
}

