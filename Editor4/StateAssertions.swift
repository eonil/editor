//
//  StateAssertions.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/26.
//  Copyright © 2016 Eonil. All rights reserved.
//

extension State {
    func assertConsistency() {
        runOnlyInUnoptimizedBuild {
            for (_, workspaceState) in workspaces {
                workspaceState.assertConsistency()
            }
        }
    }
}

private extension WorkspaceState {
    private func assertConsistency() {
        runOnlyInUnoptimizedBuild {
            assert(location == nil || location!.fileURL)
            let allFileIDs = files.map({ $0.0 })
            let uniqueFileIDs = Set(allFileIDs)
            assert(allFileIDs.count == uniqueFileIDs.count)
            let a = Array(files).map({ $0.0 })
            if let currentFileID = window.navigatorPane.file.selection.current {
                assert(a.contains(currentFileID) == true)
            }
            assert(window.navigatorPane.file.selection.items.version == window.navigatorPane.file.selection.items.accessibleVersion)
            for selectedFileID in window.navigatorPane.file.selection.items {
                let a = Array(files).map({ $0.0 })
                assert(a.contains(selectedFileID) == true)
            }
            files.assertConsistency()
        }
    }
}
private extension FileTree2 {
    private func assertConsistency() {
        runOnlyInUnoptimizedBuild {
            /// Top-down link tests.
            for (fileID, fileState) in self {
                for subfileID in fileState.subfileIDs {
                    assert(self[subfileID].superfileID != nil, "A subfile `\(subfileID)` does not have link to superfile `\(fileID)`, but reverse does exist.")
                    assert(self[subfileID].superfileID == fileID, "A subfile `\(subfileID)` link to suprfile is wrong. It must be `\(fileID)`, but it is now `\(self[subfileID].superfileID)`.")
                }
                guard let superfileID = self[fileID].superfileID else { continue }
                assert(self[superfileID].subfileIDs.contains(fileID), "A superfile `\(superfileID)` does not contain subfile `\(fileID)`, but reverse does exist.")
            }
            /// Bottom-up link tests.
            for (fileID, _) in self {
                guard let superfileID = self[fileID].superfileID else { continue }
                assert(self[superfileID].subfileIDs.contains(fileID), "A superfile `\(superfileID)` does not contain subfile `\(fileID)`.")
            }
        }
    }
}

private func runOnlyInUnoptimizedBuild(@noescape f: ()->()) {
    assert({
        f()
        return true
    }())
}