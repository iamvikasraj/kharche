import SwiftUI

struct SummaryView: View {
    let viewModel: SummaryViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            recentTransactionsSection
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 100)
    }

    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Transactions")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(POPTheme.textPrimary)

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
            .popCard()
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
                    .foregroundStyle(POPTheme.textPrimary)
                Text("\(transaction.category) · \(dateFormatted)")
                    .font(.system(size: 11))
                    .foregroundStyle(POPTheme.textMuted)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("₹\(transaction.amount.inrFormatted)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isFailed ? POPTheme.red : POPTheme.textPrimary)
                if isFailed {
                    Text("Failed")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(POPTheme.red)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var categoryColor: Color {
        let colors = POPTheme.categoryColors
        let map: [String: Color] = [
            "Groceries": colors[0], "Food & Dining": colors[1], "Travel": colors[2],
            "Shopping": colors[3], "Tech": colors[4], "Healthcare": colors[5],
            "Fashion": colors[6], "Transport": colors[7], "Supermarkets": colors[8], "Other": colors[9],
        ]
        return map[transaction.category] ?? POPTheme.accent
    }
}

#Preview("Summary") {
    @Previewable @State var viewModel = SummaryViewModel()
    ScrollView {
        SummaryView(viewModel: viewModel)
    }
    .scrollIndicators(.hidden)
    .task { await viewModel.loadUsers() }
    .background(POPTheme.bg)
    .preferredColorScheme(.dark)
}
