import SwiftUI
import SwiftData

struct TaskListView: View {
    @Query(sort: \TodoItem.dueDate) var tasks: [TodoItem]
    @Environment(\.modelContext) private var modelContext
    @State private var showAddTaskView = false
    @State private var selectedTask: TodoItem?

    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    HStack {
                        Circle()
                            .fill(Color(hex: task.categoryColor) ?? .gray)
                            .frame(width: 10, height: 10)
                            .accessibilityHidden(true)

                        VStack(alignment: .leading) {
                            Text(task.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .accessibilityLabel(Text("Task title: \(task.title)"))
                            
                            if let dueDate = task.dueDate {
                                Text("Due: \(dueDate.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .accessibilityLabel(Text("Due date: \(dueDate.formatted(date: .complete, time: .complete))"))
                            }
                        }
                        Spacer()
                        
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(task.isCompleted ? .green : .gray)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    task.isCompleted.toggle()
                                }
                            }
                            .accessibilityLabel(Text(task.isCompleted ? "Mark as incomplete" : "Mark as complete"))
                    }
                    .contentShape(Rectangle()) // Hace toda la fila seleccionable
                    .onTapGesture {
                        selectedTask = task
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let taskToDelete = tasks[index]
                        withAnimation {
                            modelContext.delete(taskToDelete)
                        }
                    }
                }
            }
            .navigationTitle("TaskBuddy")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddTaskView.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                    .accessibilityLabel("Add a new task")
                }
            }
            .sheet(isPresented: $showAddTaskView) {
                AddTaskView()
            }
            .sheet(item: $selectedTask) { task in
                EditTaskView(task: Binding(get: {
                    task
                }, set: { updatedTask in
                    if let existingTask = tasks.first(where: { $0.id == updatedTask.id }) {
                        existingTask.title = updatedTask.title
                        existingTask.notes = updatedTask.notes
                        existingTask.dueDate = updatedTask.dueDate
                        existingTask.categoryColor = updatedTask.categoryColor
                        existingTask.isCompleted = updatedTask.isCompleted
                        
                        // Guarda los cambios en el contexto
                        try? modelContext.save()
                    }
                }))
            }
            .background(Color(UIColor.systemBackground)) // Compatible con modo oscuro
        }
    }
}

extension Color {
    init?(hex: String) {
        let r, g, b, a: Double

        let start = hex.hasPrefix("#") ? hex.index(hex.startIndex, offsetBy: 1) : hex.startIndex
        let hexColor = String(hex[start...])

        guard hexColor.count == 6 || hexColor.count == 8,
              let hexNumber = Int(hexColor, radix: 16) else {
            return nil
        }

        if hexColor.count == 6 {
            r = Double((hexNumber >> 16) & 0xFF) / 255
            g = Double((hexNumber >> 8) & 0xFF) / 255
            b = Double(hexNumber & 0xFF) / 255
            a = 1.0
        } else {
            r = Double((hexNumber >> 24) & 0xFF) / 255
            g = Double((hexNumber >> 16) & 0xFF) / 255
            b = Double((hexNumber >> 8) & 0xFF) / 255
            a = Double(hexNumber & 0xFF) / 255
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

#Preview {
    TaskListView()
}
