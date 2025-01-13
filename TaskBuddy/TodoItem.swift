//
//  TaskModel.swift
//  TaskBuddy
//
//  Created by Luis Enrique Rosas Espinoza on 01/01/25.
//

import Foundation
import SwiftData

@Model
class Task {
    @Attribute(.unique) var id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var dueDate: Date?
    var categoryColor: String
    
    init(title: String, description: String = "", isCompleted: Bool = false, dueDate: Date? = nil, categoryColor: String = "#FFFFFF") {
        self.id = UUID()
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.categoryColor = categoryColor
    }
}
