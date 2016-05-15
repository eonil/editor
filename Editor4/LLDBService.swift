//
//  LLDBService.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import BoltsSwift
//import LLDBWrapper

final class LLDBService {
    private var sessionIDMapping = ReferencingTable<ADHOC_UndefinedType>()

    func launchSessionWithExecutableURL(u: NSURL) -> Task<()> {
        MARK_unimplemented()
    }
    func haltSession(sessionID: ADHOC_UndefinedType) {
        MARK_unimplemented()
    }
    func fetchThreadListOfSession(sessionID: ADHOC_UndefinedType) -> Task<ADHOC_UndefinedType> {
        MARK_unimplemented()
    }
    func fetchCallStackFrameListOfThread(threadID: ADHOC_UndefinedType) -> Task<ADHOC_UndefinedType> {
        MARK_unimplemented()
    }
    func fetchVariableListOfSession(sessionID: ADHOC_UndefinedType) -> Task<ADHOC_UndefinedType> {
        MARK_unimplemented()
    }
    func pauseSession(sessionID: ADHOC_UndefinedType) {
        MARK_unimplemented()
    }
    func resumeSession(sessionID: ADHOC_UndefinedType) {
        MARK_unimplemented()
    }
}
