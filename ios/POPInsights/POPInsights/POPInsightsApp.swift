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

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: 0) {
                HomeView()
            }

            Tab("Shop", systemImage: "bag.fill", value: 1) {
                Color(hex: "0D0D0D")
                    .ignoresSafeArea()
            }

            Tab("Scan", systemImage: "qrcode.viewfinder", value: 2, role: .search) {
                Color(hex: "0D0D0D")
                    .ignoresSafeArea()
            }

            Tab("Card", systemImage: "creditcard.fill", value: 3) {
                Color(hex: "0D0D0D")
                    .ignoresSafeArea()
            }
        }
        .tint(Color(hex: "FF6B2C"))
    }
}
