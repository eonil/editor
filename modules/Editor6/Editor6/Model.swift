//
//  Model.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/10.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import Dispatch
import Flow

/// Thread-safe.
private final class ModelManager {
    static let shared = ModelManager()
    private let gcdq = DispatchQueue(label: "ModelManager")
    private var workspaceModelMappings = [ObjectIdentifier: WorkspaceModel]()
    
    func install(for document: WorkspaceDocument) -> CleanStep<WorkspaceModel> {
        return gcdq.flow(with: ()).step { [weak self] in
            let oid = ObjectIdentifier(document)
            let m = WorkspaceModel()
            self?.workspaceModelMappings[oid] = m
            return m
        }
    }
    func deinstall(for document: WorkspaceDocument) {
        gcdq.async { [weak self] in
            let oid = ObjectIdentifier(document)
            self?.workspaceModelMappings[oid] = nil
        }
    }
}

enum Model {
    private init() {}
}

final class ApplicationModel: Model {
    var workspaces = [WorkspaceModel]()
}
final class WorkspaceModel: Model {
    var issues = [IssueState]()
    var logs = [LogState]()
}

struct IssueState {

}

struct LogState {

}
