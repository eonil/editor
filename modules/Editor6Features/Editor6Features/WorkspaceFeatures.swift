//
//  WorkspaceFeatures.swift
//  Editor6Features
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

import EonilToolbox
import Editor6Services

public final class AppWorkspaceFeatures: WorkspaceFeatures {
    public override init() {
        super.init()
    }
}
public class WorkspaceFeatures {
    public let meta = MetaFeature()
    public let fileTree = FileTreeFeature3()
    public let build = BuildFeature()
    public let debug = DebugFeature()

    public weak var services: Services? {
        didSet {
            (services != nil ? startServices() : endServices())
        }
    }

    init() {
    }

    private func startServices() {
        fileTree.services = services
        build.services = services
        debug.services = services
    }
    private func endServices() {
        fileTree.services = nil
        build.services = nil
        debug.services = nil
    }
}
//public extension WorkspaceFeatures {
//    public struct ID: Hashable {
//        private let oid = ObjectAddressID()
//        public init() {}
//        public var hashValue: Int {
//            return oid.hashValue
//        }
//        public static func == (_ a: ID, _ b: ID) -> Bool {
//            return a.oid == b.oid
//        }
//    }
//}
