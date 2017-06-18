//
//  ArrayMutation.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/16.
//  Copyright © 2017 Eonil. All rights reserved.
//

enum ArrayMutation<Element> {
    case insert(Range<Array<Element>.Index>)
    case update(Range<Array<Element>.Index>)
    case delete(Range<Array<Element>.Index>)
}
