# Kharche — UPI Financial Insights

A full-stack financial insights product built for POP's Full Stack Builder Assignment. Helps users understand their spending patterns, recurring expenses, and financial behavior through an intuitive mobile-first interface — built as both a **React web app** and a **native SwiftUI iOS app**.

**Live Web App:** [https://client-three-cyan-80.vercel.app](https://client-three-cyan-80.vercel.app)
**Design File:** [Figma](https://www.figma.com/design/sjRkyjz7u5fB6NByTHohwK/Design?node-id=3-17)
**API Server:** [https://server-production-dd0d.up.railway.app](https://server-production-dd0d.up.railway.app)

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

1. **Spending Summary** — "How much have I spent this month, and how does it compare to last month?" — the hero metric on the Insights page
2. **Category Breakdown** — "Where is my money going?" — top 3 spends shown upfront with expandable VIEW ALL for all categories
3. **Recurring Merchants** — "Who do I pay most often?" — surfaces habitual spending with average amount and transaction frequency
4. **Rewards & Cashback** — "What am I earning back?" — POPcoins collected and total cashback shown prominently in the hero header

### POP-Specific Framing

- Cashback and POPcoins are given prominent placement (hero pills, coins badge) to reinforce POP's rewards value
- The design mirrors POP's actual production app — dark theme, radial gradient cards, pill-shaped bottom nav, custom tab icons
- The Home page replicates POP's real home screen (hero with "Tap to scan", Everything UPI grid, recharges section) to feel native to the POP ecosystem

---

## Design Rationale

### Visual Language

- **Dark theme (#0D0D0D)** matching POP's production app
- **Orange accent (#FF6B2C)** for brand elements, deltas, and active states
- **Radial gradient cards** — subtle glass-like cards using `#2C2C2C` → `#1C1C1C` → `#0C0C0C`, matching POP's reference design
- **0.25px borders at rgba(255,255,255,0.2)** — thin, subtle card borders from the Figma spec
- **Pill-shaped bottom nav** (283×55px) with per-tab active/inactive SVG icons and gradient highlight
- **Per-user gradient avatars** — 8 color pairs hashed by user ID, with avatar overlay image for consistent identity

### Information Architecture

- **Single scrollable Insights page** — spending card → top 3 spends → expandable categories → recurring merchants → cashback promo. No tab switching, everything flows naturally
- **Full-page user picker** — tap the avatar to open, see large preview with gradient + name + VPA, 4-column grid of all users, auto-dismiss on selection
- **Conditional rendering** — sections with no data are hidden entirely (no empty headings)
- **60px section spacing, 24px heading-to-card spacing** — consistent rhythm across both platforms

### iOS ↔ Web Parity

Every design element is pixel-matched across platforms:
- Same assets (hero, banners, nav icons, avatar, cashback promo, footer)
- Same spacings, colors, border radii, and typography
- SF Symbols (iOS) ↔ lucide-react (web) for category icons — both stroke-style
- `.contentTransition(.numericText())` (iOS) for VIEW ALL animation

---

## Tech Stack

| Layer | Technology | Why |
|-------|-----------|-----|
| Frontend | React 19 + Vite + CSS Modules | Fast HMR, component-scoped styles without build dependency |
| Icons | lucide-react | Clean stroke icons matching SF Symbols style on iOS |
| Backend | Express.js | Lightweight, sufficient for 6 API endpoints |
| Database | PostgreSQL 16 | Relational data with strong aggregation queries (SUM, GROUP BY, HAVING) |
| iOS | SwiftUI (iOS 18+) | Modern declarative UI with @Observable MVVM, matched geometry effects |
| Hosting | Railway (backend + DB) + Vercel (frontend) | Free tiers, zero-config deploys |

### Key Technical Decisions

- **CSS Modules over Tailwind** — component-scoped styles without a build dependency, cleaner for a small app
- **CSS custom properties for theming** — all colors defined as variables in `:root`, easy to maintain
- **Server-side aggregation** — all insights (breakdown percentages, recurring detection) are computed in PostgreSQL queries rather than client-side
- **Production API always** — web client always hits the Railway backend, no localhost detection needed
- **Global scrollbar hiding** — `scrollbar-width: none` + `::-webkit-scrollbar { display: none }` for native mobile feel

---

## Usage Guide

### How to Use

Open the [live web app](https://client-three-cyan-80.vercel.app) on your phone browser. No build process needed.

### Home Page
- **Hero** — "Tap to scan" with QR code visual
- **Banner cards** — horizontally scrollable promotional banners
- **Everything UPI** — 4 action buttons: Pay friends, To bank, Check balance, **Pop Insights** (tap to open insights)
- **UPI ID pills** — shows the active user's VPA and UPI Lite status
- **Recharges** — prepaid/postpaid cards
- **Cashback carousel** — swipeable promo cards with dot indicators
- **Footer** — "Your lifestyle Rewarded" branding

### Insights Page
- **Hero header** — purple gradient with date range, "Pop Insights" title, Collected coins + Cashback pills
- **Spending card** — total spend this month with delta vs last month
- **TOP 3 SPENDS** — category breakdown with stroke icons, percentages, and amounts
- **VIEW ALL** — expands to show all spending categories
- **RECURRING** — merchants with 3+ transactions, showing average amount and frequency
- **Cashback promo** — promotional card at the bottom

### User Picker
Tap the avatar (top-left on Home) to open a full-page user picker:
- Large preview avatar with gradient + name + VPA
- 4-column grid of all 150 users
- Per-user gradient colors (8 color pairs, hashed by user ID)
- Tap a user to switch — data refreshes automatically

### Bottom Navigation
Pill-shaped tab bar with Home, Shop, Card tabs + Scan button. Custom SVG icons with active/inactive states.

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
- Xcode 16+ (for iOS)

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

### iOS App (SwiftUI)

```bash
open ios/POPInsights/POPInsights.xcodeproj
```

1. Open the project in Xcode 16+
2. Select an iPhone simulator (iPhone 15/16, iOS 18+)
3. Build and run (Cmd+R)

The iOS app fetches live data from the deployed Railway backend — no local server needed.

**Note:** The iOS app is a full implementation (not just one screen) — Home, Insights, and User Picker are all built natively in SwiftUI with live API data, custom tab bar with matched geometry effects, and Figma-imported assets.

---

## Project Structure

```
kharche/
├── server/                        # Express backend
│   ├── src/
│   │   ├── index.js               # Entry point, CORS, routes
│   │   ├── routes/users.js        # All 6 API endpoints
│   │   └── db/
│   │       ├── pool.js            # PostgreSQL connection (SSL-aware)
│   │       ├── init.js            # Schema creation
│   │       └── seed.js            # Excel → PostgreSQL seeder
│   └── data/transactions.xlsx     # Source dataset
├── client/                        # React frontend
│   ├── public/assets/             # All iOS-synced assets (hero, nav icons, avatar, etc.)
│   ├── src/
│   │   ├── api/client.js          # API client (production URL)
│   │   ├── pages/
│   │   │   ├── Home.jsx           # Home page (hero, banners, UPI grid, carousel)
│   │   │   ├── Insights.jsx       # Insights page (spending, categories, recurring)
│   │   │   ├── Shop.jsx           # Placeholder
│   │   │   └── Card.jsx           # Placeholder
│   │   ├── components/
│   │   │   └── HomeNav.jsx        # Bottom navigation bar
│   │   ├── index.css              # Theme variables + global scrollbar hiding
│   │   └── App.jsx                # Router + user picker overlay
│   └── vite.config.js
├── ios/POPInsights/               # SwiftUI iOS app
│   └── POPInsights/
│   │   ├── Models/                # UserInfo, Transaction Codables
│   │   ├── ViewModels/            # SummaryViewModel (live API)
│   │   ├── Views/
│   │   │   ├── Home/HomeView.swift          # Home (hero, banners, UPI, carousel)
│   │   │   └── Insights/InsightsView.swift  # Insights (spending, categories, recurring)
│   │   ├── Theme/POPTheme.swift   # Colors, gradients, hex extension
│   │   └── POPInsightsApp.swift   # MainTabView, POPTabBar, UserPickerView
│   └── Assets.xcassets/           # All Figma-exported assets
└── docs/                          # Assignment PDF
```
