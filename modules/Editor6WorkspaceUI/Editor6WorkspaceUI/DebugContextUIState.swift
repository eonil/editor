////
////  DebugContextUIState.swift
////  Editor6WorkspaceUI
////
////  Created by Hoon H. on 2016/10/16.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import Editor6Common
//
//public struct DebugContextUIState {
//    public var processes = [(id: DebugContextUIProcessID, state: DebugContextUIProcessState)]()
//    public var variables = [Tree<DebugContextUIVariableState>]()
//    public init() {}
//}
//
//public typealias DebugContextUIProcessID = pid_t
//public struct DebugContextUIProcessState {
//    public var threads = [(id: DebugContextUIThreadID, state: DebugContextUIThreadState)]()
//    public init() {}
//}
//
//public typealias DebugContextUIThreadID = thread_t
//public struct DebugContextUIThreadState {
//    public var frames = [DebugContextUIThreadFrameState]()
//    public init() {}
//}
//
//public struct DebugContextUIThreadFrameState {
//    public var number: Int
//    public var name: String
//    public init(number: Int, name: String) {
//        self.number = number
//        self.name = name
//    }
//}
//
//public struct DebugContextUIVariableState {
//    public var name = String?.none
//    public var expression = String?.none
//}
