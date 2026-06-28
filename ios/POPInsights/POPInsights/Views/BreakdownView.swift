import SwiftUI

private let colors: [Color] = [
    Color(hex: "FF6B2C"), Color(hex: "22C55E"), Color(hex: "F59E0B"), Color(hex: "3B82F6"),
    Color(hex: "8B5CF6"), Color(hex: "EC4899"), Color(hex: "14B8A6"), Color(hex: "EF4444"),
    Color(hex: "06B6D4"), Color(hex: "84CC16"),
]

struct BreakdownView: View {
    let viewModel: SummaryViewModel

    private var maxAmount: Double {
        viewModel.breakdown.map(\.amount).max() ?? 1
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Breakdown")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color(hex: "E5E6E6"))
                    Text("Spending by category")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "9CA3AF"))
                }

                VStack(spacing: 0) {
                    ForEach(Array(viewModel.breakdown.enumerated()), id: \.element.id) { index, cat in
                        let color = colors[index % colors.count]

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Circle()
                                    .fill(color)
                                    .frame(width: 10, height: 10)
                                Text(cat.name)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color(hex: "E5E6E6"))
                                Spacer()
                                Text("₹\(cat.amount.inrFormatted)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color(hex: "E5E6E6"))
                            }

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white.opacity(0.06))
                                        .frame(height: 6)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(color)
                                        .frame(width: geo.size.width * (cat.amount / maxAmount), height: 6)
                                }
                            }
                            .frame(height: 6)

                            Text("\(String(format: "%.1f", cat.percent))%")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(Color(hex: "6B7280"))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)

                        if index < viewModel.breakdown.count - 1 {
                            Divider()
                                .background(Color.white.opacity(0.06))
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .background(Color(hex: "1C1C1C"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 0.25))
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(Color(hex: "0D0D0D"))
    }
}
