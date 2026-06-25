# POP Insights — UPI Financial Insights

A full-stack financial insights product built for POP's UPI transaction data. Helps users understand their spending patterns, recurring expenses, and financial behavior through an intuitive mobile-first interface.

**Live Web App:** [https://client-three-cyan-80.vercel.app](https://client-three-cyan-80.vercel.app)
**Design File:** [Figma](https://www.figma.com/design/sjRkyjz7u5fB6NByTHohwK/Design?node-id=3-17)

---

## Product Thinking

### User Analysis

After analyzing the synthetic dataset (150 users, ~20K transactions), I identified key patterns:

- **Diverse spending profiles** — users range from ₹5K to ₹2L+ in total spend, with most spending concentrated in Supermarkets, Groceries, and Transport categories
- **Recurring merchant behavior** — most users have 3-5 merchants they transact with repeatedly (Ola Cabs, PharmEasy, Paytm Mall are common), signaling habitual spending
- **Non-trivial failure rates** — some users have significant failed transaction amounts, making this a valuable insight to surface
- **Cashback & rewards engagement** — POPcoins and cashback are earned across transactions, and surfacing these reinforces POP's value proposition

### Chosen Insights

I prioritized insights that answer the questions users actually care about:

1. **Overview/Summary** — "How much have I spent, earned back, and lost to failures?" — the first thing any user wants at a glance
2. **Category Breakdown** — "Where is my money going?" — helps users identify their largest spending buckets
3. **Monthly Trends** — "Am I spending more or less over time?" — enables users to track financial behavior changes
4. **Recurring Merchants** — "Who do I pay most often?" — surfaces habitual spending that users may want to optimize

### POP-Specific Framing

- Cashback and POPcoins are given prominent placement (hero card, stat grid) to reinforce POP's rewards value
- Failed transactions are surfaced as a first-class metric — UPI failures are a real pain point, and showing users this data builds trust
- The design follows POP's actual dark theme with orange accents, matching the production app's visual identity

---

## Design Rationale

### Visual Language

- **Dark theme (#0D0D0D)** matching POP's production app
- **Orange accent (#FF6B2C)** for brand elements, active states, and primary CTAs
- **Radial gradient cards** — subtle glass-like cards using `rgba(44,44,44)` → `rgba(28,28,28)` → `rgba(12,12,12)`, matching POP's reference design
- **0.25px borders at rgba(255,255,255,0.2)** — thin, subtle card borders from the Figma spec
- **36px pill-shaped bottom nav** with backdrop blur, matching POP's navigation pattern
- **Inter font family** as specified in the design file

### Information Architecture

- **Bottom navigation** for the 4 core views — thumb-friendly, mobile-native pattern
- **User picker** in the header — allows switching between the 150 users to explore different spending profiles
- **Progressive disclosure** — summary first, then drill into breakdown/trends/recurring

---

## Tech Stack

| Layer | Technology | Why |
|-------|-----------|-----|
| Frontend | React 19 + Vite 8 | Fast HMR, modern React with CSS Modules |
| Backend | Express.js | Lightweight, sufficient for 6 API endpoints |
| Database | PostgreSQL 16 | Relational data with strong aggregation queries (SUM, GROUP BY, HAVING) |
| iOS | SwiftUI (iOS 17+) | Modern declarative UI with @Observable MVVM |
| Hosting | Railway (backend + DB) + Vercel (frontend) | Free tiers, zero-config deploys |

### Key Technical Decisions

- **CSS Modules over Tailwind** — component-scoped styles without a build dependency, cleaner for a small app
- **CSS custom properties for theming** — all colors defined as variables in `:root`, easy to maintain and update
- **Server-side aggregation** — all insights (breakdown percentages, monthly trends, recurring detection) are computed in PostgreSQL queries rather than client-side, keeping the frontend thin
- **Dynamic API URL detection** — frontend auto-detects localhost vs production and routes to the correct backend
- **SSL-aware database pool** — connection pool detects Railway URLs and enables SSL with `rejectUnauthorized: false` for their proxy

---

## Usage Guide

### Web App Features

1. **Summary** — Hero card showing total spend, plus stat cards for cashback, POPcoins, and failed transactions
2. **Breakdown** — Category-wise spending with colored dots and percentage breakdown
3. **Trends** — Bar chart of monthly spending with a detailed table showing cashback earned per month
4. **Recurring** — Merchants you pay 3+ times, with average and total amounts
5. **User Picker** — Dropdown in the header to switch between all 150 users

### How to Use

Open the [live web app](https://client-three-cyan-80.vercel.app) on your phone browser. Use the bottom navigation to switch between views. Use the user picker dropdown (top-right) to explore different users' financial data.

---

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/users` | List all 150 users |
| GET | `/api/users/:id/summary` | Total spend, cashback, coins, failed amount, txn count |
| GET | `/api/users/:id/breakdown` | Spending by category with percentages |
| GET | `/api/users/:id/trends` | Monthly spend and cashback |
| GET | `/api/users/:id/recurring` | Merchants with 3+ transactions |
| GET | `/api/users/:id/transactions` | Paginated transaction list (query: `limit`, `offset`) |

**Backend URL:** `https://server-production-dd0d.up.railway.app`

---

## Database Schema

```
users (id UUID PK, name TEXT, vpa TEXT)

transactions (
  id TEXT PK,
  user_id UUID FK → users,
  payee_name, payer_name TEXT,
  amount NUMERIC,
  status TEXT,          -- 'success' | 'failed'
  operation TEXT,       -- 'send' | 'receive'
  category TEXT,        -- Groceries, Transport, Tech, etc.
  coins_earned NUMERIC,
  cashback NUMERIC,
  transacted_at TIMESTAMPTZ
)
```

---

## Running Locally

### Prerequisites

- Node.js 18+
- PostgreSQL 16
- Xcode 15+ (for iOS)

### Backend

```bash
cd server
cp .env.example .env
# Edit .env with your DATABASE_URL (e.g., postgresql://localhost:5432/popinsights)

npm install
npm run seed    # Creates tables and seeds from transactions.xlsx
npm run dev     # Starts on http://localhost:3000
```

### Frontend

```bash
cd client
npm install
npm run dev     # Starts on http://localhost:5173
```

The frontend auto-detects `localhost` and routes API calls to `http://localhost:3000`.

### iOS (SwiftUI)

```bash
open ios/POPInsights/POPInsights.xcodeproj
```

1. Open the project in Xcode
2. Select an iPhone simulator (iPhone 15/16, iOS 17+)
3. Build and run (Cmd+R)

The iOS app fetches live data from the deployed Railway backend. No local server needed.

**Note:** For simulator builds without a dev team, Xcode handles ad-hoc signing automatically.

---

## Project Structure

```
kharche/
├── server/                    # Express backend
│   ├── src/
│   │   ├── index.js           # Entry point, CORS, routes
│   │   ├── routes/users.js    # All 6 API endpoints
│   │   └── db/
│   │       ├── pool.js        # PostgreSQL connection (SSL-aware)
│   │       ├── init.js        # Schema creation
│   │       └── seed.js        # Excel → PostgreSQL seeder
│   └── data/transactions.xlsx # Source dataset
├── client/                    # React frontend
│   ├── src/
│   │   ├── api/client.js      # API client with dynamic URL
│   │   ├── pages/             # Summary, Breakdown, Trends, Recurring
│   │   ├── components/        # BottomNav
│   │   ├── index.css          # Theme variables
│   │   └── App.jsx            # Router + user picker
│   └── vite.config.js
└── ios/POPInsights/           # SwiftUI app
    └── POPInsights/
        ├── Models/            # Data models + API Codables
        ├── ViewModels/        # SummaryViewModel (live API)
        ├── Views/             # HomeView + SummaryView
        └── Theme/             # POPTheme colors
```
