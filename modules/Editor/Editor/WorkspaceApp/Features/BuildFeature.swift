//
//  BuildFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

final class BuildFeature: ServiceDependent {
    private let loop = ManualLoop()
    private var project = ProjectFeature.State()
    private var cmdq = [Command]()
    private var exec: CargoProcess2?

    override init() {
        super.init()
        loop.step = { [weak self] in self?.step() }
    }
    private func step() {
        guard exec == nil else { return } // Wait until done.
        while let cmd = cmdq.removeFirstIfAvailable() {
            switch cmd {
            case .cleanAll:
                guard let loc = project.location else { MARK_unimplemented() }
                let ps = CargoProcess2.Parameters(
                    location: loc,
                    command: .clean)
                exec = services.cargo.spawn(ps)

            case .cleanTarget(let t):
                MARK_unimplemented()

            case .build:
                guard let loc = project.location else { MARK_unimplemented() }
                let ps = CargoProcess2.Parameters(
                    location: loc,
                    command: .build)
                exec = services.cargo.spawn(ps)

            case .buildTarget(let t):
                MARK_unimplemented()

            case .cancel:
                MARK_unimplemented()
            }
        }
    }



    func setProjectState(_ newProjectState: ProjectFeature.State) {
        project = newProjectState
        loop.signal()
    }


    func process(_ command: Command) {
        cmdq.append(command)
        loop.signal()
    }
}
extension BuildFeature {
    enum Command {
        case build
        case buildTarget(Target)
        case cleanAll
        case cleanTarget(Target)
        case cancel
    }
}
