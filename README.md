# TaskTrigger

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Flukepistrol%2FTaskTrigger%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/lukepistrol/TaskTrigger)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Flukepistrol%2FTaskTrigger%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/lukepistrol/TaskTrigger)

Attach async tasks to SwiftUI views using a trigger mechanism. See [this](#the-solution) for examples. 

## Table Of Contents

- [Usage](#usage)
- [Overview](#overview)
- [The Problem](#the-problem)
- [The Solution](#the-solution)

## Usage

```swift
dependencies: [
    .package(url: "https://github.com/lukepistrol/TaskTrigger.git", from: "0.1.0"),
],
```

Make sure to `import TaskTrigger` in any location you'd want to use it.

## Overview

When using Swift's structured concurrency in SwiftUI it is good practice to
tie the tasks to the relevant view's lifetime in order to support task 
cancellation should the view be dismissed.

> **Note**
> Usually a task might not take all that long that we would even care for 
> cancellation. But imagine downloading some large amounts of data from a remote
> server which – depending on the network connection – could take a consiterable
> amount of time. When the user decides to dismiss the view it might be good to 
> also cancel the task to not keep doing no longer necessary work.
>
> Of course this does not guarantee that the child tasks will instantly stop but rather
> they will be informed via `Task.isCancelled` that they've been cancelled. If or how 
> they handle cancellation is entirely up to the implementation of the child task.

## The Problem

This can already be achieved by using the `task(id:priority:_:)` view modifier.
However this requires additional housekeeping for the `id`. 

In a primitive example where we just want to trigger some task we might use a `Bool`
for the `id`:

```swift
@State var triggerTask: Bool = false

var body: some View {
    Button("Do Something") {
        triggerTask = true
    }
    .task(id: triggerTask) {
        guard triggerTask else { return }
        await someAsyncOperation()
        triggerTask = false
    }
}
```

> **Note**
> We need to check that `triggerTask` is indeed `true`, and otherwise return. 
> We also need to reset `triggerTask` at the end of execution. Otherwise another
> tap wouldn't trigger the `task(id:priority:_:)` again.
>
> The first step is crucial becuase we would trigger the task again from in itself
> when we reset `triggerTask` at the end.

This makes even more sense in a more complicated example where we have a list of views
where we would like to do something based on some identifier:

```swift
@State var triggerTaskId: Int?

var body: some View {
    List(0..<10) { index in
        Button("Item \(index)") {
            triggerTaskId = index
        }
    }
    .task(id: triggerTaskId) {
        guard let triggerTaskId else { return }
        await someAsyncOperation(for: triggerTaskId)
        triggerTaskId = nil
    }
}
```

> **Note**
> In this case we have an optional integer and we set it to the index of the button
> in the list once pressed. We need to unwrap the optional value and reset it to `nil` afterwards.

This approach, while it really works well, comes with a lot of overhead directly in our view.
Also we have to call the state value directly from within our task which might be cumbersome when we
hold the state in a view model.

## The Solution

To make things simpler on the caller's side let's wrap all of this functionality inside
a simple type `TaskTrigger`.

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

1. We declare a new state variable `trigger` and initialize the `TaskTrigger` of type `Int`.
2. In our button we call the `trigger(value:id:)` method on our `trigger` and pass in our value.
3. We attach a new variant of the `task` view modifier to our view and bind it to our `trigger`.
4. The body will only execute when the `trigger` was triggered. The value we passed into the 
`trigger(value:id:)` method earlier gets passed into the closure as an argument.
5. All cancellation related handling, sanity checking, as well as resetting the state is handled
automatically behind the scenes.

> **Note**
> You might wonder why there's an optional parameter `id` on the `trigger(value:id:)` method.
> By default this will create a new `UUID` whenever the method is called. This means we can tap the
> same button multiple times and prior operations will get cancelled if they are still running.
>
> In case you don't want that to happen explicitly set the `id` parameter and it won't cancel
> prior operations since both the `value` and `id` are still the same.

For triggers that don't need to attach a value, we can simply use `PlainTaskTrigger` (which is a 
typealias for `TaskTrigger<Bool>`):

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

## Contribution

If you have any ideas on how to take this further I'm happy to discuss things in an issue.

-----

<a href="https://www.buymeacoffee.com/lukeeep" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
