////
////  Features.swift
////  Editor6Features
////
////  Created by Hoon H. on 2017/06/11.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//import Foundation
//import EonilSignet
//import Editor6Services
//
//public class Features {
//    public let event = Relay<Event>()
//    public private(set) var workspaces = [WorkspaceID: WorkspaceFeatures]()
//    fileprivate weak var services: Services? {
//        didSet {
//            (services != nil ? startServices() : endServices())
//        }
//    }
//
//    func openWorkspace(_ location: URL) {
//        let id = WorkspaceID()
//        let f = WorkspaceFeatures()
//        workspaces[id] = f
//        event.cast(.addWorkspace(id))
//    }
//    func closeWorkspace(_ id: WorkspaceID) {
//        guard workspaces[id] != nil else { return }
//        workspaces[id] = nil
//        event.cast(.removeWorkspace(id))
//    }
//
//    private func startServices() {
//        
//    }
//    private func endServices() {
//
//    }
//}
//public extension Features {
//    public enum Event {
//        case addWorkspace(WorkspaceID)
//        case removeWorkspace(WorkspaceID)
//    }
//}
//public extension Features {
//    public static func make(services: Services) -> Features {
//        let f = Features()
//        f.services = services
//        return f
//    }
//}
