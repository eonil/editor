//
//  BuildFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

final class BuildFeature: ServicesDependent {
    let change = Relay<()>()
    private(set) var production = Product()
    private let loop = ReactiveLoop()
    private let watch = Relay<()>()
    private var project = ProjectFeature.State()
    private var cmdq = [Command]()
    private var exec: CargoProcess2?

    init() {
        watch += loop
        loop.step = { [weak self] in self?.step() }
    }
    private func step() {
        if let exec = exec {
            production.reports.append(contentsOf: exec.production.reports)
            production.issues.append(contentsOf: exec.production.issues)
            exec.clear()
            change.cast(())
        }
        if exec?.state == .complete {
            exec = nil
            change.cast(())
        }

        guard exec == nil else { return } // Wait until done.
        while let cmd = cmdq.removeFirstIfAvailable() {
            switch cmd {
            case .cleanAll:
                guard let loc = project.location else { MARK_unimplemented() }
                let ps = CargoProcess2.Parameters(
                    location: loc,
                    command: .clean)
                exec = services.cargo.spawn(ps)
                change.cast(())

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
                change.cast(())

            case .buildTarget(let t):
                MARK_unimplemented()

            case .cancel:
                MARK_unimplemented()
            }
        }
    }
    func process(_ command: Command) {
        cmdq.append(command)
        loop.signal()
    }

    func setProjectState(_ newProjectState: ProjectFeature.State) {
        project = newProjectState
        loop.signal()
    }
    ///
    /// Clears any production.
    ///
    func clear() {
        production = Product()
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
    typealias Product = CargoProcess2.Product
    typealias Issue = CargoProcess2.Issue
}
