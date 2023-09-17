# ``TaskTrigger/TaskTrigger``

Trigger async tasks attached to SwiftUI views with support for cancellation.

## Overview

```swift
@State var trigger = TaskTrigger<Int>()

var body: some View {
    List(0..<10) { index in
        Button("Item \(index)") {
            trigger.trigger(value: index)
        }
    }
    .task($trigger) { index in
        await someAsyncOperation(for: index)
    }
}
```

> Note: For triggering a task without a value see ``TaskTrigger/PlainTaskTrigger``.

## Topics

### Initializers

- ``TaskTrigger/TaskTrigger/init()``

### Methods

- ``TaskTrigger/TaskTrigger/trigger(value:id:)``
- ``TaskTrigger/TaskTrigger/trigger()``
- ``TaskTrigger/TaskTrigger/cancel()``
