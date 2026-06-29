import SwiftUI

struct InsightsView: View {
    let viewModel: SummaryViewModel
    @State private var selectedTab = 0
    @Environment(\.dismiss) private var dismiss

    private let tabs = ["Breakdown", "Trends", "Recurring"]

    private var headerImage: some View {
        Image("InsightsHeaderBg")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
            .padding(.top, 0)
    }

    private var summaryStrip: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("TOTAL SPEND")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(POPTheme.textSecondary)
                    .tracking(0.5)
                Text("₹\(viewModel.summary?.totalSpend.inrFormatted ?? "0")")
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundStyle(POPTheme.textPrimary)
                    .tracking(-1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 0) {
                statItem(value: "₹\(viewModel.summary?.totalCashback.inrFormatted ?? "0")", label: "Cashback", color: POPTheme.green)
                statDivider
                statItem(value: "\(viewModel.summary?.totalCoins ?? 0)", label: "POPcoins", color: POPTheme.amber)
                statDivider
                statItem(value: "₹\(viewModel.summary?.failedAmount.inrFormatted ?? "0")", label: "Failed", color: POPTheme.red)
            }
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text("\(viewModel.summary?.txnCount ?? 0) transactions")
                .font(.system(size: 11))
                .foregroundStyle(POPTheme.textMuted)
        }
        .padding(16)
        .popCard()
        .padding(.horizontal, 20)
    }

    private func statItem(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label.uppercased())
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(POPTheme.textMuted)
                .tracking(0.3)
        }
        .frame(maxWidth: .infinity)
    }

    private var statDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.1))
            .frame(width: 1, height: 24)
    }

    private var segmentedControl: some View {
        HStack(spacing: 4) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, title in
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) { selectedTab = index }
                } label: {
                    Text(title)
                        .font(.system(size: 13, weight: selectedTab == index ? .semibold : .medium))
                        .foregroundStyle(selectedTab == index ? POPTheme.textPrimary : POPTheme.textMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            selectedTab == index
                                ? POPTheme.bgCard
                                : Color.clear
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(4)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var currentTabContent: some View {
        switch selectedTab {
        case 0: BreakdownView(viewModel: viewModel)
        case 1: TrendsView(viewModel: viewModel)
        default: RecurringView(viewModel: viewModel)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerImage
                summaryStrip
                    .padding(.top, -8)
                segmentedControl
                    .padding(.top, 16)
                currentTabContent
            }
        }
        .scrollIndicators(.hidden)
        .overlay(alignment: .topLeading) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(POPTheme.textPrimary)
                    .frame(width: 40, height: 40)
            }
            .padding(.leading, 12)
            .padding(.top, 56)
        }
        .background(POPTheme.bg)
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview("Insights") {
    @Previewable @State var viewModel = SummaryViewModel()
    NavigationStack {
        InsightsView(viewModel: viewModel)
    }
    .task { await viewModel.loadUsers() }
    .preferredColorScheme(.dark)
}
