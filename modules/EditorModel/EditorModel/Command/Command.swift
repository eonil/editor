////
////  Command.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/10/30.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
//enum Command {
//
//}
//
//enum ApplicationModelCommand {
//	case AddWorkspace(location: NSURL)
//	case RemoveWorkspace(location: NSURL)
//	case Workspace(WorkspaceModelCommand)
//}
//
//enum WorkspaceModelCommand {
//	case FileTree(FileTreeModelCommand)
//}
//
//enum FileTreeModelCommand {
//	case FileNode(FileNodeModelCommand)
//}
//
//enum FileNodeModelCommand {
//	case InsertSubnode(node: FileNodeModel, subnode: FileNodeModel, index: Int)
//	case DeleteSubnode(node: FileNodeModel, subnode: FileNodeModel, index: Int)
//	case ChangeName(node: FileNodeModel, old: String, new: String)
//}