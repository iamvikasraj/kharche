import SwiftUI

struct RecurringView: View {
    let viewModel: SummaryViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Recurring")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(POPTheme.textPrimary)
                Text("Frequent merchants")
                    .font(.system(size: 14))
                    .foregroundStyle(POPTheme.textSecondary)
            }

            if viewModel.recurring.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 32))
                        .foregroundStyle(Color(hex: "4D4D4D"))
                    Text("No recurring merchants found")
                        .font(.system(size: 14))
                        .foregroundStyle(POPTheme.textMuted)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.recurring.enumerated()), id: \.element.id) { index, merchant in
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(POPTheme.accent.opacity(0.12))
                                    .frame(width: 40, height: 40)
                                Text(String(merchant.payeeName.prefix(1)))
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(POPTheme.accent)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(merchant.payeeName)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(POPTheme.textPrimary)
                                Text("\(merchant.txnCount) txns · avg ₹\(merchant.avgAmount.inrFormatted)")
                                    .font(.system(size: 11))
                                    .foregroundStyle(POPTheme.textMuted)
                            }

                            Spacer()

                            Text("₹\(merchant.totalAmount.inrFormatted)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(POPTheme.textPrimary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)

                        if index < viewModel.recurring.count - 1 {
                            Divider().background(Color.white.opacity(0.06)).padding(.horizontal, 16)
                        }
                    }
                }
                .popCard()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 100)
    }
}

#Preview("Recurring") {
    @Previewable @State var viewModel = SummaryViewModel()
    ScrollView {
        RecurringView(viewModel: viewModel)
    }
    .scrollIndicators(.hidden)
    .task { await viewModel.loadUsers() }
    .background(POPTheme.bg)
    .preferredColorScheme(.dark)
}
