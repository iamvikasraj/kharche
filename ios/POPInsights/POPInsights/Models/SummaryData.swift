import Foundation

struct SummaryData {
    let totalSpend: Double
    let totalCashback: Double
    let totalCoins: Int
    let failedAmount: Double
    let txnCount: Int
}

struct CategoryBreakdown: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let percent: Double
}

struct Transaction: Identifiable {
    let id: String
    let payeeName: String
    let amount: Double
    let status: String
    let category: String
    let cashback: Double
    let coinsEarned: Int
    let transactedAt: Date
}

struct UserInfo: Identifiable {
    let id: String
    let name: String
    let vpa: String
}

struct MonthTrend: Identifiable {
    let id = UUID()
    let month: String
    let spend: Double
    let cashback: Double

    var monthLabel: String {
        String(month.suffix(2))
    }
}

struct RecurringMerchant: Identifiable {
    let id = UUID()
    let payeeName: String
    let txnCount: Int
    let avgAmount: Double
    let totalAmount: Double
}

// MARK: - API Response Codables

struct UsersResponse: Codable {
    let users: [UserDTO]
}

struct UserDTO: Codable {
    let id: String
    let name: String
    let vpa: String
}

struct SummaryResponse: Codable {
    let totalSpend: String
    let totalCashback: String
    let totalCoins: Int
    let failedAmount: String
    let txnCount: Int
}

struct BreakdownResponse: Codable {
    let categories: [CategoryDTO]
}

struct CategoryDTO: Codable {
    let name: String
    let amount: String
    let percent: String
}

struct TransactionsResponse: Codable {
    let transactions: [TransactionDTO]
}

struct TransactionDTO: Codable {
    let id: String
    let payeeName: String
    let amount: String
    let status: String
    let category: String
    let cashback: String?
    let coinsEarned: String?
    let transactedAt: String
}

struct TrendsResponse: Codable {
    let months: [MonthDTO]
}

struct MonthDTO: Codable {
    let month: String
    let spend: String
    let cashback: String
}

struct RecurringResponse: Codable {
    let recurring: [RecurringDTO]
}

struct RecurringDTO: Codable {
    let payeeName: String
    let txnCount: Int
    let avgAmount: String
    let totalAmount: String
}
