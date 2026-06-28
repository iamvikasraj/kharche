import SwiftUI

@main
struct POPInsightsApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark)
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var viewModel = SummaryViewModel()
    @State private var showUserPicker = false

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: 0) {
                NavigationStack {
                    HomeView(viewModel: viewModel, showUserPicker: $showUserPicker)
                }
            }

            Tab("Shop", systemImage: "bag.fill", value: 1) {
                PlaceholderView(icon: "bag.fill", title: "Shop")
            }

            Tab("Scan", systemImage: "qrcode.viewfinder", value: 2, role: .search) {
                Color(hex: "0D0D0D").ignoresSafeArea()
            }

            Tab("Card", systemImage: "creditcard.fill", value: 3) {
                PlaceholderView(icon: "creditcard.fill", title: "Card")
            }
        }
        .tint(Color(hex: "E6E7E7"))
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
        .task {
            await viewModel.loadUsers()
        }
    }
}

private struct PlaceholderView: View {
    let icon: String
    let title: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(Color(hex: "4D4D4D"))
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color(hex: "E5E6E6"))
            Text("Coming soon")
                .font(.system(size: 14))
                .foregroundStyle(Color(hex: "6B7280"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0D0D0D"))
    }
}

// MARK: - User Picker Sheet

struct UserPickerSheet: View {
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
