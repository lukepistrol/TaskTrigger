//
//  TaskTriggerButtonExampleView.swift
//  TaskTriggerDemo
//
//  Created by Lukas Pistrol on 26.11.24.
//

import SwiftUI
import TaskTriggerUI

struct TaskTriggerButtonExampleView: View {

    enum ButtonState {
        case idle
        case loading
        case success
        case cancelled
    }

    @State private var state: ButtonState = .idle

    var body: some View {
        List {
            Section {
                statusImage
            }
            Section {
                TaskTriggerButton(behavior: .blocking(showPlaceholder: false)) {
                    await test()
                } label: {
                    Label("Trigger", systemImage: "play")
                }
            } footer: {
                Text("Blocking behavior, no placeholder")
            }
            Section {
                TaskTriggerButton(
                    "Test",
                    role: .destructive,
                    behavior: .cancellable(showPlaceholder: true)
                ) {
                    await test()
                } placeholder: {
                    Text("Cancel")
                }
            } footer: {
                Text("Cancellable behavior, show \"Cancel\" as placeholder")
            }
            Section {
                TaskTriggerButton("Test", systemImage: "globe") {
                    await test()
                } placeholder: {
                    Label {
                        Text("Waiting...")
                    } icon: {
                        ProgressView()
                    }
                }
            } footer: {
                Text("Default (blocking) behavior, show \"Waiting...\" as placeholder")
            }
            Section {
                TaskTriggerButton(
                    "Test",
                    behavior: .restart(showPlaceholder: true)
                ) {
                    await test()
                } placeholder: {
                    Text("Restart")
                }
            } footer: {
                Text("Restarting behavior, show \"Restart\" as placeholder")
            }
        }
    }

    private var statusImage: some View {
        VStack {
            Group {
                switch state {
                case .idle:
                    Image(systemName: "circle.dotted")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.secondary)
                case .loading:
                    Image(systemName: "arrow.trianglehead.2.clockwise")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.accentColor)
                case .success:
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.green)
                case .cancelled:
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.red)
                }
            }
            .imageScale(.large)
            .frame(height: 120)
            Text(String(describing: state))
        }
        .frame(maxWidth: .infinity)
    }

    private func test() async {
        defer {
            print("")
            Task {
                await reset()
            }
        }
        state = .loading
        print("Triggered")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        if Task.isCancelled {
            state = .cancelled
            print("Cancelled")
            return
        }
        state = .success
        print("Waited 2s")
    }

    private func reset() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        if Task.isCancelled || state == .loading {
            return
        }
        state = .idle
    }
}

#Preview {
    TaskTriggerButtonExampleView()
}
