//
//  Subprocess2Controller.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/18.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import EonilToolbox

struct Subprocess2State {
    var phase = Subprocess2Phase.notLaunched
}
enum Subprocess2Command {
    case launch
    /// Writes to subprocess' stdin.
    case stdin(Data)
}
enum Subprocess2Event {
    case stdout(Data)
    case stderr(Data)
    case terminate(exitCode: Int32)
}
enum Subprocess2Phase {
    case notLaunched
    case running
    case terminated
}

final class Subprocess2Controller {
    typealias Delegate = ((Subprocess2Event) -> ())

    private let thchk = ThreadChecker()
    private let proc = Process()
    private var delegate = Delegate?.none
    private(set) var state = Subprocess2State()

    private let stdinPipe = Pipe()
    private let stdoutPipe = Pipe()
    private let stderrPipe = Pipe()

    init(path: String, arguments: [String]) {
        thchk.assertSameThread()
        
        var env = ProcessInfo.processInfo.environment
        //
        // http://stackoverflow.com/a/33844080/246776
        // Sometimes Xcode overrides `DYLD_LIBRARY_PATH` environment
        // variable to a non-system directory
        // (something like "/Users/Eonil/Workshop/Temp/Xcode/Derivations/EditorOnly-hfhkxuguvplpqvdcinldyuivhucp/Build/Products/Debug:/usr/lib/system/introspection")
        // And this environment variable is inherited as is to the NSTask instance because .environment was not set and remained as nil.
        // The cleanest solution would be setting all needed environment variables carefully.
        // I couldn't find a switch to turn off this Xcode behaviour.
        //
        env["DYLD_LIBRARY_PATH"] = nil
//        env["DYLD_FRAMEWORK_PATH"] = nil

        //
        // http://stackoverflow.com/a/42601407/246776
        // Xcode overrides this flag to "1", and it makes `cargo`
        // to fail with this error.
        //
        //     linking with `cc` failed: signal: 10
        //
        // I have no idea of why. Just set it ot "0", and it will
        // work.
        //
        env["MallocNanoZone"] = "0"
        proc.environment = env

        let notify = { [weak self] (_ event: Subprocess2Event) in
            DispatchQueue.main.async {
                self?.delegate?(event)
            }
        }
        let read = { (f: FileHandle) -> (Data) in return f.availableData }
        stdoutPipe.fileHandleForReading.readabilityHandler = { notify(.stdout(read($0))) }
        stderrPipe.fileHandleForReading.readabilityHandler = { notify(.stderr(read($0))) }
        proc.standardInput = stdinPipe
        proc.standardOutput = stdoutPipe
        proc.standardError = stderrPipe
        proc.launchPath = path
        proc.arguments = arguments
        proc.terminationHandler = { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                guard let ss = self else { return }
                ss.notifyTermination()
            }
        }
    }
    deinit {
        thchk.assertSameThread()
        proc.terminate()
        proc.waitUntilExit()
    }
    /// - Parameter newDelegate:
    ///     Will be called from another GCD queue.
    ///
    func delegate(to newDelegate: @escaping Delegate) {
        thchk.assertSameThread()
        delegate = newDelegate
    }
    func queue(_ command: Subprocess2Command) {
        thchk.assertSameThread()
        switch command {
        case .launch:
            proc.launch()
            state.phase = .running
        case .stdin(let data):
            stdinPipe.fileHandleForWriting.write(data)
        }
    }
    private func notifyTermination() {
        thchk.assertSameThread()
        state.phase = .terminated
        let exitCode = proc.terminationStatus
        delegate?(.terminate(exitCode: exitCode))
    }
}

//extension Subprocess2Controller {
//    static func bash() -> Subprocess2Controller {
////        return Subprocess2Controller(path: "/bin/bash", arguments: ["--login", "--posix", "-i", "-s"])
//        return Subprocess2Controller(path: "/bin/bash", arguments: ["--login", "--posix", "-s"])
//    }
//}
