//
//  MainMenuUI2State.swift
//  Editor6MainMenuUI2
//
//  Created by Hoon H. on 2016/11/03.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import EonilToolbox
import Editor6Common

public struct MainMenuUI2State {
    public typealias KeyEquivalentCombination = (keyEquivalentModifierMask: NSEventModifierFlags, keyEquivelent: Character)
    public typealias KeyEquivalentMappings = [MainMenuUI2ItemID: KeyEquivalentCombination]

    public var keyEquivalentMappings = MainMenuKeyMappingUtility.makeDefaultKeyMapping()

    /// Only items in this set will become enabled.
    public var availableItems = [MainMenuUI2ItemID]()

    public init() {}
}
