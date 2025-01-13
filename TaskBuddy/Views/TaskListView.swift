//
//  TaskListView.swift
//  TaskBuddy
//
//  Created by Luis Enrique Rosas Espinoza on 01/01/25.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    @Query(sort: \TodoItem.dueDate) var tasks: [TodoItem]
    @Environment(\.modelContext) private var modelContext
    @State private var showAddTaskView = false
    @State private var showSettingsView = false
    @State private var selectedTask: TodoItem?
    @State private var searchText: String = ""
    @FocusState private var isSearchFieldFocused: Bool

    var body: some View {
        NavigationView {
            VStack {
                // Barra de búsqueda
                HStack {
                    TextField("Search tasks...", text: $searchText)
                        .focused($isSearchFieldFocused)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)

                    Button("Done") {
                        isSearchFieldFocused = false
                    }
                    .padding(.trailing)
                }

                List {
                    ForEach(filteredTasks) { task in
                        HStack {
                            Circle()
                                .fill(Color(hex: task.categoryColor ?? "#FFFFFF") ?? .gray)
                                .frame(width: 10, height: 10)
                                .accessibilityHidden(true)

                            VStack(alignment: .leading) {
                                Text(task.title ?? "Untitled Task")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .accessibilityLabel(Text("Task title: \(task.title ?? "Untitled Task")"))

                                if let dueDate = task.dueDate {
                                    Text("Due: \(dueDate.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .accessibilityLabel(Text("Due date: \(dueDate.formatted(date: .complete, time: .complete))"))
                                }
                            }
                            Spacer()

                            Image(systemName: task.isCompleted == true ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted == true ? .green : .gray)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        task.isCompleted?.toggle()
                                        try? modelContext.save()
                                    }
                                }
                                .accessibilityLabel(Text(task.isCompleted == true ? "Mark as incomplete" : "Mark as complete"))
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedTask = task
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let taskToDelete = filteredTasks[index]
                            withAnimation {
                                modelContext.delete(taskToDelete)
                            }
                        }
                    }
                }
                .onTapGesture {
                    isSearchFieldFocused = false
                }
            }
            .navigationTitle("TaskBuddy")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddTaskView.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                    .accessibilityLabel("Add a new task")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showSettingsView.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .font(.title2)
                    }
                    .accessibilityLabel("Open settings")
                }
            }
            .sheet(isPresented: $showAddTaskView) {
                AddTaskView()
            }
            .sheet(item: $selectedTask) { task in
                AddTaskView(task: task)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
            .background(Color(UIColor.systemBackground)) // Fondo para detectar toques
        }
    }

    // Filtra las tareas basadas en el texto de búsqueda
    private var filteredTasks: [TodoItem] {
        if searchText.isEmpty {
            return tasks
        } else {
            return tasks.filter { task in
                (task.title?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (task.notes?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
}

#Preview {
    TaskListView()
}
