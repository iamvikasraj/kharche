import Foundation

@MainActor
@Observable
final class SummaryViewModel {
    var users: [UserInfo] = []
    var selectedUser: UserInfo?
    var summary: SummaryData?
    var breakdown: [CategoryBreakdown] = []
    var trends: [MonthTrend] = []
    var recurring: [RecurringMerchant] = []
    var recentTransactions: [Transaction] = []
    var isLoading = true
    var errorMessage: String?

    private let baseURL = "https://server-production-dd0d.up.railway.app/api"

    func loadUsers() async {
        do {
            let data = try await fetch("\(baseURL)/users")
            let response = try JSONDecoder().decode(UsersResponse.self, from: data)
            users = response.users.map { UserInfo(id: $0.id, name: $0.name, vpa: $0.vpa) }
            if let first = users.first {
                selectedUser = first
                await loadUserData(userId: first.id)
            }
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    func loadUserData(userId: String) async {
        isLoading = true
        errorMessage = nil

        async let summaryTask = fetch("\(baseURL)/users/\(userId)/summary")
        async let breakdownTask = fetch("\(baseURL)/users/\(userId)/breakdown")
        async let trendsTask = fetch("\(baseURL)/users/\(userId)/trends")
        async let recurringTask = fetch("\(baseURL)/users/\(userId)/recurring")
        async let txnTask = fetch("\(baseURL)/users/\(userId)/transactions?limit=5")

        do {
            let (summaryData, breakdownData, trendsData, recurringData, txnData) = try await (summaryTask, breakdownTask, trendsTask, recurringTask, txnTask)

            let sr = try JSONDecoder().decode(SummaryResponse.self, from: summaryData)
            summary = SummaryData(
                totalSpend: Double(sr.totalSpend) ?? 0,
                totalCashback: Double(sr.totalCashback) ?? 0,
                totalCoins: sr.totalCoins,
                failedAmount: Double(sr.failedAmount) ?? 0,
                txnCount: sr.txnCount
            )

            let br = try JSONDecoder().decode(BreakdownResponse.self, from: breakdownData)
            breakdown = br.categories.map {
                CategoryBreakdown(name: $0.name, amount: Double($0.amount) ?? 0, percent: Double($0.percent) ?? 0)
            }

            let trendRes = try JSONDecoder().decode(TrendsResponse.self, from: trendsData)
            trends = trendRes.months.map {
                MonthTrend(month: $0.month, spend: Double($0.spend) ?? 0, cashback: Double($0.cashback) ?? 0)
            }

            let recRes = try JSONDecoder().decode(RecurringResponse.self, from: recurringData)
            recurring = recRes.recurring.map {
                RecurringMerchant(payeeName: $0.payeeName, txnCount: $0.txnCount, avgAmount: Double($0.avgAmount) ?? 0, totalAmount: Double($0.totalAmount) ?? 0)
            }

            let tr = try JSONDecoder().decode(TransactionsResponse.self, from: txnData)
            let iso = ISO8601DateFormatter()
            iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let isoBasic = ISO8601DateFormatter()
            isoBasic.formatOptions = [.withInternetDateTime]

            recentTransactions = tr.transactions.map { t in
                Transaction(
                    id: t.id,
                    payeeName: t.payeeName,
                    amount: Double(t.amount) ?? 0,
                    status: t.status,
                    category: t.category,
                    cashback: Double(t.cashback ?? "0") ?? 0,
                    coinsEarned: Int(t.coinsEarned ?? "0") ?? 0,
                    transactedAt: iso.date(from: t.transactedAt) ?? isoBasic.date(from: t.transactedAt) ?? Date()
                )
            }

            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    private nonisolated func fetch(_ urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

extension Double {
    var inrFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_IN")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "\(Int(self))"
    }
}
