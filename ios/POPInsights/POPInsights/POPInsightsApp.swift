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
    @State private var hideTabBar = false
    @Namespace private var tabAnimation

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0:
                    NavigationStack {
                        HomeView(viewModel: viewModel, showUserPicker: $showUserPicker, hideTabBar: $hideTabBar)
                    }
                case 1:
                    PlaceholderView(icon: "bag.fill", title: "Shop")
                default:
                    PlaceholderView(icon: "creditcard.fill", title: "Card")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if !hideTabBar {
                POPTabBar(selectedTab: $selectedTab, namespace: tabAnimation)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: hideTabBar)
        .ignoresSafeArea(.keyboard)
        .fullScreenCover(isPresented: $showUserPicker) {
            UserPickerView(
                users: viewModel.users,
                selectedId: viewModel.selectedUser?.id,
                onSelect: { user in
                    viewModel.selectedUser = user
                    showUserPicker = false
                    Task { await viewModel.loadUserData(userId: user.id) }
                },
                onDismiss: { showUserPicker = false }
            )
        }
        .task {
            await viewModel.loadUsers()
        }
    }
}

// MARK: - Custom Tab Bar

struct POPTabBar: View {
    @Binding var selectedTab: Int
    var namespace: Namespace.ID

    private let tabs: [(icon: String, activeIcon: String, label: String)] = [
        ("home", "home_active", "Home"),
        ("shop", "shop_active", "Shop"),
        ("card", "card_active", "Card"),
    ]

    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 0) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) { selectedTab = index }
                    } label: {
                        VStack(spacing: 4) {
                            Image(selectedTab == index ? tab.activeIcon : tab.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)

                            Text(tab.label)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(selectedTab == index ? Color(hex: "E6E7E7") : Color(hex: "4D4D4D"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .background(
                            Group {
                                if selectedTab == index {
                                    RoundedRectangle(cornerRadius: 32)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color(hex: "2E2E2E"), Color(hex: "1B1B1B")],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .matchedGeometryEffect(id: "highlight", in: namespace)
                                }
                            }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(3)
            .frame(width: 283, height: 55)
            .background(
                LinearGradient(
                    colors: [Color(hex: "2F2F2F"), Color(hex: "0E0E0E")],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(Color.white.opacity(0.04), lineWidth: 1)
            )

            Button {
            } label: {
                Image("scan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 21.5, height: 18)
            }
            .frame(width: 56, height: 56)
            .background(
                LinearGradient(
                    colors: [Color(hex: "EDEDED"), Color(hex: "A3A3A3")],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(Color.white.opacity(0.04), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
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
                .foregroundStyle(POPTheme.textPrimary)
            Text("Coming soon")
                .font(.system(size: 14))
                .foregroundStyle(POPTheme.textMuted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(POPTheme.bg)
    }
}

// MARK: - User Picker Sheet

struct UserPickerView: View {
    let users: [UserInfo]
    let selectedId: String?
    let onSelect: (UserInfo) -> Void
    let onDismiss: () -> Void

    @State private var highlighted: String?

    private static let gradients: [[Color]] = [
        [Color(hex: "FF720C"), Color(hex: "CB1400")],
        [Color(hex: "6366F1"), Color(hex: "4338CA")],
        [Color(hex: "22C55E"), Color(hex: "15803D")],
        [Color(hex: "F59E0B"), Color(hex: "D97706")],
        [Color(hex: "EC4899"), Color(hex: "BE185D")],
        [Color(hex: "06B6D4"), Color(hex: "0E7490")],
        [Color(hex: "8B5CF6"), Color(hex: "6D28D9")],
        [Color(hex: "EF4444"), Color(hex: "B91C1C")],
    ]

    private func gradientFor(_ user: UserInfo) -> [Color] {
        let index = abs(user.id.hashValue) % Self.gradients.count
        return Self.gradients[index]
    }

    private var activeId: String? {
        highlighted ?? selectedId
    }

    private var activeUser: UserInfo? {
        users.first { $0.id == activeId }
    }

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button { onDismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(POPTheme.textSecondary)
                        .frame(width: 32, height: 32)
                }
                Spacer()
                Text("Switch User")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(POPTheme.textPrimary)
                Spacer()
                Color.clear.frame(width: 32, height: 32)
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
            .padding(.bottom, 16)

            // Selected user preview
            if let user = activeUser {
                let colors = gradientFor(user)
                VStack(spacing: 16) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: colors,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image("avatar")
                                .resizable()
                                .scaledToFill()
                                .offset(y: 8)
                                .frame(width: 44, height: 44)
                        )
                        .clipShape(Circle())
                        .shadow(color: colors[0].opacity(0.4), radius: 20, y: 4)

                    VStack(spacing: 4) {
                        Text(user.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(POPTheme.textPrimary)
                            .contentTransition(.numericText())

                        Text(user.vpa)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(POPTheme.textMuted)
                            .contentTransition(.numericText())
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: activeId)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }

            // Divider
            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 1)
                .padding(.horizontal, 20)

            // User grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(users) { user in
                        let isActive = user.id == activeId
                        let colors = gradientFor(user)

                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                highlighted = user.id
                            }
                            onSelect(user)
                        } label: {
                            VStack(spacing: 6) {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: colors,
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 48, height: 48)
                                    .overlay(
                                        Image("avatar")
                                            .resizable()
                                            .scaledToFill()
                                            .offset(y: 5)
                                            .frame(width: 26, height: 26)
                                    )
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(isActive ? .white.opacity(0.6) : .clear, lineWidth: 2)
                                            .padding(-2)
                                    )
                                    .scaleEffect(isActive ? 1.08 : 1.0)

                                Text(user.name.components(separatedBy: " ").first ?? user.name)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(isActive ? POPTheme.textPrimary : POPTheme.textSecondary)
                                    .lineLimit(1)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .background(POPTheme.bg)
        .ignoresSafeArea(edges: .top)
    }
}
