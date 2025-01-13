//
//  NotificationManager.swift
//  TaskBuddy
//
//  Created by Luis Enrique Rosas Espinoza on 13/01/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func scheduleNotification(for task: TodoItem) {
        // Usa valores predeterminados para manejar los opcionales
        let title = task.title ?? "Task Reminder"
        let notes = task.notes ?? "No additional details"
        guard let dueDate = task.dueDate else {
            print("No due date provided. Notification will not be scheduled.")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = notes
        content.sound = .default

        // Configura el disparador basado en la fecha de vencimiento
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        // Identificador único para la notificación
        let identifier = task.id?.uuidString ?? UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Programa la notificación
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for task: \(title) at \(dueDate)")
            }
        }
    }

    func cancelNotification(for task: TodoItem) {
        guard let identifier = task.id?.uuidString else {
            print("No valid identifier for the task. Notification cannot be cancelled.")
            return
        }

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Notification cancelled for task: \(task.title ?? "Unknown Task")")
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All notifications have been cancelled.")
    }
}
