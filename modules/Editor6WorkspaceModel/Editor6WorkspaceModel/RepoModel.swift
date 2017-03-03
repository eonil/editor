//
//  RepoModel.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/04.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

public typealias RepoState = WorkspaceState

public enum RepoCommand {
    case product(RepoProductCommand)
}
public enum RepoFileCommand {
    case addNewFile
    case addNewFolder
    case deleteFile
}
public enum RepoProductCommand {
    case clean
    case build
    case run
}
public enum RepoEvent {
    case changeState
}

public final class RepoModel {
    private let cargo = CargoModel()

    private(set) var state = RepoState()
    private var delegate = ((CargoEvent) -> ())?.none

    init() {
        cargo.delegate { [weak self] in self?.process(cargoEvent: $0) }
    }
    deinit {
    }

    private func process(cargoEvent e: CargoEvent) {
        switch e {
        case .phase:
            break
        case .issue(let i):
            break
        case .error(let e):
            break
        }
    }
}
