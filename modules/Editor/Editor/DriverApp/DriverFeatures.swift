//
//  DriverFeatures.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

final class DriverFeatures: ServicesDependent {
    private let loop = ReactiveLoop()
//    private let cargoWatch = Relay<CargoProcess2.Transaction>()
    private var cargoProc: CargoProcess2?

    init() {
        loop.step = { [weak self] in self?.step() }
//        cargoWatch.delegate = { [weak self] in self?.processCargoTransaction($0) }
    }
//    private func processCargoTransaction(_ tx: CargoProcess2.Transaction) {
//        switch tx {
//        case .
//        }
//    }
    private func step() {
        if let p = cargoProc {
            switch p.state {
            case .running:  break
            case .complete: cargoProc = nil
            }
        }
    }
    func fixWorkspaceDirectoryURL(_ u: URL) -> URL {
        if u.pathExtension == "" {
            return u.appendingPathExtension("eews")
        }
        return u
    }
    func makeWorkspaceDirectory(at u: URL) {
        try! services.fileSystem.createDirectory(at: u,
                                           withIntermediateDirectories: true,
                                           attributes: nil)
        let n = u.deletingPathExtension().lastPathComponent

        // Init Cargo.
        let ps = CargoProcess2.Parameters(
            location: u,
            command: .initialize(.init(
                name: n,
                type: .bin)))
        let p = services.cargo.spawn(ps)
        p.signal += loop
//        p.transaction += cargoWatch
        cargoProc = p

        // Init project file. (`.eews`)
        typealias FileTree = ProjectFeature.FileTree
        typealias FileNode = ProjectFeature.FileNode
        let fs = ProjectFeature.FileTree(node: .root, subtrees: [
            FileTree(node: FileNode(name: "Cargo.toml", kind: .file)),
            FileTree(node: FileNode(name: "src", kind: .folder), subtrees: [
                FileTree(node: FileNode(name: "main.rs", kind: .file)),
                ]),
            ])

        let dto = DTOProjectFile(files: fs)
        let dtou = u.appendingPathComponent(".eews")
        do {
            try dto.write(to: dtou)
        }
        catch let err {
            reportIssue("Could not write a project file to a new workspace at `\(u)` due to error `\(err)`.")
        }
    }

    private func reportIssue(_ message: String) {
        REPORT_recoverableWarning(message)
    }
}
