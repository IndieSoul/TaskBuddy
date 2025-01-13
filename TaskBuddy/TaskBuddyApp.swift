//
//  TaskBuddyApp.swift
//  TaskBuddy
//
//  Created by Luis Enrique Rosas Espinoza on 01/01/25.
//

import SwiftUI
import SwiftData

@main
struct TaskBuddyApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [TodoItem.self]) // Asegura que SwiftData gestione `TodoItem`
        }
    }
}

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        if hasSeenOnboarding {
            TaskListView()
        } else {
            OnboardingView()
        }
    }
}
