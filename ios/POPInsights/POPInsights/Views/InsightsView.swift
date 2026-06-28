import SwiftUI

struct InsightsView: View {
    let viewModel: SummaryViewModel
    @State private var selectedTab = 0
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            header

            TabView(selection: $selectedTab) {
                SummaryView(viewModel: viewModel)
                    .tag(0)
                BreakdownView(viewModel: viewModel)
                    .tag(1)
                TrendsView(viewModel: viewModel)
                    .tag(2)
                RecurringView(viewModel: viewModel)
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxHeight: .infinity)

            bottomNav
        }
        .background(Color(hex: "0D0D0D"))
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
    }

    private var header: some View {
        HStack(spacing: 12) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(hex: "E5E6E6"))
                    .frame(width: 32, height: 32)
            }
            Text("Pop Insights")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color(hex: "E5E6E6"))
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var bottomNav: some View {
        HStack(spacing: 0) {
            navTab(icon: "square.grid.2x2", label: "Summary", tag: 0)
            navTab(icon: "circle.grid.cross", label: "Breakdown", tag: 1)
            navTab(icon: "chart.line.uptrend.xyaxis", label: "Trends", tag: 2)
            navTab(icon: "arrow.counterclockwise", label: "Recurring", tag: 3)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "2F2F2F").opacity(0.85), Color(hex: "0E0E0E").opacity(0.95)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 34)
    }

    private func navTab(icon: String, label: String, tag: Int) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) { selectedTab = tag }
        } label: {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(label)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundStyle(selectedTab == tag ? Color(hex: "E6E7E7") : Color.white.opacity(0.25))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                selectedTab == tag
                    ? AnyShapeStyle(
                        LinearGradient(
                            colors: [Color.white.opacity(0.12), Color.white.opacity(0.04)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    : AnyShapeStyle(Color.clear)
            )
            .clipShape(Capsule())
            .overlay(
                selectedTab == tag
                    ? Capsule().stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                    : nil
            )
        }
    }
}
