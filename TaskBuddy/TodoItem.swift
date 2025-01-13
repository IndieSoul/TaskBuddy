//
//  TaskModel.swift
//  TaskBuddy
//
//  Created by Luis Enrique Rosas Espinoza on 01/01/25.
//

import Foundation
import SwiftData

@Model
class TodoItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var notes: String
    var isCompleted: Bool
    var dueDate: Date?
    var categoryColor: String
    
    init(title: String, notes: String = "", isCompleted: Bool = false, dueDate: Date? = nil, categoryColor: String = "#FFFFFF") {
        self.id = UUID()
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.categoryColor = categoryColor
    }
}
