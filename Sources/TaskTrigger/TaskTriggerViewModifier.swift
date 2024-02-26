//
//  TaskTriggerViewModifier.swift
//  TaskTrigger
//
//  Created by Lukas Pistrol on 16.09.23.
//

import SwiftUI

struct TaskTriggerViewModifier<Value: Equatable>: ViewModifier where Value: Sendable {

    typealias Action = @Sendable (_ value: Value) async -> Void

    internal init(
        trigger: Binding<TaskTrigger<Value>>,
        action: @escaping Action
    ) {
        self._trigger = trigger
        self.action = action
    }

    @Binding 
    private var trigger: TaskTrigger<Value>
    
    private let action: Action

    func body(content: Content) -> some View {
        content
            .task(id: trigger.state) {
                // check that the trigger's state is indeed active and obtain the value.
                guard case let .active(value, _) = trigger.state else {
                    return
                }

                // execute the async work.
                await action(value)

                // if not already cancelled, reset the trigger.
                if !Task.isCancelled {
                    self.trigger.cancel()
                }
            }
    }
}
