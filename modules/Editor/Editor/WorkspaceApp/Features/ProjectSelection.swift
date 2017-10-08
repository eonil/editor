//
//  ProjectSelection.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/24.
//  Copyright © 2017 Eonil. All rights reserved.
//

import EonilStateSeries

//extension StateSeriesType where Snapshot == ProjectFeature.FileTree {
//    func makeSelection<S>(with idxps: S) -> ProjectSelection where S: Sequence, S.Element == IndexPath {
//
//    }
//}
extension ProjectFeature {
    func makeSelection<S>(with idxps: S) -> ProjectSelection where S: Sequence, S.Element == IndexPath {
        guard let point = series.points.last else { return ProjectSelection() }
        return ProjectSelection(point: point, items: idxps)
    }
}
struct ProjectSelection: Sequence {
    ///
    /// Designates valid time-point of project state for captured index-paths.
    /// If capturing time-point is out of current project-feature state,
    /// project-feature can reject requested operation.
    ///
    private typealias Point = ProjectFeature.Series.Point
    private typealias Items = AnySequence<IndexPath>
    private enum Content {
        case none
        indirect case some(Point, Items)
    }
    private var content = Content.none

    init() {
    }
    init<S>(point: ProjectFeature.Series.Point, items: S) where S: Sequence, S.Element == IndexPath {
        content = .some(point, AnySequence { items.makeIterator() })
    }
    init(point: ProjectFeature.Series.Point, outlineSelection: TreeOutlineAdapter2<ProjectFeature.FileNode>.Selection) {
        content = .some(point, AnySequence(outlineSelection))
    }
    ///
    /// - Returns:
    ///     Whether this selection can be used for snapshot at the time-point.
    ///
    func isValid(for timepoint: ProjectFeature.Series.PointID) -> Bool {
        switch content {
        case .none:                 return false
        case .some(let point, _):   return point.id == timepoint
        }
    }
    ///
    /// - Returns:
    ///     Whether this selection can be used for current state of project-feature.
    ///
    func isValid(for project: ProjectFeature) -> Bool {
        guard let latest = project.series.points.last else { return false }
        return isValid(for: latest.id)
    }
    func makeIterator() -> AnyIterator<IndexPath> {
        switch content {
        case .none:
            return AnyIterator([].makeIterator())
        case .some(_, let items):
            return items.makeIterator()
        }
    }

//    func makeIterator() -> AnyIterator<ProjectItemPath> {
//        switch content {
//        case .none:
//            return AnyIterator([].makeIterator())
//        case .some(let point, let items):
//            let idxps = items.makeIterator()
//            return AnyIterator {
//                guard let idxp = idxps.next() else { return nil }
//                let namep = point.state.files.namePath(at: idxp)
//                return namep
//            }
//        }
//    }
}
