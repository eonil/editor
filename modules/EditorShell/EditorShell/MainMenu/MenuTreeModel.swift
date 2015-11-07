//
//  MenuTreeModel.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/07.
//  Copyright © 2015 Eonil. All rights reserved.
//

import AppKit
import EditorModel


//
//enum MenuSection {
//	case Static([MenuItem])
//	case Dynamic(()->[MenuItem])
//}
//
//protocol DynamicMenuSection {
//	var onInvalidate: (()->())? { get set }
//	var items: [MenuItem] { get }
//}
//
//enum MenuItem {
//	case Separator
//	case Command(String, MenuCommand)
//	indirect case Submenu(String, [MenuSection])
//	case Custom(NSMenuItem)
//
//	func nodesForCommand(command: MenuCommand) -> [MenuSection] {
//		switch self {
//		case .Command(let parameters):
//			if parameters.1 == command {
//				return	[self]
//			}
//			return	[]
//
//		case .Submenu(let parameters):
//			return	parameters.1.map({$0.nodesForCommand(command)}).reduce([], combine: +)
//
//		default:
//			return	[]
//		}
//	}
//}
//
//struct MainMenu2 {
////	let	newFile		=	MenuNodeMode.Command(title: "File...", command: MenuCommand.File(.NewFile))
////	let	newFolder	=	MenuNodeMode.Command(title: "File...", command: MenuCommand.File(.NewFile))
////	let	closeWorkspace	=	MenuNodeMode.Command(title: "Close Workspace", command: MenuCommand.File(.NewFile))
//}
//
//let	fileMenu	=	MenuNodeModel.Submenu("File", [
//	.Submenu("New", [
//		.Command("File...", MenuCommand.NewSubfileInCurrentFolderItemInCurrentWorkspace),
//		.Command("Folder...", MenuCommand.NewSubfolderInCurrentFolderItemInCurrentWorkspace),
//		]),
//	.Command("Close Workspace", .CloseCurrentWorkspace),
//	])
//
//
//
//let fileMenu: [MenuNodeModel] = [
//	.Submenu("File", [
//		.Submenu("New", [
//			.Command("File...", MenuCommand.NewSubfileInCurrentFolderItemInCurrentWorkspace),
//			.Command("Folder...", MenuCommand.NewSubfolderInCurrentFolderItemInCurrentWorkspace),
//			]),
//		]),
//		.Command("Close Workspace", .CloseCurrentWorkspace),
//
//	.Submenu("Debug", [
//		.Command("Pause", .DebugPause),
//		.Command("Resume", .DebugResume),
//		.Command("Halt", .DebugHalt),
//		.Separator,
//		.Command("Step Into", .DebugStepInto),
//		.Command("Step Out", .DebugStepOut),
//		.Command("Step Over", .DebugStepOver),
//		]),
//]
//
//
//

















