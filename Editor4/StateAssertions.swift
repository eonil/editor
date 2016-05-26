//
//  StateAssertions.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/26.
//  Copyright © 2016 Eonil. All rights reserved.
//

extension State {
    func assertConsistency() {
        assert(assertConsistencyImpl(), "Inconsistent state.")
    }
    private func assertConsistencyImpl() -> Bool {
        for (_, workspaceState) in workspaces {
            let allFileIDs = workspaceState.files.map({ $0.0 })
            let uniqueFileIDs = Set(allFileIDs)
            assert(allFileIDs.count == uniqueFileIDs.count)
            let a = Array(workspaceState.files).map({ $0.0 })
            if let currentFileID = workspaceState.window.navigatorPane.file.selection.current {
                assert(a.contains(currentFileID) == true)
            }
            assert(workspaceState.window.navigatorPane.file.selection.items.version == workspaceState.window.navigatorPane.file.selection.items.accessibleVersion)
            for selectedFileID in workspaceState.window.navigatorPane.file.selection.items {
                let a = Array(workspaceState.files).map({ $0.0 })
                assert(a.contains(selectedFileID) == true)
            }

            /// Top-down link tests.
            for (fileID, fileState) in workspaceState.files {
                for subfileID in fileState.subfileIDs {
                    assert(workspaceState.files[subfileID].superfileID != nil, "A subfile `\(subfileID)` does not have link to superfile `\(fileID)`, but reverse does exist.")
                    assert(workspaceState.files[subfileID].superfileID == fileID, "A subfile `\(subfileID)` link to suprfile is wrong. It must be `\(fileID)`, but it is now `\(workspaceState.files[subfileID].superfileID)`.")
                }
                guard let superfileID = workspaceState.files[fileID].superfileID else { continue }
                assert(workspaceState.files[superfileID].subfileIDs.contains(fileID), "A superfile `\(superfileID)` does not contain subfile `\(fileID)`, but reverse does exist.")
            }
            /// Bottom-up link tests.
            for (fileID, _) in workspaceState.files {
                guard let superfileID = workspaceState.files[fileID].superfileID else { continue }
                assert(workspaceState.files[superfileID].subfileIDs.contains(fileID), "A superfile `\(superfileID)` does not contain subfile `\(fileID)`.")
            }
        }
        return true
    }
}


