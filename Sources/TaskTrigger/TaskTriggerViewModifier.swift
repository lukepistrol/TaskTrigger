//
//  File.swift
//  
//
//  Created by Lukas Pistrol on 16.09.23.
//

import SwiftUI

struct TaskTriggerViewModifier<T: Equatable>: ViewModifier {

    typealias Action = @Sendable (_ value: T) async -> Void

    internal init(
        trigger: Binding<TaskTrigger<T>>,
        action: @escaping Action
    ) {
        self._trigger = trigger
        self.action = action
    }

    @Binding 
    private var trigger: TaskTrigger<T>
    
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
