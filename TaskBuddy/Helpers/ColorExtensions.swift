//
//  ColorExtensions.swift
//  TaskBuddy
//
//  Created by Luis Enrique Rosas Espinoza on 13/01/25.
//

import SwiftUI

extension Color {
    init?(hex: String) {
        let r, g, b, a: Double
        let start = hex.hasPrefix("#") ? hex.index(hex.startIndex, offsetBy: 1) : hex.startIndex
        let hexColor = String(hex[start...])

        guard hexColor.count == 6 || hexColor.count == 8,
              let hexNumber = Int(hexColor, radix: 16) else { return nil }

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

    func toHexString() -> String {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0]
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
