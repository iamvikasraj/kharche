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
            VStack(alignment: .leading, spacing: 20) {
                titleSection
                heroCard
                statsGrid
                recentTransactionsSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(Color(hex: "0D0D0D"))
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Overview")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(hex: "E5E6E6"))
            Text("\(viewModel.summary?.txnCount ?? 0) transactions")
                .font(.system(size: 14))
                .foregroundStyle(Color(hex: "9CA3AF"))
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TOTAL SPEND")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.white.opacity(0.8))
                .tracking(0.5)
            Text("₹\(viewModel.summary?.totalSpend.inrFormatted ?? "0")")
                .font(.system(size: 36, weight: .heavy))
                .foregroundStyle(.white)
                .tracking(-1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            LinearGradient(
                colors: [Color(hex: "FF6B2C"), Color(hex: "FF8F5C")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.2), lineWidth: 0.25)
        )
    }

    private var statsGrid: some View {
        let s = viewModel.summary
        let cards: [(String, String, Color)] = [
            ("Cashback", "₹\(s?.totalCashback.inrFormatted ?? "0")", Color(hex: "22C55E")),
            ("POPcoins", "\(s?.totalCoins ?? 0)", Color(hex: "F59E0B")),
            ("Failed", "₹\(s?.failedAmount.inrFormatted ?? "0")", Color(hex: "EF4444")),
        ]

        return HStack(spacing: 10) {
            ForEach(Array(cards.enumerated()), id: \.offset) { _, card in
                VStack(alignment: .leading, spacing: 8) {
                    Text(card.0.uppercased())
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Color(hex: "9CA3AF"))
                        .tracking(0.3)
                    Text(card.1)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(card.2)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(Color(hex: "1C1C1C"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.25)
                )
            }
        }
    }

    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Transactions")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color(hex: "E5E6E6"))

            VStack(spacing: 0) {
                ForEach(Array(viewModel.recentTransactions.enumerated()), id: \.element.id) { index, txn in
                    TransactionRow(transaction: txn)
                    if index < viewModel.recentTransactions.count - 1 {
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
}

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
