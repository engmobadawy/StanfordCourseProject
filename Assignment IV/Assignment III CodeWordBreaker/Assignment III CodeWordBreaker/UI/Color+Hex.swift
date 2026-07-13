//
//  SwiftUIView.swift
//  Assignment III CodeWordBreaker
//
//  Created by mohamed mahmoud sobhy badawy on 13/07/2026.
//

import SwiftUI

// MARK: - Color Extension for Hex String Conversion
extension Color {
    /// Initializes a SwiftUI Color from a Hex String (ARGB or RGB)
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var argb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&argb)

        let a, r, g, b: Double
        switch hexSanitized.count {
        case 6: // RGB
            r = Double((argb >> 16) & 0xFF) / 255.0
            g = Double((argb >> 8) & 0xFF) / 255.0
            b = Double(argb & 0xFF) / 255.0
            a = 1.0
        case 8: // ARGB
            a = Double((argb >> 24) & 0xFF) / 255.0
            r = Double((argb >> 16) & 0xFF) / 255.0
            g = Double((argb >> 8) & 0xFF) / 255.0
            b = Double(argb & 0xFF) / 255.0
        default: // Fallback to clear if invalid
            a = 0.0; r = 0.0; g = 0.0; b = 0.0
        }

        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }

    /// Converts a SwiftUI Color to a Hex String (ARGB)
    func toHex() -> String {
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let argb = (Int(a * 255) << 24) | (Int(r * 255) << 16) | (Int(g * 255) << 8) | Int(b * 255)
        return String(format: "#%08X", argb)
    }
}
