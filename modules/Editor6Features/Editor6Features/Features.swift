//
//  Features.swift
//  Editor6Features
//
//  Created by Hoon H. on 2017/06/11.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Editor6Services
import EonilSignet

public final class AppFeatures: Features {
    public override weak var services: Services? { didSet {} }
    public override init() {
        super.init()
    }
}

///
/// Provides workspace management.
///
public class Features {
    public let event = Relay<Event>()
    public private(set) var state = State()
    weak var services: Services? {
        didSet {
            (services != nil ? startServices() : endServices())
        }
    }

    private func startServices() {
        
    }
    private func endServices() {
        
    }

    public func process(_ command: Command) {
        switch command {
        case .makeWorkspace:
            makeWorkspace()
        case .openWorkspace(let location):
            openWorkspace(location)
        case .closeWorkspace(let workspaceID):
            closeWorkspace(workspaceID)
        }
    }
    func makeWorkspace() {
        let id = WorkspaceID()
        let fs = WorkspaceFeatures()
        state.workspaces[id] = fs
        event.cast(.addWorkspace(id))
    }
    func openWorkspace(_ location: URL) {
        let id = WorkspaceID()
        let fs = WorkspaceFeatures()
        state.workspaces[id] = fs
        event.cast(.addWorkspace(id))
    }
    func closeWorkspace(_ id: WorkspaceID) {
        guard state.workspaces[id] != nil else { return }
        state.workspaces[id] = nil
        event.cast(.removeWorkspace(id))
    }
    ///
    /// Set current workspace.
    /// This is required to manage main menu state.
    ///
    func setCurrentWorkspace(_ newCurrentWorkspace: WorkspaceID) {
        state.currentWorkspaceID = newCurrentWorkspace
        event.cast(.changeCurrentWorkspace)
    }
    ///
    /// Set current workspace.
    /// This is required to manage main menu state.
    ///
    func deselectWorkspace() {
        state.currentWorkspaceID = nil
        event.cast(.changeCurrentWorkspace)
    }
}
public extension Features {
    public struct State {
        public var workspaces = [WorkspaceID: WorkspaceFeatures]()
        public var currentWorkspaceID: WorkspaceID?
    }
    public enum Command {
        case makeWorkspace
        case openWorkspace(location: URL)
        case closeWorkspace(WorkspaceID)
    }
    public enum Event {
        case addWorkspace(WorkspaceID)
        case removeWorkspace(WorkspaceID)
        case changeCurrentWorkspace
    }
}
