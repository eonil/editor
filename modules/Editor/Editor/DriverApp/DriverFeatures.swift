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
        var fs = ProjectFeature.FileTree()
        let rtidx = ProjectFeature.FileTree.IndexPath.root
        let rtpath = ProjectItemPath.root
        func idx(_ comps: [Int]) -> ProjectFeature.FileTree.IndexPath {
            return ProjectFeature.FileTree.IndexPath(components: comps)
        }
        func path(_ comps: [String]) -> ProjectItemPath {
            return ProjectItemPath(components: comps)
        }
        fs.insert(at: idx([]),      (path([]), .folder))
        fs.insert(at: idx([0]),     (path(["Cargo.toml"]), .file))
        fs.insert(at: idx([1]),     (path(["src"]), .folder))
        fs.insert(at: idx([1,0]),   (path(["src", "main.rs"]), .file))

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
