import SwiftUI

struct TrendsView: View {
    let viewModel: SummaryViewModel

    private var maxSpend: Double {
        viewModel.trends.map(\.spend).max() ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Trends")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(POPTheme.textPrimary)
                Text("Monthly spending patterns")
                    .font(.system(size: 14))
                    .foregroundStyle(POPTheme.textSecondary)
            }

            barChart
            monthTable
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 100)
    }

    private var barChart: some View {
        HStack(alignment: .bottom, spacing: 6) {
            ForEach(viewModel.trends) { month in
                VStack(spacing: 6) {
                    Text("₹\(Int(month.spend / 1000))k")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(POPTheme.textSecondary)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [POPTheme.accent, POPTheme.accentLight],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(height: max(8, CGFloat(month.spend / maxSpend) * 140))

                    Text(month.monthLabel)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(POPTheme.textMuted)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .popCard()
    }

    private var monthTable: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.trends.enumerated()), id: \.element.id) { index, month in
                HStack {
                    Text(month.month)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(POPTheme.textSecondary)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("₹\(month.spend.inrFormatted)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(POPTheme.textPrimary)
                        Text("+₹\(month.cashback.inrFormatted)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(POPTheme.green)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)

                if index < viewModel.trends.count - 1 {
                    Divider().background(Color.white.opacity(0.06)).padding(.horizontal, 16)
                }
            }
        }
        .popCard()
    }
}

#Preview("Trends") {
    @Previewable @State var viewModel = SummaryViewModel()
    ScrollView {
        TrendsView(viewModel: viewModel)
    }
    .scrollIndicators(.hidden)
    .task { await viewModel.loadUsers() }
    .background(POPTheme.bg)
    .preferredColorScheme(.dark)
}
