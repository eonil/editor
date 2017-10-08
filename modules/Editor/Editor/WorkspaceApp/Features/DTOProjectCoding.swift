//
//  DTOProjectCoding.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/07.
//Copyright © 2017 Eonil. All rights reserved.
//

protocol DTOProjectCoding {
    associatedtype Issue
    static func encode(_: Self) -> String
    static func decode(_: String) -> Result<Self, Issue>
}
