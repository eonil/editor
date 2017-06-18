//
//  MainMenuUI2ItemID.swift
//  Editor6MainMenuUI2
//
//  Created by Hoon H. on 2016/11/03.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

/// ID for some of main menu items.
///
/// This is "item" ID, not "action" ID.
/// Because this does not
/// describe what happen *in* main menu.
///
/// Though most of them do, but not every
/// main menu items have item ID.
/// Only some which need sending of click-
/// action have item ID to make receivers
/// can identify which has been clicked.
///
public enum MainMenuUI2ItemID {
    case applicationQuit
    case fileNewWorkspace
    case fileNewFile
    case fileOpen
    case fileSave
    case fileSaveAs
    case fileClose
    case fileCloseRepo
    case productClean
    case productBuild
    case productRun
    case productStop
    case debugPause
    case debugResume
    case debugStepOver
    case debugStepInto
    case debugStepOut
}

