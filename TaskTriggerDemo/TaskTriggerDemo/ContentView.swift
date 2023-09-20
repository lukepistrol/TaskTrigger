//
//  ContentView.swift
//  TaskTriggerDemo
//
//  Created by Lukas Pistrol on 2023-09-20.
//

import SwiftUI
import TaskTrigger

/*
 This is a very simple example showing how to use TaskTrigger in a SwiftUI View.

 The view contains a Text showing a random number and two buttons. The first button
 triggers a task that sets the random number to a new value. The second button
 triggers a task that resets the random number to zero.

 Both tasks simulate an async operation by using Task.sleep.
 */

struct ContentView: View {

    @State private var randomNumber: Int = 0

    /*
     TaskTrigger is generic and accepts any value that conforms to Equatable and Sendable.

     For convenience there is also PlainTaskTrigger which is basically `TaskTrigger<Bool>`.
     PlainTaskTrigger is useful if you don't need to pass a value to the task and therefore
     can be triggered with the trigger() method instead of trigger(value:).
     */

    @State private var randomTrigger = TaskTrigger<Int>()
    @State private var resetTrigger = PlainTaskTrigger()
    
    var body: some View {
        VStack {
            Text(randomNumber, format: .number)
                .font(.system(size: 60, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .contentTransition(.numericText())

            VStack {
                HStack {
                    Button("Random Number") {
                        randomTrigger.trigger(value: Int.random(in: 0...100))
                    }
                    Button("Reset", role: .destructive) {
                        resetTrigger.trigger()
                    }
                }
                Button("Cancel All") {
                    randomTrigger.cancel()
                    resetTrigger.cancel()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .animation(.snappy, value: randomNumber)

        /*
         The task modifiers below look pretty similar to the ones provided by SwiftUI.

         It takes a binding to a TaskTrigger and the closure gets executed whenever the
         trigger fires. The closure also gets passed the value that was attached to the
         trigger. The PlainTaskTrigger variant doesn't need a value since its boolean
         value is always true in the triggered state.

         The task only lives as long as the view is alive. If the view gets destroyed
         the task is cancelled automatically. You can also cancel the task manually
         by calling the cancel() method on the trigger.

         Firing a trigger multiple times in a row will cancel the previous task and
         start a new one.
         */

        .task($randomTrigger) { value in
            await setRandomNumber(value)
        }
        .task($resetTrigger) {
            await resetToZero()
        }
    }

    /*
     The two functions below simulate an asynchroneous task wich also checks for cancellation.

     You can test this easily by pressing a button twice in a row. The first task will be
     cancelled and the second one will be executed.

     This also happens if the "random number" should be the same each time since TaskTrigger
     also creates a new UUID each time the trigger method gets called.

     Typically those functions would live in a ViewModel or similar and perform a real async
     operation like a network call or some other (possibly) expensive operation.
     */

    @MainActor
    private func setRandomNumber(_ value: Int) async {
        try? await Task.sleep(for: .seconds(1))
        if Task.isCancelled { return }
        self.randomNumber = value
    }

    @MainActor
    private func resetToZero() async {
        try? await Task.sleep(for: .seconds(1))
        if Task.isCancelled { return }
        self.randomNumber = 0
    }
}

#Preview {
    ContentView()
}
