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
    var id: UUID? = UUID()               // Atributo opcional con valor predeterminado
    var title: String? = ""             // Opcional con valor predeterminado
    var notes: String? = ""             // Opcional con valor predeterminado
    var isCompleted: Bool? = false      // Opcional con valor predeterminado
    var dueDate: Date? = nil            // Opcional
    var categoryColor: String? = "#FFFFFF" // Opcional con valor predeterminado

    init(title: String = "", notes: String = "", isCompleted: Bool = false, dueDate: Date? = nil, categoryColor: String = "#FFFFFF") {
        self.id = UUID()
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.categoryColor = categoryColor
    }
}
