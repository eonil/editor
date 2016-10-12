//
//  Broadcast.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/10.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import EonilToolbox

final class Broadcast<Event> {
    private let gcdq = DispatchQueue(label: "Broadcast")
    private var obsm = [ObserverID: ((Event) -> ())]()
    subscript(_ id: ObserverID) -> ((Event) -> ())? {
        @available(*,unavailable)
        get { reportFatalError("Reading observer back is prohibited.") }
        set { gcdq.async { [weak self] in self?.obsm[id] = newValue } }
    }
    /// Broadcasts action event asynchronously.
    func dispatch(_ action: Event) {
        gcdq.async { [weak self] in self?.process(action) }
    }
    private func process(_ action: Event) {
        // Running on `gcdq`.
        for o in obsm.values {
            o(action)
        }
    }
}

struct ObserverID: Hashable {
    fileprivate let oid = ObjectAddressID()
    var hashValue: Int {
        return oid.hashValue
    }
}

func == (_ a: ObserverID, _ b: ObserverID) -> Bool {
    return a.oid == b.oid
}
