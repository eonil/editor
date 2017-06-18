//
//  RationalInt.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/16.
//  Copyright © 2017 Eonil. All rights reserved.
//

struct RationalInt {
    var numerator: Int
    var denominator: Int

    init(_ initialNumerator: Int, _ initialDenominator: Int = 1000) {
        numerator = initialNumerator
        denominator = initialDenominator
    }
    func toFloat32() -> Float32 {
        return Float32(numerator) / Float32(denominator)
    }
}
func / (_ numerator: Int, denominator: Int) -> RationalInt {
    return RationalInt(numerator, denominator)
}
