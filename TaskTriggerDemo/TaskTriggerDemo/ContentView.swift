//
//  ContentView.swift
//  TaskTriggerDemo
//
//  Created by Lukas Pistrol on 26.11.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    TaskTriggerExampleView()
                } label: {
                    Label("TaskTrigger", systemImage: "play")
                }
                NavigationLink {
                    TaskTriggerButtonExampleView()
                } label: {
                    Label("TaskTriggerButton", systemImage: "play.rectangle.fill")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
