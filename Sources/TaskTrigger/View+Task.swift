//
//  File.swift
//  
//
//  Created by Lukas Pistrol on 16.09.23.
//

import SwiftUI

public extension View {
    /// Adds a task to perform whenever the specified trigger with an attached value fires.
    /// - Parameters:
    ///   - trigger: A binding to a ``TaskTrigger/TaskTrigger``.
    ///   - action: An async action to perform whenever the trigger fires. The attached value
    ///   is passed into the closure as an argument.
    func task<Value: Equatable>(
        _ trigger: Binding<TaskTrigger<Value>>,
        _ action: @escaping @Sendable @MainActor (_ value: Value) async -> Void
    ) -> some View {
        modifier(TaskTriggerViewModifier(trigger: trigger, action: action))
    }

    /// Adds a task to perform whenever the specified trigger fires.
    /// - Parameters:
    ///   - trigger: A binding to a ``TaskTrigger/PlainTaskTrigger``.
    ///   - action: An async action to perform whenever the trigger fires.
    func task(
        _ trigger: Binding<PlainTaskTrigger>,
        _ action: @escaping @Sendable () async -> Void
    ) -> some View {
        modifier(TaskTriggerViewModifier(trigger: trigger, action: { _ in await action() }))
    }
}
