//
//  SettingsView.swift
//  TaskBuddy
//
//  Created by Luis Enrique Rosas Espinoza on 01/01/25.
//


import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("theme") private var theme = "System" // Default: System theme
    @AppStorage("iCloudSyncEnabled") private var iCloudSyncEnabled = true
    @Environment(\.colorScheme) private var colorScheme // Detecta el esquema actual
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preferences")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { oldValue, newValue in
                            handleNotificationToggle(isEnabled: newValue)
                        }
                        .accessibilityLabel("Toggle notifications")
                        .accessibilityHint("Enable or disable app notifications")
                    
                    Picker("Theme", selection: $theme) {
                        Text("Light").tag("Light")
                        Text("Dark").tag("Dark")
                        Text("System").tag("System")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: theme) {
                        updateColorScheme()
                    }
                    .accessibilityLabel("Theme selection")
                    .accessibilityHint("Choose between Light, Dark, or System themes")
                }
                Section(header: Text("Preferences")) {
                    Toggle("Sync with iCloud", isOn: $iCloudSyncEnabled)
                        .accessibilityLabel("iCloud Synchronization")
                        .accessibilityHint("Enable or disable synchronization with iCloud")
                        .onChange(of: iCloudSyncEnabled) { oldValue, newValue in
                            handleiCloudSyncToggle(isEnabled: newValue)
                        }
                }
            }
            .navigationTitle("Settings")
            .background(Color(UIColor.systemBackground)) // Ajusta dinámicamente
        }
        .preferredColorScheme(resolveColorScheme())
    }
    
    private func handleNotificationToggle(isEnabled: Bool) {
        if isEnabled {
            // Solicita permiso para notificaciones si no se ha otorgado previamente
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus != .authorized {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                        if granted {
                            print("Notifications enabled")
                            // Opcional: Reprogramar notificaciones para tareas existentes
                        } else {
                            print("Notifications permission denied")
                            DispatchQueue.main.async {
                                notificationsEnabled = false // Revertir el toggle
                            }
                        }
                    }
                }
            }
        } else {
            // Desactiva todas las notificaciones
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("Notifications disabled")
        }
    }
    
    private func updateColorScheme() {
        UIWindow.appearance().overrideUserInterfaceStyle = resolveColorScheme() == .dark ? .dark : .light
    }
    
    private func resolveColorScheme() -> ColorScheme? {
        switch theme {
        case "Light":
            return .light
        case "Dark":
            return .dark
        default:
            return nil // Usa el esquema del sistema
        }
    }
    
    private func handleiCloudSyncToggle(isEnabled: Bool) {
        if isEnabled {
            print("iCloud Sync Enabled")
            // Lógica para habilitar la sincronización con iCloud
        } else {
            print("iCloud Sync Disabled")
            // Lógica para desactivar la sincronización con iCloud
        }
    }
}

#Preview {
    SettingsView()
}
