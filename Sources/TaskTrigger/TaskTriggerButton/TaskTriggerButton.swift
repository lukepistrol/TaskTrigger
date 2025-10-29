//
//  TaskTriggerButton.swift
//  TaskTrigger
//
//  Created by Lukas Pistrol on 26.11.24.
//

import SwiftUI

/// A `Button` that triggers an async task that is bound to the button using a ``TaskTrigger``.
///
/// > To get a better understanding of how a ``TaskTrigger`` works and its use cases, please refer to the
/// > documentation of the ``TaskTrigger`` package.
///
/// When the button is tapped the action is performed. Depending on the ``TaskTriggerButton/Behavior`` the button
/// behaves differently:
///
/// - `.blocking`:
/// The button is disabled while the task is running.
/// A placeholder can be shown while the task is running.
/// - `.cancellable`:
/// The button can be tapped again to cancel the task.
/// A placeholder can be shown while the task is running.
/// - `.restart`:
/// The button can be tapped again to cancel and restart
/// the task. A placeholder can be shown while the task is running.
///
/// ```swift
/// // ⛔ Bad:
/// // Task will not be cancelled when the button is
/// // removed from the view hierarchy or is tapped
/// // multiple times.
/// Button("Start Task") {
///   Task {
///     await someAsyncTask()
///   }
/// }
///
/// // ✅ Good:
/// TaskTriggerButton("Start Task") {
///   await someAsyncTask()
/// }
/// ```
///
/// The default behavior is `.blocking` with a `ProgressView` as a placeholder. In all cases the task is bound to
/// the ``TaskTriggerButton`` and will be cancelled as soon as the ``TaskTriggerButton`` is removed from the view
/// hierarchy.
public struct TaskTriggerButton<L: View, P: View>: View {

    let action: @Sendable @MainActor () async -> Void
    let label: () -> L
    let placeholder: () -> P
    let role: ButtonRole?
    let behavior: Behavior

    /// Creates a new ``TaskTriggerButton`` with a label.
    /// - Parameters:
    ///   - role: The button's role. Defaults to `nil`.
    ///   - behavior: The button's behavior. Defaults to `.blocking(showPlaceholder: true)`.
    ///   - action: The async action to perform when the button is tapped.
    ///   - label: The button's label. This can be any `View`.
    ///   - placeholder: The placeholder to show while the task is running. Defaults to a `ProgressView`.
    ///   If `showPlaceholder` on the `role` is set to `false`, this is ignored.
    public init(
        role: ButtonRole? = nil,
        behavior: Behavior = .blocking(showPlaceholder: true),
        action: @escaping @Sendable @MainActor () async -> Void,
        @ViewBuilder label: @escaping () -> L,
        @ViewBuilder placeholder: @escaping () -> P = { ProgressView() }
    ) {
        self.action = action
        self.label = label
        self.placeholder = placeholder
        self.role = role
        self.behavior = behavior
    }

    @State private var trigger = PlainTaskTrigger()

    public var body: some View {
        let isActive = trigger.state != .none
        
        Button(role: role) {
            if isActive {
                handleActiveState()
            } else {
                trigger.trigger()
            }
        } label: {
            if isActive && behavior.showPlaceholder {
                placeholder()
            } else {
                label()
            }
        }
        .disabled(behavior.isBlocking && isActive)
        .task($trigger, action)
    }
    
    /// Handles button action when a task is already active.
    private func handleActiveState() {
        switch behavior {
        case .cancellable:
            trigger.cancel()
        case .restart:
            trigger.trigger()
        case .blocking:
            break
        }
    }
}
