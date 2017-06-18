//
//  BuildFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

final class BuildFeature {
    weak var services: WorkspaceServices?
    func process(_ command: Command) {
        REPORT_unimplementedAndContinue()
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
