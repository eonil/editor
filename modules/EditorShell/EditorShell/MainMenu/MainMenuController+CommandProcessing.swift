//
//  MainMenuController+CommandProcessing.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/07.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon
import EditorModel



extension MainMenuController {

	/// Observes main-menu command and applies proper mutations
	/// to model and view.
	func process(n: Notification<MenuItemController,()>) {
		assert(model != nil)

		switch ~~n.sender {

//		case ~~fileNewFile: do {
//
//			}
//
//		case ~~fileNewFolder: do {
//
//			}

		case ~~fileCloseCurrentWorkspace: do {
			assert(model!.currentWorkspace != nil, "This menu shouldn't be called if there's no current workspace.")
			model!.closeWorkspace(model!.currentWorkspace!)
			}


		case ~~viewShowProjectNavivator: do {
			UIState.setStateForWorkspaceModel(model!.currentWorkspace!) { (inout state: WorkspaceUIState) -> () in
				state.navigationPaneVisibility	=	true
				state.navigator			=	.Project
			}
		}
		case ~~viewShowDebugNavivator: do {
			UIState.setStateForWorkspaceModel(model!.currentWorkspace!) { (inout state: WorkspaceUIState) -> () in
				state.navigationPaneVisibility	=	true
				state.navigator			=	.Debug
			}
		}
		case ~~viewHideNavigator: do {
			UIState.setStateForWorkspaceModel(model!.currentWorkspace!) { (inout state: WorkspaceUIState) -> () in
				state.navigationPaneVisibility	=	false
			}
		}

		case ~~productRun: do {
			guard let workspace = model!.currentWorkspace else {
				fatalError()
			}
			if let target = workspace.debug.currentTarget {
				target.halt()
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
			model!.currentWorkspace!.build.runBuild()
			}

		case ~~productClean: do {
			model!.currentWorkspace!.build.runClean()
			}

		case ~~productStop: do {
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

