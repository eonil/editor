//
//  CargoService2.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/25.
//  Copyright © 2017 Eonil. All rights reserved.
//

///
/// Provides access to Cargo facility.
///
/// This does not manage execution between Cargo processes.
/// You need to do it if you need it.
///
final class CargoService2 {
    private(set) var runnings = [CargoProcess2]()
    func spawn(_ ps: CargoProcess2.Parameters) -> CargoProcess2 {
        return CargoProcess2(ps)
    }
}
