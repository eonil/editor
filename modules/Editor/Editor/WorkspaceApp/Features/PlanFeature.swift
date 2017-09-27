//
//  PlanFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

///
/// Manages execution of long-term sequentially scheduled operations.
///
final class PlanFeature: WorkspaceFeatureComponent {
    private let changes = Relay<()>()
    private(set) var state = State()

    ///
    /// Processes a command and returns workspace commands if needed.
    ///
    func process(_ cmd: Command) -> [WorkspaceCommand] {
        switch cmd {
        case .step:
            return step()
        case .queueTask(let task):
            state.scheduledTasks.append(task)
            return step()
        case .setBuildState(let s):
            state.parameters.buildState = s
            return step()
        }
    }
    private func step() -> [WorkspaceCommand] {
        if state.runningTask == nil {
            state.runningTask = state.scheduledTasks.removeFirstIfAvailable()
            changes.cast(())
        }
        guard let rtask = state.runningTask else { return [] }
        switch rtask {
        case .buildLaunch:
            switch state.parameters.buildState.phase {
            case .idle:
                REPORT_ignoredSignal(rtask)
                return []
            case .running:
                return [.build(.build)]
            }

        case .buildWaitForCompletion:
            switch state.parameters.buildState.phase {
            case .running:
                // Wait more...
                return []
            case .idle:
                return [.plan(.step)]
            }

        case .debugLaunch:
            MARK_unimplemented()

        case .debugWaitForCompletion:
            MARK_unimplemented()

        }
    }
}
extension PlanFeature {
    struct State {
        var runningTask: Task?
        var scheduledTasks = [Task]()
        var parameters = Parameters()
    }
    struct Parameters {
        var buildState = BuildFeature.State()
//        var debugState = DebugFeature.State()
    }
    enum Command {
        case step
        case queueTask(Task)
        case setBuildState(BuildFeature.State)
    }
    enum Task {
        case buildLaunch
        case buildWaitForCompletion
        case debugLaunch
        case debugWaitForCompletion
    }
}
