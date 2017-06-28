//
//  BuildFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

final class BuildFeature: ServiceDependent {
    private let loop = ManualLoop()
    private let watch = Relay<()>()
    private var project = ProjectFeature.State()
    private var cmdq = [Command]()
    private var exec: CargoProcess2?

    override init() {
        super.init()
        loop.step = { [weak self] in self?.step() }
        watch.delegate = { [weak self] in self?.loop.signal() }
    }
    private func step() {
        exec = (exec?.state == .complete) ? nil : exec

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
                let proc = services.cargo.spawn(ps)
                loop.signal()
                proc.signal += watch
                exec = proc

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
