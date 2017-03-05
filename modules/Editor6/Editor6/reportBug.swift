//
//  reportBug.swift
//  Editor6
//
//  Created by Hoon H. on 2017/03/05.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import Editor6Common

///
/// You got a bug situation, which is unlike to happen,
/// but actually happen in reality. You can recover and
/// continue program execution with no problem, but
/// still, you want to know what happen.
///
/// Call this function when you need such report.
///
func reportBugAndContinue(_ bug: PotentialBug) {
    MARK_unimplemented()
}

enum PotentialBug {
    case defaultNewDocumentIsNotRepoDocument
    case mainMenuClickedWithNoCurrentRepoDocument
    case missingCurrentRepoDocumentForRequiredContext
    case badRepoNameWhichHasNoVisibleNamePart
}
