import SwiftUI

enum POPTheme {
    // Backgrounds
    static let bg = Color(hex: "0D0D0D")
    static let bgCard = Color(hex: "1C1C1C")

    // Text
    static let textPrimary = Color(hex: "E5E6E6")
    static let textSecondary = Color(hex: "9CA3AF")
    static let textMuted = Color(hex: "6B7280")

    // Accent
    static let accent = Color(hex: "FF6B2C")
    static let accentLight = Color(hex: "FF8F5C")

    // Semantic
    static let green = Color(hex: "22C55E")
    static let amber = Color(hex: "F59E0B")
    static let red = Color(hex: "EF4444")

    // Borders
    static let border = Color.white.opacity(0.1)
    static let borderLight = Color.white.opacity(0.2)

    // Category colors
    static let categoryColors: [Color] = [
        Color(hex: "FF6B2C"), Color(hex: "22C55E"), Color(hex: "F59E0B"), Color(hex: "3B82F6"),
        Color(hex: "8B5CF6"), Color(hex: "EC4899"), Color(hex: "14B8A6"), Color(hex: "F97316"),
        Color(hex: "06B6D4"), Color(hex: "84CC16"),
    ]

}

extension View {
    func popCard() -> some View {
        self
            .background(Color(hex: "1C1C1C"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 0.25))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
