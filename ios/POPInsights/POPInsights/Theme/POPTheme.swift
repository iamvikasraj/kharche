import SwiftUI

enum POPTheme {
    static let brandPrimary = Color(hex: "4F46E5")
    static let background = Color(hex: "F9FAFB")
    static let cardBackground = Color.white
    static let textPrimary = Color(hex: "1A1A2E")
    static let textSecondary = Color(hex: "6B7280")
    static let textMuted = Color(hex: "9CA3AF")

    static let spendRed = Color(hex: "EF4444")
    static let cashbackGreen = Color(hex: "22C55E")
    static let coinsAmber = Color(hex: "F59E0B")
    static let failedGray = Color(hex: "6B7280")

    static let categoryColors: [Color] = [
        Color(hex: "4F46E5"),
        Color(hex: "22C55E"),
        Color(hex: "F59E0B"),
        Color(hex: "EF4444"),
        Color(hex: "8B5CF6"),
        Color(hex: "EC4899"),
        Color(hex: "14B8A6"),
        Color(hex: "F97316"),
        Color(hex: "06B6D4"),
        Color(hex: "84CC16"),
    ]
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
