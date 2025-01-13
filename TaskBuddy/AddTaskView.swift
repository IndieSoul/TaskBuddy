//
//  AddTaskView.swift
//  TaskBuddy
//
//  Created by Luis Enrique Rosas Espinoza on 01/01/25.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var title = ""
    @State private var notes = ""
    @State private var dueDate: Date = Date()
    @State private var categoryColor = "#FFFFFF"
    @State private var saveButtonScale: CGFloat = 1.0

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                        .accessibilityLabel("Task Title")
                        .accessibilityHint("Enter a title for the task")

                    TextField("Notes", text: $notes)
                        .accessibilityLabel("Task Notes")
                        .accessibilityHint("Enter additional details about the task")
                }

                Section(header: Text("Due Date")) {
                    DatePicker("Select Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                        .accessibilityLabel("Due Date Picker")
                        .accessibilityHint("Choose a due date and time for the task")
                }

                Section(header: Text("Category Color")) {
                    ColorPicker("Pick a Color", selection: Binding(get: {
                        Color(hex: categoryColor) ?? .white
                    }, set: { newValue in
                        categoryColor = newValue.toHexString() ?? "#FFFFFF"
                    }))
                    .accessibilityLabel("Category Color Picker")
                    .accessibilityHint("Choose a color to categorize the task")
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .accessibilityLabel("Cancel")
                    .accessibilityHint("Dismiss without saving the task")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            saveButtonScale = 1.2
                        }
                        let newTask = TodoItem(title: title, notes: notes, dueDate: dueDate, categoryColor: categoryColor)
                        modelContext.insert(newTask)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                    .scaleEffect(saveButtonScale) // Animación de escala
                    .onTapGesture {
                        withAnimation(.spring()) {
                            saveButtonScale = 1.0
                        }
                    }
                    .accessibilityLabel("Save Task")
                    .accessibilityHint("Save the new task")
                }
            }
            .background(Color(UIColor.systemBackground)) // Soporte para modo oscuro
        }
    }
}

extension Color {
    func toHexString() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let redHex = Int(red * 255)
            let greenHex = Int(green * 255)
            let blueHex = Int(blue * 255)
            return String(format: "#%02X%02X%02X", redHex, greenHex, blueHex)
        }
        return nil
    }
}

#Preview {
    AddTaskView()
}
