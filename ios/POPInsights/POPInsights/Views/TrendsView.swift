import SwiftUI

struct TrendsView: View {
    let viewModel: SummaryViewModel

    private var maxSpend: Double {
        viewModel.trends.map(\.spend).max() ?? 1
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Trends")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color(hex: "E5E6E6"))
                    Text("Monthly spending patterns")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "9CA3AF"))
                }

                barChart
                monthTable
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(Color(hex: "0D0D0D"))
    }

    private var barChart: some View {
        HStack(alignment: .bottom, spacing: 6) {
            ForEach(viewModel.trends) { month in
                VStack(spacing: 6) {
                    Text("₹\(Int(month.spend / 1000))k")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(Color(hex: "9CA3AF"))

                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "FF6B2C"), Color(hex: "FF8F5C")],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(height: max(8, CGFloat(month.spend / maxSpend) * 140))

                    Text(month.monthLabel)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Color(hex: "6B7280"))
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(Color(hex: "1C1C1C"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 0.25))
    }

    private var monthTable: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.trends.enumerated()), id: \.element.id) { index, month in
                HStack {
                    Text(month.month)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color(hex: "9CA3AF"))
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("₹\(month.spend.inrFormatted)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color(hex: "E5E6E6"))
                        Text("+₹\(month.cashback.inrFormatted)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Color(hex: "22C55E"))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)

                if index < viewModel.trends.count - 1 {
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
}
