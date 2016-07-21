//
//  MainMenuController+CommandProcessing.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/07.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon
import EditorModel
import EditorUICommon



extension MainMenuController {
	/// Observes main-menu command and applies proper mutations
	/// to model and view.
	func process(n: Notification<MenuItemController,()>) {
		assert(model != nil)

		switch ~~n.sender {

		case ~~fileNewWorkspace: do {
			Dialogue.runSavingWorkspace { [weak self] in
				guard self != nil else {
					return
				}
				if let u = $0 {
					try! self!.model!.createAndOpenWorkspaceAtURL(u)
				}
			}
			}

		case ~~fileNewFile: do {
			if let workspace = model!.currentWorkspace {
				if let node = MainMenuController.hostFileNodeForNewFileSubentryOperationInFileTree(workspace.file) {
					try! model!.currentWorkspace?.file.newFileInNode(node, atIndex: 0)
				}
			}
			}

		case ~~fileNewFolder: do {
			if let workspace = model!.currentWorkspace {
				if let node = MainMenuController.hostFileNodeForNewFileSubentryOperationInFileTree(workspace.file) {
					try! model!.currentWorkspace?.file.newFolderInNode(node, atIndex: 0)
				}
			}
			}

		case ~~fileDelete: do {
			assertAndReportFailure(model!.currentWorkspace != nil)
			if let workspace = model!.currentWorkspace {
				try! workspace.file.deleteNodes(workspace.file.projectUIState.sustainingFileSelection)
			}
			}

		case ~~fileOpenWorkspace: do {
			Dialogue.runOpeningWorkspace() { [weak self] in
				guard self != nil else {
					return
				}
				if let u = $0 {
					self!.model!.openWorkspaceAtURL(u)
				}
			}
			}

		case ~~fileCloseCurrentWorkspace: do {
			assert(model!.currentWorkspace != nil, "This menu shouldn't be called if there's no current workspace.")
			let	workspace	=	model!.currentWorkspace!
			model!.closeWorkspace(workspace)
			}


		case ~~viewEditor: do {
			model!.currentWorkspace!.overallUIState.paneSelection			=	.Editor
		}
		case ~~viewShowProjectNavivator: do {
			model!.currentWorkspace!.overallUIState.mutate {
				$0.navigationPaneVisibility	=	true
				$0.paneSelection		=	WorkspaceUIState.Pane.Navigation(.Project)
			}
		}
		case ~~viewShowIssueNavivator: do {
			model!.currentWorkspace!.overallUIState.mutate {
				$0.navigationPaneVisibility	=	true
				$0.paneSelection		=	WorkspaceUIState.Pane.Navigation(.Issue)
			}
		}
		case ~~viewShowDebugNavivator: do {
			model!.currentWorkspace!.overallUIState.mutate {
				$0.navigationPaneVisibility	=	true
				$0.paneSelection		=	WorkspaceUIState.Pane.Navigation(.Debug)
			}
		}
		case ~~viewHideNavigator: do {
			model!.currentWorkspace!.overallUIState.mutate {
				$0.navigationPaneVisibility	=	false
				()
			}
		}
		case ~~viewConsole: do {
			model!.currentWorkspace!.overallUIState.mutate {
				$0.consolePaneVisibility	=	true
				()
			}
		}
		case ~~viewFullscreen: do {
			NSApplication.sharedApplication().mainWindow?.toggleFullScreen(self)
			}

		case ~~productRun: do {
			assert(model!.currentWorkspace!.build.busy == false)
			guard let workspace = model!.currentWorkspace else {
				fatalError()
			}
			if let target = workspace.debug.currentTarget {
				if target.execution != nil {
					target.halt()
				}
				workspace.debug.deselectTarget(target)
			}
			if workspace.debug.targets.count == 0 {
				markUnimplemented("We need to query `Cargo.toml` file to get proper executable location.")
				if let u = workspace.location {
					let	n	=	u.lastPathComponent!
					let	u1	=	u.URLByAppendingPathComponent("target").URLByAppendingPathComponent("debug").URLByAppendingPathComponent(n)
					workspace.debug.createTargetForExecutableAtURL(u1)
				}
			}

			workspace.debug.selectTarget(workspace.debug.targets.first!)
			workspace.debug.currentTarget!.launch(NSURL(fileURLWithPath: "."))
			}

		case ~~productBuild: do {
			assert(model!.currentWorkspace!.build.busy == false)
			model!.currentWorkspace!.build.runBuild()
			}

		case ~~productClean: do {
			assert(model!.currentWorkspace!.build.busy == false)
			model!.currentWorkspace!.build.runClean()
			}

		case ~~productStop: do {
			assert(model!.currentWorkspace!.build.busy == false)
			model!.currentWorkspace!.debug.currentTarget!.halt()
			model!.currentWorkspace!.build.stop()
			}



		case ~~debugPause: do {
			model!.currentWorkspace!.debug.currentTarget!.execution!.runCommand(.Pause)
			}

		case ~~debugResume: do {
			model!.currentWorkspace!.debug.currentTarget!.execution!.runCommand(.Resume)
			}

		case ~~debugHalt: do {
			model!.currentWorkspace!.debug.currentTarget!.execution!.runCommand(.Halt)
			}

		case ~~debugStepInto: do {
			model!.currentWorkspace!.debug.currentTarget!.execution!.runCommand(.StepInto)
			}

		case ~~debugStepOut: do {
			model!.currentWorkspace!.debug.currentTarget!.execution!.runCommand(.StepOut)
			}

		case ~~debugStepOver: do {
			model!.currentWorkspace!.debug.currentTarget!.execution!.runCommand(.StepOver)
			}
			
		case ~~debugClearConsole: do {
			model!.currentWorkspace!.console.clear()
			}

                case ~~DEV_test1: do {

                        }

		default:
			fatalError("A menu command `\(n.sender)` has not been implemented.")
		}
	}
}



















prefix operator ~~ {

}
private prefix func ~~(a: MenuItemController) -> ReferentialIdentity<MenuItemController> {
	return	identityOf(a)
}

