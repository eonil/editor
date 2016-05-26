//
//  Toolset.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/14.
//  Copyright © 2016 Eonil. All rights reserved.
//

import BoltsSwift

typealias ADHOC_UndefinedType = ()

struct Toolset {
    let racer = RacerService()
    let cargo = CargoService()
    let lldb = LLDBService()
}








final class RacerService {
    private init() {
    }
    func queryCandidatesAt(fileURL: NSURL, line: Int, column: Int) -> Task<ADHOC_UndefinedType> {
        MARK_unimplemented()
    }
    func cancelQuery() {
    }
}




//final class TTYService {
//    func launchTTY() ->
//}
//final class TTYSession {
//
//}







