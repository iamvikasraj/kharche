import SwiftUI

struct HomeView: View {
    @State private var viewModel = SummaryViewModel()
    @State private var showUserPicker = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    heroSection
                    horizontalCards
                    everythingUPISection
                }
                .padding(.bottom, 20)
            }
            .background(Color(hex: "0D0D0D"))
            .ignoresSafeArea(edges: .top)
            .sheet(isPresented: $showUserPicker) {
                UserPickerSheet(
                    users: viewModel.users,
                    selectedId: viewModel.selectedUser?.id,
                    onSelect: { user in
                        viewModel.selectedUser = user
                        showUserPicker = false
                        Task { await viewModel.loadUserData(userId: user.id) }
                    }
                )
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color(hex: "1A1A1A"))
            }
        }
        .task {
            await viewModel.loadUsers()
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [Color(hex: "1A1A1A"), Color(hex: "0D0D0D")],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 420)

            VStack(spacing: 0) {
                HStack {
                    Button { showUserPicker = true } label: {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "FF6B2C"), Color(hex: "FF8F5C")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 36, height: 36)
                            .overlay(
                                Text(String(viewModel.selectedUser?.name.prefix(1) ?? "?"))
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.white)
                            )
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color(hex: "FF6B2C"))
                        Text("\(viewModel.summary?.totalCoins ?? 0)")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 16)
                .padding(.top, 60)

                Spacer()

                VStack(spacing: 6) {
                    Text("Hi, \(viewModel.selectedUser?.name ?? "User")")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                    if let s = viewModel.summary {
                        Text("Total Spend: ₹\(s.totalSpend.inrFormatted)")
                            .font(.system(size: 15))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                .padding(.bottom, 60)
            }
            .frame(height: 420)
        }
    }

    // MARK: - Horizontal Cards

    private var horizontalCards: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                if let s = viewModel.summary {
                    quickStatCard(
                        title: "Cashback Earned",
                        value: "₹\(s.totalCashback.inrFormatted)",
                        icon: "arrow.down.circle.fill",
                        color: Color(hex: "22C55E")
                    )
                    quickStatCard(
                        title: "Failed Transactions",
                        value: "₹\(s.failedAmount.inrFormatted)",
                        icon: "exclamationmark.triangle.fill",
                        color: Color(hex: "EF4444")
                    )
                } else {
                    quickStatCard(title: "Cashback Earned", value: "—", icon: "arrow.down.circle.fill", color: Color(hex: "22C55E"))
                    quickStatCard(title: "Failed Transactions", value: "—", icon: "exclamationmark.triangle.fill", color: Color(hex: "EF4444"))
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.top, -40)
    }

    private func quickStatCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "9CA3AF"))
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 260, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "2C2C2C"), Color(hex: "1C1C1C"), Color(hex: "0C0C0C")],
                        center: .top,
                        startRadius: 0,
                        endRadius: 120
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.25)
                )
        )
    }

    // MARK: - Everything UPI

    private var everythingUPISection: some View {
        VStack(alignment: .leading, spacing: 17) {
            HStack {
                Text("Everything UPI")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color(hex: "E5E6E6"))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color(hex: "E5E6E6"))
            }

            HStack(spacing: 33) {
                actionButton(icon: "person.2.fill", label: "Pay\nfriends")
                actionButton(icon: "building.columns.fill", label: "To bank &\nself a/c")
                actionButton(icon: "indianrupeesign.circle.fill", label: "Check\nbalance")
                NavigationLink {
                    SummaryView(viewModel: viewModel)
                } label: {
                    actionButtonContent(icon: "clock.arrow.circlepath", label: "Transaction\nhistory")
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 24)
    }

    private func actionButton(icon: String, label: String) -> some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "2C2C2C"), Color(hex: "1C1C1C"), Color(hex: "0C0C0C")],
                        center: .top,
                        startRadius: 0,
                        endRadius: 50
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.25)
                )
                .frame(width: 67, height: 67)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundStyle(Color(hex: "E5E6E6"))
                )

            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color(hex: "E5E6E6"))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 32)
        }
        .frame(width: 67)
    }

    private func actionButtonContent(icon: String, label: String) -> some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "2C2C2C"), Color(hex: "1C1C1C"), Color(hex: "0C0C0C")],
                        center: .top,
                        startRadius: 0,
                        endRadius: 50
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.25)
                )
                .frame(width: 67, height: 67)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundStyle(Color(hex: "E5E6E6"))
                )

            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color(hex: "E5E6E6"))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 32)
        }
        .frame(width: 67)
    }

}

// MARK: - User Picker Sheet

private struct UserPickerSheet: View {
    let users: [UserInfo]
    let selectedId: String?
    let onSelect: (UserInfo) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select User")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color(hex: "E5E6E6"))
                .padding(.horizontal, 20)
                .padding(.top, 8)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(users) { user in
                        Button { onSelect(user) } label: {
                            VStack(spacing: 8) {
                                Circle()
                                    .fill(
                                        user.id == selectedId
                                            ? LinearGradient(colors: [Color(hex: "FF6B2C"), Color(hex: "FF8F5C")], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.08)], startPoint: .top, endPoint: .bottom)
                                    )
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text(String(user.name.prefix(1)))
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundStyle(user.id == selectedId ? .white : Color(hex: "9CA3AF"))
                                    )

                                Text(user.name.components(separatedBy: " ").first ?? user.name)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(Color(hex: "9CA3AF"))
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(user.id == selectedId ? Color(hex: "FF6B2C").opacity(0.12) : Color.white.opacity(0.04))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                user.id == selectedId ? Color(hex: "FF6B2C").opacity(0.4) : Color.white.opacity(0.1),
                                                lineWidth: 0.25
                                            )
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
    }
}

#Preview {
    HomeView()
}
