//
//  ConsoleModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import EditorCommon

public class ConsoleModel: ModelSubnode<WorkspaceModel>, BroadcastingModelType {
	public var workspace: WorkspaceModel {
		get {
			assert(owner != nil)
			return	owner!
		}
	}

	public let	event	=	EventMulticast<Event>()





	///

	public private(set) var outputLines: [String] = []

	public func appendLine(line: String) {
		fatalErrorBecauseUnimplementedYet()
	}
	public func appendLines(lines: String) {
		fatalErrorBecauseUnimplementedYet()
	}
	public func appendLines<C: CollectionType where C.Generator.Element == String, C.Index == Int>(lines: C) {
		outputLines.appendContentsOf(lines)
	}
}
