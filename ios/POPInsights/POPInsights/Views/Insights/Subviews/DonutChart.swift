import SwiftUI

struct DonutChart: View {
    let categories: [CategoryBreakdown]
    let totalSpend: Double
    var txnCount: Int = 0

    @State private var animationProgress: CGFloat = 0
    @State private var selectedIndex: Int? = nil

    private let lineWidth: CGFloat = 16
    private let gap: CGFloat = 0.008

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.03), lineWidth: lineWidth)

            ForEach(Array(sliceData.enumerated()), id: \.offset) { index, slice in
                Circle()
                    .trim(from: slice.start * animationProgress, to: slice.end * animationProgress)
                    .stroke(
                        slice.color.opacity(selectedIndex == nil || selectedIndex == index ? 1 : 0.25),
                        style: StrokeStyle(
                            lineWidth: selectedIndex == index ? lineWidth + 4 : lineWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedIndex = selectedIndex == index ? nil : index
                        }
                    }
            }

            // Glow on selected slice
            if let idx = selectedIndex, idx < sliceData.count {
                Circle()
                    .trim(from: sliceData[idx].start, to: sliceData[idx].end)
                    .stroke(
                        sliceData[idx].color,
                        style: StrokeStyle(lineWidth: lineWidth + 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .blur(radius: 10)
                    .opacity(0.3)
            }

            VStack(spacing: 4) {
                if let idx = selectedIndex, idx < categories.count {
                    Text(categories[idx].name)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(sliceData[idx].color)
                        .transition(.opacity)

                    Text("₹\(categories[idx].amount.inrFormatted)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(POPTheme.textPrimary)
                        .transition(.opacity)

                    Text("\(Int(categories[idx].percent))%")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(POPTheme.textMuted)
                        .transition(.opacity)
                } else {
                    Text("\(categories.count)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(POPTheme.textPrimary)
                        .transition(.opacity)

                    Text("Categories")
                        .font(.system(size: 11))
                        .foregroundStyle(POPTheme.textMuted)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: selectedIndex)
            .opacity(animationProgress)
        }
        .padding(24)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0).delay(0.2)) {
                animationProgress = 1
            }
        }
    }

    private var sliceData: [(start: CGFloat, end: CGFloat, color: Color)] {
        var slices: [(start: CGFloat, end: CGFloat, color: Color)] = []
        var current: CGFloat = 0
        let total = categories.reduce(0.0) { $0 + $1.amount }
        guard total > 0 else { return slices }

        for (index, cat) in categories.enumerated() {
            let fraction = CGFloat(cat.amount / total)
            let adjustedFraction = max(fraction - gap, 0.001)
            let color = POPTheme.categoryColors[index % POPTheme.categoryColors.count]
            slices.append((start: current + gap / 2, end: current + adjustedFraction + gap / 2, color: color))
            current += fraction
        }

        return slices
    }
}

#Preview("Donut") {
    DonutChart(
        categories: [
            CategoryBreakdown(name: "Supermarkets", amount: 11527, percent: 31.5),
            CategoryBreakdown(name: "Other", amount: 11351, percent: 31.0),
            CategoryBreakdown(name: "Groceries", amount: 4493, percent: 12.3),
            CategoryBreakdown(name: "Transport", amount: 4362, percent: 11.9),
            CategoryBreakdown(name: "Shopping", amount: 2217, percent: 6.1),
        ],
        totalSpend: 36605
    )
    .frame(height: 240)
    .padding()
    .background(Color(hex: "0D0D0D"))
    .preferredColorScheme(.dark)
}
