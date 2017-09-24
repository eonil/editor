//
//  FeatureDependent.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

protocol WorkspaceFeatureDependent: class {
    weak var features: WorkspaceFeatures? { get set }
}
