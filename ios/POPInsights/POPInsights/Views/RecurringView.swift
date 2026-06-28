import SwiftUI

struct RecurringView: View {
    let viewModel: SummaryViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recurring")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color(hex: "E5E6E6"))
                    Text("Frequent merchants")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "9CA3AF"))
                }

                if viewModel.recurring.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 32))
                            .foregroundStyle(Color(hex: "4D4D4D"))
                        Text("No recurring merchants found")
                            .font(.system(size: 14))
                            .foregroundStyle(Color(hex: "6B7280"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 60)
                } else {
                    VStack(spacing: 0) {
                        ForEach(Array(viewModel.recurring.enumerated()), id: \.element.id) { index, merchant in
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "FF6B2C").opacity(0.12))
                                        .frame(width: 40, height: 40)
                                    Text(String(merchant.payeeName.prefix(1)))
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(Color(hex: "FF6B2C"))
                                }

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(merchant.payeeName)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(Color(hex: "E5E6E6"))
                                    Text("\(merchant.txnCount) txns · avg ₹\(merchant.avgAmount.inrFormatted)")
                                        .font(.system(size: 11))
                                        .foregroundStyle(Color(hex: "6B7280"))
                                }

                                Spacer()

                                Text("₹\(merchant.totalAmount.inrFormatted)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color(hex: "E5E6E6"))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)

                            if index < viewModel.recurring.count - 1 {
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
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(Color(hex: "0D0D0D"))
    }
}
