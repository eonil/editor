//
//  Features.swift
//  Editor6Features
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Editor6Services

public final class AppFeatures: Features {
    public override weak var services: Services? { didSet {} }
    public override init() {
        super.init()
    }
}

public class Features {
    public let fileTree = FileTreeFeature2()
    public let build = BuildFeature()
    weak var services: Services? {
        didSet {
            fileTree.services = services
            build.services = services
        }
    }

    init() {
    }
}
