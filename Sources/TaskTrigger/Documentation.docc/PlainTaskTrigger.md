# ``TaskTrigger/PlainTaskTrigger``

Trigger async tasks attached to SwiftUI views with support for cancellation.

## Overview

```swift
@State var trigger = PlainTaskTrigger()

var body: some View {
    Button("Do Something") {
        trigger.trigger()
    }
    .task($trigger) {
        await someAsyncOperation()
    }
}
```

## Topics

### Methods

- ``TaskTrigger/TaskTrigger/trigger()``
