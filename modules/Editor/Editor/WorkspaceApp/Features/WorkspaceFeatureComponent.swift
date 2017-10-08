//
//  WorkspaceFeatureComponent.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/25.
//Copyright © 2017 Eonil. All rights reserved.
//

protocol WorkspaceFeatureComponent: ServicesDependent {
    associatedtype Command
    associatedtype Production
    associatedtype Issue
    func process(_ cmd: Command) -> Result<Production, Issue>
}

//protocol ADHOC_WorkspaceCommandProcessor {
//    associatedtype Command
//    func process(_ cmd: Command) -> [WorkspaceCommand]
//}

