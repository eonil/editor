//
//  MainMenu2State.swift
//  Editor
//
//  Created by Hoon H. on 2016/11/03.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox

public struct MainMenu2State {
    public typealias KeyEquivalentCombination = (keyEquivalentModifierMask: NSEvent.ModifierFlags, keyEquivelent: Character)
    public typealias KeyEquivalentMappings = [MainMenuItemID: KeyEquivalentCombination]

    public var keyEquivalentMappings = MainMenuKeyMappingUtility.makeDefaultKeyMapping()

    /// Only items in this set will become enabled.
    public var availableItems = Set<MainMenuItemID>()

    public init() {}
}
