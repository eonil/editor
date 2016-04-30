//
//  WorkspaceDocument.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/21.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

final class WorkspaceDocument: NSDocument, DriverAccessible {
        override func readFromURL(url: NSURL, ofType typeName: String) throws {
                // Don't call super-class implementation.
        }
        private func render() {
            
        }
}