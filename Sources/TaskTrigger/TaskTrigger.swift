//
//  TaskTrigger.swift
//  TaskTrigger
//
//  Created by Lukas Pistrol on 16.09.23.
//

import SwiftUI

public struct TaskTrigger<Value: Equatable>: Equatable where Value: Sendable {

    public enum TaskState<T: Equatable>: Equatable {
        case none
        case active(value: T, uuid: UUID? = nil)
    }

    /// Creates a new ``TaskTrigger``.
    public init() {}

    /// The current state of the task.
    public private(set) var state: TaskState<Value> = .none

    /// Triggers the tasks associated with this ``TaskTrigger`` and passes along a value of type `Value`.
    /// 
    /// - Parameters:
    ///   - value: The value to pass along.
    ///   - id: (Optional) An UUID which by default is initialized each time this method gets called.
    ///   In a case a task should not be re-triggered, explicitly pass the same UUID.
    /// 
    /// - Note: A new UUID is created by default to ensure that repeated triggers cancel and restart the task.
    /// For scenarios where re-triggering should be prevented with the same value, pass a stable UUID.
    mutating public func trigger(value: Value, id: UUID? = nil) {
        let identifier = id ?? UUID()
        self.state = .active(value: value, uuid: identifier)
    }

    /// Cancels the active task.
    mutating public func cancel() {
        self.state = .none
    }
}

public typealias PlainTaskTrigger = TaskTrigger<Bool>

public extension PlainTaskTrigger {
    /// Triggers the tasks associated with this ``PlainTaskTrigger``.
    mutating func trigger() {
        self.state = .active(value: true, uuid: .init())
    }
}
