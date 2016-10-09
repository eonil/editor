////
////  WorkspacePath.swift
////  Editor5FileTreeUI
////
////  Created by Hoon H. on 2016/10/08.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//
//struct WorkspacePath {
//    /// Components.
//    /// Component cannot contain `\` character.
//    var components = [String]() {
//        willSet {
//            let ok = (try? WorkspacePathError.validate(pathComponents: newValue)) != nil
//            precondition(ok)
//        }
//    }
//    init(components: [String]) throws {
//        try WorkspacePathError.validate(pathComponents: components)
//        self.components = components
//    }
//}
//extension WorkspacePath {
//    func dropLastComponent() -> WorkspacePath {
//        let newComps = Array(components.dropLast())
//        return try! WorkspacePath(components: newComps)
//    }
//    func appendingLastComponent(component: String) throws -> WorkspacePath {
//        let newComps = components + [component]
//        return try WorkspacePath(components: newComps)
//    }
//}
//extension WorkspacePath: Equatable, Hashable, CustomStringConvertible {
//    var description: String {
//        return "/" + components.joined(separator: "/")
//    }
//    var hashValue: Int {
//        return components.last?.hashValue ?? 0
//    }
//}
//func == (_ a: WorkspacePath, _ b: WorkspacePath) -> Bool {
//    return a.components == b.components
//}
//
//
//enum WorkspacePathError: Error {
//    case containsBackSlash
//
//    static func validate(pathComponents: [String]) throws {
//        func logicalAnd(_ a: Bool, _ b: Bool) -> Bool { return a && b }
//        let ok = pathComponents
//            .map({ $0.contains("\\") == false })
//            .reduce(true, logicalAnd)
//        guard ok else { throw containsBackSlash }
//    }
//}
