//
//  ProjectItemPathClustering.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/08.
//Copyright © 2017 Eonil. All rights reserved.
//

struct ProjectItemPathClustering {
    ///
    /// Best:   O(n)
    /// Worst:  O(n)
    ///
    /// Sacrifice space to earn time.
    ///
    static func sortLeafToRoot<S>(_ nameps: S) -> AnySequence<IndexPath> where S: Sequence, S.Element == IndexPath {
        var clusters = [[IndexPath]]()
        func ensureClusterCount(_ n: Int) {
            guard n > clusters.count else { return }
            let c = n - clusters.count
            clusters.append(contentsOf: repeatElement([], count: c))
        }
        for namep in nameps {
            ensureClusterCount(namep.count)
            clusters[namep.count].append(namep)
        }
        return AnySequence(clusters.lazy.flatMap({ $0 }))
    }
}
