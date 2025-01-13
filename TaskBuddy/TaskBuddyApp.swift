//
//  TaskBuddyApp.swift
//  TaskBuddy
//
//  Created by Luis Enrique Rosas Espinoza on 01/01/25.
//


import SwiftUI
import UserNotifications
import SwiftData

@main
struct TaskBuddyApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("theme") private var theme = "System"

    init() {
        requestNotificationPermissions()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(getColorScheme())
                .modelContainer(for: [TodoItem.self])
            
        }
    }

    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            } else if granted {
                print("Notification permissions granted.")
            } else {
                print("Notification permissions denied.")
            }
        }
    }

    private func getColorScheme() -> ColorScheme? {
        switch theme {
        case "Light":
            return .light
        case "Dark":
            return .dark
        default:
            return nil
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
