//
//  UIApplicationExtensions.swift
//  TaskBuddy
//
//  Created by Luis Enrique Rosas Espinoza on 13/01/25.
//

import UIKit

extension UIApplication {
    func endEditing() {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
