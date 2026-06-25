import SwiftUI

private let categoryColors: [Color] = [
    Color(hex: "FF6B2C"), Color(hex: "22C55E"), Color(hex: "F59E0B"), Color(hex: "3B82F6"),
    Color(hex: "8B5CF6"), Color(hex: "EC4899"), Color(hex: "14B8A6"), Color(hex: "F97316"),
    Color(hex: "06B6D4"), Color(hex: "84CC16"),
]

struct SummaryView: View {
    let viewModel: SummaryViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                greetingSection
                statsGrid
                breakdownSection
                recentTransactionsSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(hex: "0D0D0D"))
        .navigationTitle("Transaction History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: - Greeting

    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hi, \(viewModel.selectedUser?.name ?? "User")")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(hex: "E5E6E6"))
            Text("Here's your financial overview")
                .font(.system(size: 15))
                .foregroundStyle(Color(hex: "9CA3AF"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Stats Grid

    private var statsGrid: some View {
        let s = viewModel.summary
        let cards: [(String, String, Color)] = [
            ("Total Spend", "₹\(s?.totalSpend.inrFormatted ?? "0")", Color(hex: "EF4444")),
            ("Cashback", "₹\(s?.totalCashback.inrFormatted ?? "0")", Color(hex: "22C55E")),
            ("Coins Earned", "\(s?.totalCoins ?? 0)", Color(hex: "F59E0B")),
            ("Failed Txns", "₹\(s?.failedAmount.inrFormatted ?? "0")", Color(hex: "6B7280")),
        ]

        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(Array(cards.enumerated()), id: \.offset) { _, card in
                StatCard(label: card.0, value: card.1, color: card.2)
            }
            StatCard(
                label: "Transactions",
                value: "\(s?.txnCount ?? 0)",
                color: Color(hex: "FF6B2C")
            )
        }
    }

    // MARK: - Breakdown

    private var breakdownSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Spending Breakdown")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color(hex: "E5E6E6"))

            let maxAmount = viewModel.breakdown.map(\.amount).max() ?? 1

            VStack(spacing: 0) {
                ForEach(Array(viewModel.breakdown.enumerated()), id: \.element.id) { index, cat in
                    CategoryRow(
                        category: cat,
                        color: categoryColors[index % categoryColors.count],
                        maxAmount: maxAmount
                    )
                    if index < viewModel.breakdown.count - 1 {
                        Divider().padding(.horizontal, 16)
                    }
                }
            }
            .background(Color(hex: "1C1C1C"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.2), lineWidth: 0.25))
        }
    }

    // MARK: - Recent Transactions

    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Transactions")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color(hex: "E5E6E6"))

            VStack(spacing: 0) {
                ForEach(Array(viewModel.recentTransactions.enumerated()), id: \.element.id) { index, txn in
                    TransactionRow(transaction: txn)
                    if index < viewModel.recentTransactions.count - 1 {
                        Divider().padding(.horizontal, 16)
                    }
                }
            }
            .background(Color(hex: "1C1C1C"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.2), lineWidth: 0.25))
        }
        .padding(.bottom, 20)
    }
}

// MARK: - Stat Card

private struct StatCard: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color(hex: "9CA3AF"))
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(hex: "1C1C1C"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.2), lineWidth: 0.25))
    }
}

// MARK: - Category Row

private struct CategoryRow: View {
    let category: CategoryBreakdown
    let color: Color
    let maxAmount: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                Text(category.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(hex: "E5E6E6"))
                Spacer()
                Text("₹\(category.amount.inrFormatted)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(hex: "E5E6E6"))
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geo.size.width * (category.amount / maxAmount), height: 6)
                }
            }
            .frame(height: 6)
            Text("\(String(format: "%.1f", category.percent))%")
                .font(.system(size: 11))
                .foregroundStyle(Color(hex: "6B7280"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Transaction Row

private struct TransactionRow: View {
    let transaction: Transaction

    private var isFailed: Bool { transaction.status == "failed" }

    private var dateFormatted: String {
        let f = DateFormatter()
        f.dateFormat = "dd MMM, h:mm a"
        return f.string(from: transaction.transactedAt)
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.12))
                    .frame(width: 40, height: 40)
                Text(String(transaction.payeeName.prefix(1)))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(categoryColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.payeeName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(hex: "E5E6E6"))
                Text("\(transaction.category) · \(dateFormatted)")
                    .font(.system(size: 11))
                    .foregroundStyle(Color(hex: "6B7280"))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("₹\(transaction.amount.inrFormatted)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isFailed ? Color(hex: "EF4444") : Color(hex: "E5E6E6"))
                if isFailed {
                    Text("Failed")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(hex: "EF4444"))
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var categoryColor: Color {
        let map: [String: Color] = [
            "Groceries": categoryColors[0],
            "Food & Dining": categoryColors[1],
            "Travel": categoryColors[2],
            "Shopping": categoryColors[3],
            "Tech": categoryColors[4],
            "Healthcare": categoryColors[5],
            "Fashion": categoryColors[6],
            "Transport": categoryColors[7],
            "Supermarkets": categoryColors[8],
            "Other": categoryColors[9],
        ]
        return map[transaction.category] ?? Color(hex: "FF6B2C")
    }
}

#Preview {
    SummaryView(viewModel: SummaryViewModel())
}
