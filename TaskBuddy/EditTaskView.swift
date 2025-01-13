//
//  EditTaskView.swift
//  TaskBuddy
//
//  Created by Luis Enrique Rosas Espinoza on 01/01/25.
//

import SwiftUI
import SwiftData

struct EditTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var task: TodoItem

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $task.title)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)

                    TextField("Notes", text: $task.notes)
                }

                Section(header: Text("Due Date")) {
                    DatePicker("Select Date", selection: Binding(get: {
                        task.dueDate ?? Date()
                    }, set: { newValue in
                        task.dueDate = newValue
                    }), displayedComponents: [.date, .hourAndMinute])
                }

                Section(header: Text("Category Color")) {
                    ColorPicker("Pick a Color", selection: Binding(get: {
                        Color(hex: task.categoryColor) ?? .white
                    }, set: { newValue in
                        task.categoryColor = newValue.toHexString() ?? "#FFFFFF"
                    }))
                }
            }
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                    }
                }
            }
        }
    }
}
