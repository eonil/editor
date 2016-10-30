//
//  DebugState.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/21.
//  Copyright © 2016 Eonil. All rights reserved.
//

import EonilToolbox
import LLDBWrapper

public struct DebugState: ModelState {
    public typealias Mutation = DebugMutation
    public var targets = [DebugTargetID: DebugTargetState]()
    public var processes = [DebugProcessID: DebugProcessState]()
    public var variables = [DebugVariable]()
    public mutating func apply(mutation: DebugMutation) {
        switch mutation {
        case .none:
            break
        case .all(let newState):
            self = newState
        case .targets(let newTargets):
            targets = newTargets
        case .processes(let newProcesses):
            processes = newProcesses
        case .variables(let newVariables):
            variables = newVariables
        }
    }
}

public typealias DebugTarget = (id: DebugTargetID, state: DebugTargetState)
public struct DebugTargetID: Hashable {
    private let oid = ObjectAddressID()
    public var hashValue: Int {
        return oid.hashValue
    }
    public static func == (_ a: DebugTargetID, _ b: DebugTargetID) -> Bool {
        return a.oid == b.oid
    }
}
public struct DebugTargetState {
    /// A running process of this target if exists.
    public var processID = DebugProcessID?.none
}
public typealias DebugProcess = (id: DebugProcessID, state: DebugProcessState)
/// NOSHIP: TODO: Need more uniqueness over time axis...
public struct DebugProcessID: Hashable {
    let ownerTargetID: DebugTargetID
    let rawValue: LLDBProcessIDType
    public var hashValue: Int {
        return rawValue.hashValue
    }
    public static func == (_ a: DebugProcessID, _ b: DebugProcessID) -> Bool {
        return a.rawValue == b.rawValue && a.ownerTargetID == b.ownerTargetID
    }
}
public struct DebugProcessState {
    public var threads = [DebugThread]()
//    public var variables = [DebugVariable]()
}
public typealias DebugThread = (id: DebugThreadID, state: DebugThreadState)
public struct DebugThreadID {
    internal let rawValue: LLDBThreadIDType
}
public struct DebugThreadState {
    public var frames = [DebugFrame]()
}
public typealias DebugFrame = (id: DebugFrameID, state: DebugFrameState)
public typealias DebugFrameID = UInt32
public struct DebugFrameState {
    public var functionName = String?.none
}

public struct DebugVariable {
    public var name: String
    public var value: Any
    public var expression: String
}
