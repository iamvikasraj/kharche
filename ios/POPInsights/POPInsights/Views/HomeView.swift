import SwiftUI

struct HomeView: View {
    let viewModel: SummaryViewModel
    @Binding var showUserPicker: Bool

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 0) {
                    heroSection
                    bannerCards
                    everythingUPISection
                    upiPillsSection
                    rechargesSection
                    whatMoreSection
                    featuredSection
                }
                .padding(.bottom, 120)
            }

            // Sticky top bar
            HStack {
                Button { showUserPicker = true } label: {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "FF720C"), Color(hex: "CB1400")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 32, height: 32)
                        .overlay(
                            Circle()
                                .stroke(Color(hex: "793F29"), lineWidth: 0.4)
                        )
                }

                Spacer()

                HStack(spacing: 4) {
                    Image("PopCoin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .clipShape(Circle())
                }
                .frame(width: 43, height: 28)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            RadialGradient(
                                colors: [Color(hex: "2C2C2C"), Color(hex: "1C1C1C"), Color(hex: "0C0C0C")],
                                center: .top,
                                startRadius: 0,
                                endRadius: 30
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.2), lineWidth: 0.25)
                        )
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 65)
        }
        .ignoresSafeArea(edges: .top)
        .background(Color(hex: "0D0D0D"))
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        Image("hero")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
    }

    // MARK: - Banner Cards

    private var bannerCards: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Image("banner 1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 86)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                ForEach(0..<2, id: \.self) { _ in
                    Image("banner 1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 86)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.top, -40)
    }

    // MARK: - Everything UPI

    private var everythingUPISection: some View {
        VStack(alignment: .leading, spacing: 17) {
            HStack {
                Text("Everything UPI")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color(hex: "E5E6E6"))
                    .tracking(-0.36)
                Spacer()
                Image("ChevronRight")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 4.5, height: 9)
            }

            HStack(spacing: 33) {
                upiButton(image: "IconPayFriends", label: "Pay\nfriends")
                upiButton(image: "IconBank", label: "To bank &\nself a/c")
                upiButton(image: "IconBalance", label: "Check\nbalance")
                NavigationLink {
                    InsightsView(viewModel: viewModel)
                } label: {
                    upiButtonContent(image: "IconInsights", label: "Pop\nInsights")
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 30)
    }

    private func upiButton(image: String, label: String) -> some View {
        upiButtonContent(image: image, label: label)
    }

    private func upiButtonContent(image: String, label: String) -> some View {
        VStack(spacing: 10) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 67, height: 67)

            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color(hex: "E6E7E7"))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 32)
        }
        .frame(width: 67)
    }

    // MARK: - UPI Pills

    private var upiPillsSection: some View {
        HStack(spacing: 14) {
            pillView(text: viewModel.selectedUser?.vpa ?? "user@yespop")
            HStack(spacing: 4) {
                Text("UPI Lite")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "B3B3B3"))
                Circle()
                    .fill(Color(hex: "B3B3B3"))
                    .frame(width: 4, height: 4)
                Text("Activate")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "B3B3B3"))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: "2C2C2C"), Color(hex: "1C1C1C"), Color(hex: "0C0C0C")],
                            center: .top,
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.2), lineWidth: 0.25)
                    )
            )
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }

    private func pillView(text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(Color(hex: "B3B3B3"))
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: "2C2C2C"), Color(hex: "1C1C1C"), Color(hex: "0C0C0C")],
                            center: .top,
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.2), lineWidth: 0.25)
                    )
            )
    }

    // MARK: - Recharges

    private var rechargesSection: some View {
        VStack(alignment: .leading, spacing: 17) {
            HStack {
                Text("Recharges and bills")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color(hex: "E5E6E6"))
                    .tracking(-0.54)
                Spacer()
                Image("ChevronRight")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 4.5, height: 9)
            }

            HStack(spacing: 12) {
                rechargeCard(
                    label: "Mobile prepaid",
                    leftColor: Color(hex: "003427"),
                    rightColor: Color(hex: "003427")
                )
                rechargeCard(
                    label: "Mobile prepaid",
                    leftColor: Color(hex: "3B054E"),
                    rightColor: Color(hex: "46035D")
                )
                rechargeCard(
                    label: "Mobile postpaid",
                    leftColor: Color(hex: "3B054E"),
                    rightColor: Color(hex: "46035D")
                )
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 28)
    }

    private func rechargeCard(label: String, leftColor: Color, rightColor: Color) -> some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black)
                .overlay(
                    ZStack {
                        RadialGradient(
                            colors: [leftColor, Color(hex: "0C0C0C").opacity(0)],
                            center: .leading,
                            startRadius: 0,
                            endRadius: 80
                        )
                        RadialGradient(
                            colors: [rightColor, Color(hex: "0C0C0C").opacity(0)],
                            center: .trailing,
                            startRadius: 0,
                            endRadius: 80
                        )
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.25)
                )

            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color(hex: "BABABA"))
                .padding(.bottom, 10)
        }
        .frame(width: 115, height: 128)
    }

    // MARK: - What More

    private var whatMoreSection: some View {
        Image("WhatMore")
            .resizable()
            .scaledToFit()
            .frame(width: 193)
            .frame(maxWidth: .infinity)
            .padding(.top, 48)
    }

    // MARK: - Featured Card

    private var featuredSection: some View {
        FeaturedCarousel()
            .padding(.top, 40)
    }
}

// MARK: - Featured Carousel

private struct FeaturedCarousel: View {
    @State private var currentPage = 0
    private let pageCount = 6

    var body: some View {
        VStack(spacing: 20) {
            TabView(selection: $currentPage) {
                ForEach(0..<pageCount, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.2), lineWidth: 0.25)
                        )
                        .padding(.horizontal, 13)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 360)

            HStack(spacing: 6) {
                ForEach(0..<pageCount, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color(hex: "E6E7E7") : Color(hex: "3A3A3A"))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
}

#Preview {
    MainTabView()
}
