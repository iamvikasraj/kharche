import SwiftUI

struct BreakdownView: View {
    let viewModel: SummaryViewModel

    private var maxAmount: Double {
        viewModel.breakdown.map(\.amount).max() ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Breakdown")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(POPTheme.textPrimary)
                Text("Spending by category")
                    .font(.system(size: 14))
                    .foregroundStyle(POPTheme.textSecondary)
            }

            VStack(spacing: 0) {
                ForEach(Array(viewModel.breakdown.enumerated()), id: \.element.id) { index, cat in
                    let color = POPTheme.categoryColors[index % POPTheme.categoryColors.count]

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Circle().fill(color).frame(width: 10, height: 10)
                            Text(cat.name)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(POPTheme.textPrimary)
                            Spacer()
                            Text("₹\(cat.amount.inrFormatted)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(POPTheme.textPrimary)
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
                            .foregroundStyle(POPTheme.textMuted)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)

                    if index < viewModel.breakdown.count - 1 {
                        Divider().background(Color.white.opacity(0.06)).padding(.horizontal, 16)
                    }
                }
            }
            .popCard()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 100)
    }
}

#Preview("Breakdown") {
    @Previewable @State var viewModel = SummaryViewModel()
    ScrollView {
        BreakdownView(viewModel: viewModel)
    }
    .scrollIndicators(.hidden)
    .task { await viewModel.loadUsers() }
    .background(POPTheme.bg)
    .preferredColorScheme(.dark)
}
