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

        @inlinable
        var showPlaceholder: Bool {
            switch self {
            case .blocking(let show), .cancellable(let show), .restart(let show):
                return show
            }
        }

        @inlinable
        var isBlocking: Bool {
            guard case .blocking = self else { return false }
            return true
        }
    }
}
