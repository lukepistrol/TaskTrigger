//
//  TaskTriggerButton+Behavior.swift
//  TaskTrigger
//
//  Created by Lukas Pistrol on 26.11.24.
//

import Foundation

extension TaskTriggerButton {
    /// Describes how the button behaves when tapped and a task is running.
    ///
    /// All can show a separate placeholder while the task is running.
    public enum Behavior {
        /// The button is disabled while the task is running. A placeholder can be shown while the task is running.
        case blocking(showPlaceholder: Bool)

        /// The button can be tapped again to cancel the task. A placeholder can be shown while the task is running.
        case cancellable(showPlaceholder: Bool)

        /// The button can be tapped again to cancel and restart the task. A placeholder can be shown while the task
        /// is running.
        case restart(showPlaceholder: Bool)

        var showPlaceholder: Bool {
            switch self {
            case .blocking(let showPlaceholder):
                return showPlaceholder
            case .cancellable(let showPlaceholder):
                return showPlaceholder
            case .restart(let showPlaceholder):
                return showPlaceholder
            }
        }

        var isBlocking: Bool {
            if case .blocking = self {
                return true
            }
            return false
        }
    }
}
