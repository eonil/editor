////
////  LLDBService.swift
////  Editor4
////
////  Created by Hoon H. on 2016/05/15.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Darwin
//import BoltsSwift
////import LLDBWrapper
//
//struct LLDBServiceState {
//
//}
///// LLDB commands.
/////
///// In many cases, executable URL serves as an ID for an LLDB session and process.
/////
//enum LLDBCommand {
//    /// Launches a new debug session for process which runs program at URL.
//    case Launch(NSURL)
//
//    /// Pauses all thread in the process in debugging.
//    case Pause(pid_t)
//
//    /// Launches a new debug session for process which runs program at URL.
//    case Resume(NSURL)
//
//    /// Halts debug session for process that executing program at URL.
//    case Halt(NSURL)
//}
//enum LLDBError: ErrorType {
//
//}
//enum LLDBNotification {
//    case Step(LLDBServiceState)
//}
//
//final class LLDBService {
//    private var sessionIDMapping = ReferencingTable<ADHOC_UndefinedType>()
//
//    /// Dispatches LLDB command.
//    ///
//    /// The command will be executed eventually in dedicated serial queue.
//    ///
//    /// - Note:
//    ///     Can be called from any thread.
//    ///
//    func dispatch(command: LLDBCommand) {
//
//    }
//
//    private func execute(command: LLDBCommand) {
//        MARK_unimplemented()
////        switch command {
////        case .Launch(let u):
////            
////        case .Halt(let u):
////
////        }
//    }
//
//
//
//
//    func launchSessionWithExecutableURL(u: NSURL) -> Task<()> {
//        MARK_unimplemented()
//    }
//    func haltSession(sessionID: ADHOC_UndefinedType) {
//        MARK_unimplemented()
//    }
//    func fetchThreadListOfSession(sessionID: ADHOC_UndefinedType) -> Task<ADHOC_UndefinedType> {
//        MARK_unimplemented()
//    }
//    func fetchCallStackFrameListOfThread(threadID: ADHOC_UndefinedType) -> Task<ADHOC_UndefinedType> {
//        MARK_unimplemented()
//    }
//    func fetchVariableListOfSession(sessionID: ADHOC_UndefinedType) -> Task<ADHOC_UndefinedType> {
//        MARK_unimplemented()
//    }
//    func pauseSession(sessionID: ADHOC_UndefinedType) {
//        MARK_unimplemented()
//    }
//    func resumeSession(sessionID: ADHOC_UndefinedType) {
//        MARK_unimplemented()
//    }
//}
