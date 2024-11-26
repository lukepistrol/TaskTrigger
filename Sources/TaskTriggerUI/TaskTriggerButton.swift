//
//  TaskTriggerButton.swift
//  TaskTriggerUI
//
//  Created by Lukas Pistrol on 26.11.24.
//

import SwiftUI

struct TaskTriggerButton<L: View>: View {
    let action: () -> Void
    let label: () -> L
    var body: some View {
        Button(action: action, label: label)
    }
}

#Preview {
    TaskTriggerButton {
        // action
    } label: {
        Label("Trigger", systemImage: "play")
    }
}
