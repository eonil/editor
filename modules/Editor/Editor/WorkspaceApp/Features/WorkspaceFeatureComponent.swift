//
//  WorkspaceFeatureComponent.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/25.
//Copyright © 2017 Eonil. All rights reserved.
//

protocol WorkspaceFeatureComponent: ServicesDependent {
    associatedtype Command
    func process(_ cmd: Command) -> [WorkspaceCommand]
}

//protocol ADHOC_WorkspaceCommandProcessor {
//    associatedtype Command
//    func process(_ cmd: Command) -> [WorkspaceCommand]
//}

