import SwiftUI

struct InsightsView: View {
    let viewModel: SummaryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showAllCategories = false

    private var dateRangeText: String {
        guard !viewModel.trends.isEmpty else { return "All Time" }
        let earliest = viewModel.trends.first?.month ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        if let date = formatter.date(from: earliest) {
            let display = DateFormatter()
            display.dateFormat = "MMM d"
            return "\(display.string(from: date)) - Today"
        }
        return "All Time"
    }

    private var totalSpend: String {
        viewModel.summary?.totalSpend.inrFormatted ?? "0"
    }

    private static let categoryIcons: [String: String] = [
        "Groceries": "cart",
        "Food & Dining": "fork.knife",
        "Travel": "airplane",
        "Shopping": "bag",
        "Tech": "desktopcomputer",
        "Healthcare": "cross.case",
        "Fashion": "tshirt",
        "Transport": "car",
        "Supermarkets": "building.2",
        "Other": "square.grid.2x2",
    ]

    // MARK: - Hero Header

    private var heroHeader: some View {
        ZStack {
            Image("InsightsHeaderBg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 331)
                .clipped()

            Color.black.opacity(0.2)

            VStack(spacing: 12) {
                Spacer()
                    .frame(height: 60)

                Text(dateRangeText)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(hex: "F1F8FF"))

                Image("InsightsTitle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 47)

                HStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Text("Collected")
                            .font(.system(size: 12, weight: .light))
                            .tracking(0.48)

                        Image("PopCoin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .clipShape(Circle())

                        Text("\(viewModel.summary?.totalCoins ?? 0)")
                            .font(.system(size: 14, weight: .medium))
                            .tracking(0.56)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "2E0125"))
                    .clipShape(Capsule())

                    HStack(spacing: 4) {
                        Text("Cashback")
                            .font(.system(size: 12, weight: .light))
                            .tracking(0.48)

                        Text("₹\(viewModel.summary?.totalCashback.inrFormatted ?? "0")")
                            .font(.system(size: 14, weight: .medium))
                            .tracking(0.56)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "2E0125"))
                    .clipShape(Capsule())
                }
            }
            .padding(.bottom, 24)
        }
        .frame(height: 331)
    }

    // MARK: - Spending So Far Card

    private var spendingCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Spending so far")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(hex: "F1F8FF"))

                Spacer()

                Text("₹\(totalSpend)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                    .tracking(0.64)
            }

            HStack {
                Text("vs last month")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "877D7D"))

                Spacer()

                Text("+₹342")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "FF720C"))
            }
        }
        .padding(16)
        .background(Color(hex: "0D0D0D"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "1C1C1C"), lineWidth: 1)
        )
        .padding(.horizontal, 12)
        .padding(.top, -28)
    }

    // MARK: - Section Label

    private func sectionLabel(_ title: String) -> some View {
        HStack(spacing: 7) {
            sectionLine
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color(hex: "747474"))
                .tracking(0.48)
                .textCase(.uppercase)
            sectionLine
        }
        .padding(.horizontal, 24)
    }

    private var sectionLine: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [Color.white.opacity(0), Color.white.opacity(0.15), Color.white.opacity(0)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 0.5)
    }

    // MARK: - Icon Box

    private func iconBox(systemName: String) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                RadialGradient(
                    colors: [Color(hex: "2C2C2C"), Color(hex: "1C1C1C"), Color(hex: "0C0C0C")],
                    center: .top,
                    startRadius: 0,
                    endRadius: 36
                )
            )
            .frame(width: 36, height: 36)
            .overlay(
                Image(systemName: systemName)
                    .font(.system(size: 14))
                    .foregroundStyle(Color(hex: "8F97A3"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.25)
            )
    }

    private func merchantBox(name: String) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                RadialGradient(
                    colors: [Color(hex: "2C2C2C"), Color(hex: "1C1C1C"), Color(hex: "0C0C0C")],
                    center: .top,
                    startRadius: 0,
                    endRadius: 36
                )
            )
            .frame(width: 36, height: 36)
            .overlay(
                Text(String(name.prefix(1)))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(hex: "8F97A3"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.25)
            )
    }

    // MARK: - Category Row

    private func categoryRow(_ category: CategoryBreakdown) -> some View {
        HStack(spacing: 15) {
            iconBox(systemName: Self.categoryIcons[category.name] ?? "square.grid.2x2.fill")

            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(hex: "8F97A3"))

                Text(String(format: "%.2f%%", category.percent))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.white)
                    .tracking(0.4)
            }

            Spacer()

            Text("₹\(category.amount.inrFormatted)")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
                .tracking(0.56)
        }
    }

    // MARK: - Top Spends

    private var visibleCategories: [CategoryBreakdown] {
        showAllCategories ? Array(viewModel.breakdown) : Array(viewModel.breakdown.prefix(3))
    }

    private var topSpendsCard: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                ForEach(Array(visibleCategories.enumerated()), id: \.element.name) { index, category in
                    categoryRow(category)
                        .padding(.vertical, 14)

                    if index < visibleCategories.count - 1 {
                        Rectangle()
                            .fill(Color(hex: "252525"))
                            .frame(height: 1)
                    }
                }
            }
            .padding(.horizontal, 16)
            .animation(.easeInOut(duration: 0.3), value: showAllCategories)

            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showAllCategories.toggle()
                }
            } label: {
                Text(showAllCategories ? "SHOW LESS" : "VIEW ALL")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "8F97A3"))
                    .textCase(.uppercase)
                    .contentTransition(.numericText())
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .overlay(
                        Rectangle()
                            .fill(Color(hex: "252525"))
                            .frame(height: 1),
                        alignment: .top
                    )
            }
            .buttonStyle(.plain)
        }
        .background(Color(hex: "0D0D0D"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "1C1C1C"), lineWidth: 1)
        )
        .padding(.horizontal, 12)
    }

    // MARK: - Recurring

    private var recurringCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.recurring.enumerated()), id: \.element.payeeName) { index, merchant in
                HStack(spacing: 15) {
                    merchantBox(name: merchant.payeeName)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(merchant.payeeName)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color(hex: "8F97A3"))

                        Text("Avg ₹\(merchant.avgAmount.inrFormatted) per \(merchant.txnCount) transactions")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.white)
                            .tracking(0.4)
                    }

                    Spacer()

                    Text("₹\(merchant.totalAmount.inrFormatted)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .tracking(0.56)
                }
                .padding(.vertical, 14)

                if index < viewModel.recurring.count - 1 {
                    Rectangle()
                        .fill(Color(hex: "2A2A2A"))
                        .frame(height: 1)
                }
            }
        }
        .padding(.horizontal, 16)
        .background(Color(hex: "0D0D0D"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "1C1C1C"), lineWidth: 1)
        )
        .padding(.horizontal, 12)
    }

    // MARK: - Cashback Promo

    private var cashbackPromo: some View {
        Image("cashback image")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 17))
            .padding(.horizontal, 13)
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroHeader

                if viewModel.summary != nil {
                    spendingCard
                }

                if !viewModel.breakdown.isEmpty {
                    sectionLabel("Top 3 Spends")
                        .padding(.top, 60)
                        .padding(.bottom, 24)

                    topSpendsCard
                }

                if !viewModel.recurring.isEmpty {
                    sectionLabel("Recurring")
                        .padding(.top, 60)
                        .padding(.bottom, 24)

                    recurringCard
                }

                cashbackPromo
                    .padding(.top, 60)

                Spacer().frame(height: 60)
            }
        }
        .scrollIndicators(.hidden)
        .overlay(alignment: .topLeading) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(POPTheme.textPrimary)
                    .frame(width: 27, height: 27)
            }
            .padding(.leading, 16)
            .padding(.top, 65)
        }
        .background(POPTheme.bg)
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 80 && abs(value.translation.height) < 100 {
                        dismiss()
                    }
                }
        )
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
