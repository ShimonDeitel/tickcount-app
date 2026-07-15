import SwiftUI

/// Bespoke palette for Tickcount: warm/earthy tones distinct to this app's domain.
enum Theme {
    static let background = Color(red: 28.0/255, green: 21.0/255, blue: 18.0/255)
    static let primary = Color(red: 139.0/255, green: 74.0/255, blue: 43.0/255)
    static let accent = Color(red: 201.0/255, green: 162.0/255, blue: 39.0/255)
    static let card = Color.white
    static let textPrimary = Color.black.opacity(0.85)
    static let textSecondary = Color.black.opacity(0.55)

    static func titleFont(_ size: CGFloat = 28) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func bodyFont(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .rounded)
    }
}
