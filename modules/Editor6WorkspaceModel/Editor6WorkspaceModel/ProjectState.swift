//
//  ProjectState.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

public struct ProjectState: ModelState {
    public typealias Mutation = ProjectMutation
    
    public var items = [ProjectItemID: ProjectItemState]()
    public init() {
        items[ProjectItemID([])] = ProjectItemState(linkage: .group(subitems: []), note: nil)
    }

    public mutating func apply(mutation: ProjectMutation) {
        switch mutation {
        case .items(let itemsMutation):
            items.apply(mutation: itemsMutation)
        }
    }
}

public typealias ProjectItemID = ProjectItemPath

public struct ProjectItemPath: Hashable {
    public var segments = [String]()
    public init(_ segments: [String]) {
        self.segments = segments
    }

    public func appending(last segment: String) -> ProjectItemPath {
        return segmentEdited { segments in
            segments.append(segment)
        }
    }
    private func segmentEdited(_ edit: (inout [String]) -> ()) -> ProjectItemPath {
        var copy = self
        edit(&copy.segments)
        return copy
    }

    public var hashValue: Int {
        return segments.last?.hashValue ?? 0
    }
    public static func == (_ a: ProjectItemPath, _ b: ProjectItemPath) -> Bool {
        return a.segments == b.segments
    }
}

public struct ProjectItemState {
    public var linkage = ProjectItemLinkage.none
    public var note = String?.none
}
public enum ProjectItemLinkage {
    case none
    case group(subitems: [ProjectItemID])
}




