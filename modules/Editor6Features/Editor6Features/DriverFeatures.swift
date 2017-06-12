//
//  DriverFeatures.swift
//  Editor6Features
//
//  Created by Hoon H. on 2017/06/11.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Editor6Services

public final class AppDriverFeatures: DriverFeatures {
    public override weak var services: Services? { didSet {} }
    public override init() {
        super.init()
    }
}

public class DriverFeatures {
    weak var services: Services? {
        didSet {
            (services != nil ? startServices() : endServices())
        }
    }

    private func startServices() {

    }
    private func endServices() {
        
    }
}
