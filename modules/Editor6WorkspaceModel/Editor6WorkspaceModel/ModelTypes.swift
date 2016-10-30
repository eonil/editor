//
//  ModelTypes.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/29.
//  Copyright © 2016 Eonil. All rights reserved.
//

public typealias ModelContinuation = () -> ()
typealias ModelDelegate<Notification> = (notification: Notification, continuation: ModelContinuation)

public protocol ModelState {
    associatedtype Mutation
    mutating func apply(mutation: Mutation)
}

public struct ModelTransaction<State: ModelState> {
    public var from: State
    public var to: State
    public var by: [State.Mutation]
}

