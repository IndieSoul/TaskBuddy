//
//  AddTaskView.swift
//  TaskBuddy
//
//  Created by Luis Enrique Rosas Espinoza on 01/01/25.
//

import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var title: String
    @State private var notes: String
    @State private var dueDate: Date
    @State private var categoryColor: String
    let task: TodoItem?

    init(task: TodoItem? = nil) {
        self.task = task
        _title = State(initialValue: task?.title ?? "")
        _notes = State(initialValue: task?.notes ?? "")
        _dueDate = State(initialValue: task?.dueDate ?? Date())
        _categoryColor = State(initialValue: task?.categoryColor ?? "#FFFFFF")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)

                    TextField("Notes", text: $notes)
                }

                Section(header: Text("Due Date")) {
                    DatePicker("Select Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                }

                Section(header: Text("Category Color")) {
                    ColorPicker("Pick a Color", selection: Binding(get: {
                        Color(hex: categoryColor) ?? .white
                    }, set: { newValue in
                        categoryColor = newValue.toHexString()
                    }))
                }
            }
            .navigationTitle(task == nil ? "New Task" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(task == nil ? "Save" : "Update") {
                        if let task = task {
                            // Actualiza la tarea existente
                            task.title = title
                            task.notes = notes
                            task.dueDate = dueDate
                            task.categoryColor = categoryColor
                        } else {
                            // Crea una nueva tarea
                            let newTask = TodoItem(title: title, notes: notes, dueDate: dueDate, categoryColor: categoryColor)
                            modelContext.insert(newTask)
                        }
                        try? modelContext.save()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
