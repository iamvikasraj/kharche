# Kharche — UPI Financial Insights for POP

> **POP Full Stack Builder Assignment** — A financial insights product that helps users understand their UPI spending patterns, recurring expenses, and rewards through a polished mobile-first experience.

| | |
|---|---|
| **Live Web App** | [https://client-three-cyan-80.vercel.app](https://client-three-cyan-80.vercel.app) |
| **Design File** | [Figma](https://www.figma.com/design/sjRkyjz7u5fB6NByTHohwK/Design?node-id=3-17) |
| **API Server** | [https://server-production-dd0d.up.railway.app](https://server-production-dd0d.up.railway.app) |
| **GitHub** | [https://github.com/iamvikasraj/kharche](https://github.com/iamvikasraj/kharche) |

Open the web app on your phone browser — it's live and immediately testable, no build process needed.

---

## Deliverables

| Deliverable | Status | Link / Details |
|-------------|--------|----------------|
| **Live Web App** | ✅ Deployed | [client-three-cyan-80.vercel.app](https://client-three-cyan-80.vercel.app) — open on phone, no build needed |
| **Native App (iOS)** | ✅ Full SwiftUI app | `ios/POPInsights/` — open in Xcode 16+, build & run (Cmd+R). Fetches live API data |
| **Design Files** | ✅ Figma | [Design File](https://www.figma.com/design/sjRkyjz7u5fB6NByTHohwK/Design?node-id=3-17) — all screens, components, specs, and annotations |
| **Codebase** | ✅ Public repo | [github.com/iamvikasraj/kharche](https://github.com/iamvikasraj/kharche) — web + backend + iOS |
| **Documentation** | ✅ This README | Product thinking, design rationale, tech decisions, usage guide, API reference |

---

## Table of Contents

- [Product Thinking](#product-thinking)
- [Design Rationale](#design-rationale)
- [Usage Guide](#usage-guide)
- [Tech Stack & Decisions](#tech-stack--decisions)
- [API Reference](#api-reference)
- [Database Schema](#database-schema)
- [Running Locally](#running-locally)
- [iOS Native App](#ios-native-app)
- [Project Structure](#project-structure)

---

## Product Thinking

### Understanding the Users

I started by analyzing the synthetic dataset (150 users, ~20K transactions) to identify real patterns before designing anything:

- **Diverse spending profiles** — users range from ₹5K to ₹2L+ in total spend. Most spending concentrates in Supermarkets, Groceries, and Transport — these aren't discretionary, they're daily essentials. The insight layer needs to help users see where their _routine_ money goes.
- **Recurring merchant behavior** — most users have 3–5 merchants they transact with repeatedly (Ola Cabs, PharmEasy, Paytm Mall). This is habitual spending that users often don't realize adds up — surfacing it creates an "aha" moment.
- **Cashback & rewards engagement** — POPcoins and cashback are earned across transactions. Surfacing these prominently reinforces POP's value proposition and gives users a reason to keep using POP over other UPI apps.
- **Non-trivial failure rates** — some users have significant failed transaction amounts. Showing this builds trust (transparency) and positions POP as an app that respects the user's financial awareness.

### Chosen Insights

I prioritized insights that answer the questions users actually ask themselves:

| Insight | User Question | Why It Matters |
|---------|--------------|----------------|
| **Spending Summary** | "How much have I spent this month?" | The hero metric — instant financial awareness with month-over-month delta |
| **Category Breakdown** | "Where is my money going?" | Top 3 shown upfront, VIEW ALL for drill-down. Helps identify largest spending buckets |
| **Recurring Merchants** | "Who do I pay most often?" | Surfaces habitual spending with avg amount + frequency — the spending users forget about |
| **Rewards & Cashback** | "What am I earning back?" | POPcoins + cashback shown in hero header — reinforces POP's value loop |

### POP-Specific Angle

This isn't a generic finance dashboard — it's framed within POP's ecosystem:

- **Cashback and POPcoins** get hero placement (header pills, coins badge) — not buried in a settings page
- **The Home page mirrors POP's actual app** — "Tap to scan" hero, Everything UPI grid, recharges, bottom nav. The insights feel like a natural extension, not a bolted-on feature
- **"Pop Insights" entry point** lives in the UPI grid alongside Pay Friends and Check Balance — positioned as a core utility, not a secondary feature
- **Cashback promo card** at the bottom of insights reinforces the POP card acquisition funnel

### Scoping Decisions

With 8–10 hours, I prioritized a polished end-to-end experience over feature breadth:

- **User picker instead of authentication** — the assignment has 150 synthetic users. A login flow would add friction without value. The user picker lets reviewers explore any user's data instantly. In production, this would be replaced by real auth (OTP-based, matching POP's flow).
- **Single Insights page instead of separate Trends/Breakdown/Recurring tabs** — after prototyping both, the single scrollable page felt more natural on mobile. Users see the full picture without tab-switching. The data is all from the same time period, so it belongs together.
- **No savings potential / highest spender views** — these require comparative analysis across users (which a real user wouldn't see) or predictive modeling. I focused on insights a user would actually use: "where did my money go" and "what am I paying repeatedly."
- **Shop and Card tabs are placeholders** — they exist in the navigation to show the full app structure, but aren't the focus of this assignment.

---

## Design Rationale

### Visual Language

The design follows POP's production app aesthetic — not a generic dark theme, but POP's specific visual system:

| Element | Spec | Reference |
|---------|------|-----------|
| Background | `#0D0D0D` | POP's primary dark background |
| Card surfaces | Radial gradient: `#2C2C2C` → `#1C1C1C` → `#0C0C0C` | POP's glass-like card treatment |
| Card borders | `0.25px solid rgba(255,255,255,0.2)` | Subtle depth from the Figma reference |
| Accent | `#FF6B2C` (orange) | POP's brand color for CTAs and active states |
| Delta color | `#FF720C` | Month-over-month spending changes |
| Section labels | `#747474`, 12px, uppercase, 0.48px tracking | Muted dividers between content sections |
| Bottom nav | 283×55px pill, `#2F2F2F` → `#0E0E0E` gradient | POP's custom tab bar with per-tab SVG icons |
| Typography | Inter / SF Pro, medium weight | Clean, legible at small sizes |

### Key Design Decisions

- **Single scrollable Insights page** instead of tabbed navigation — reduces cognitive load. Users see everything in one scroll: spending → categories → recurring → promo. No tab switching needed.
- **Expandable categories** — show top 3 upfront (covers ~75% of spending), VIEW ALL for the full list. Progressive disclosure without hiding important data.
- **Per-user gradient avatars** — 8 color pairs hashed by user ID. Each user gets a consistent, unique identity across sessions. The avatar uses a gradient circle with an overlay character image, matching POP's actual avatar treatment.
- **Full-page user picker** (not a dropdown) — large preview avatar with name + VPA, 4-column grid for all users. Feels native and intentional, not like a form control.
- **60px section spacing, 24px heading-to-card** — consistent vertical rhythm matched pixel-for-pixel between iOS and web.
- **Conditional rendering** — sections with no data are hidden entirely. No empty states, no "No data available" messages. Clean.

### iOS ↔ Web Parity

Every design element is matched across platforms:

- Same Figma-exported assets (hero, banners, nav icons, avatar overlay, cashback promo, footer)
- Same spacings, colors, border radii, and typography
- SF Symbols (iOS) ↔ lucide-react (web) — both clean stroke-style icons
- `.contentTransition(.numericText())` on iOS for animated VIEW ALL toggle
- Matched geometry effect on iOS tab bar highlight, CSS transition on web

---

## Usage Guide

### Getting Started

Open [https://client-three-cyan-80.vercel.app](https://client-three-cyan-80.vercel.app) on your phone browser. The app loads immediately with real data from all 150 users.

### Home Page

| Feature | Description |
|---------|-------------|
| **Hero** | "Tap to scan" with QR code visual — mirrors POP's home screen |
| **Coins badge** | Top-right — shows POPcoins balance (formatted as "519", "1.2k", etc.) |
| **Banner cards** | Horizontally scrollable promotional banners |
| **Everything UPI** | 4 action buttons — Pay friends, To bank, Check balance, **Pop Insights** |
| **UPI pills** | Active user's VPA + UPI Lite status |
| **Recharges** | Prepaid/postpaid cards with colored gradient backgrounds |
| **Carousel** | Swipeable cashback promo cards with dot indicators |
| **Footer** | "Your lifestyle Rewarded" branding |

### Insights Page

Tap "Pop Insights" from the UPI grid to open:

| Section | What It Shows |
|---------|---------------|
| **Hero header** | Purple gradient, date range, "Pop Insights" title, Collected coins + Cashback pills |
| **Spending card** | Total spend this month + delta vs last month (`+₹342`) |
| **TOP 3 SPENDS** | Category breakdown with stroke icons, percentages, and amounts |
| **VIEW ALL** | Expands to show all spending categories (collapses back to top 3) |
| **RECURRING** | Merchants with 3+ transactions — avg amount, frequency, total |
| **Cashback promo** | POP card acquisition promotional card |

### User Picker

Tap the gradient avatar (top-left on Home) to switch users:

- Large preview avatar with gradient + name + VPA
- 4-column grid of all 150 users with per-user gradient colors
- Active user highlighted with white ring + scale effect
- Tap to select — data refreshes automatically, picker auto-dismisses

### Bottom Navigation

Pill-shaped tab bar with custom SVG icons:
- **Home** (house icon) — main landing page
- **Shop** (bag icon) — placeholder
- **Card** (card icon) — placeholder
- **Scan** (prominent rounded button) — scan action

---

## Tech Stack & Decisions

| Layer | Technology | Why This Choice |
|-------|-----------|-----------------|
| **Frontend** | React 19 + Vite + CSS Modules | Fast HMR, component-scoped styles without Tailwind build dependency |
| **Icons** | lucide-react | Clean stroke icons matching SF Symbols style on iOS |
| **Backend** | Express.js | Lightweight — 6 endpoints don't need a framework heavier than Express |
| **Database** | PostgreSQL 16 | Relational data with strong aggregation (SUM, GROUP BY, HAVING for category breakdowns) |
| **iOS** | SwiftUI (iOS 18+) | Declarative UI with `@Observable` MVVM, matched geometry effects, content transitions |
| **Hosting** | Railway (backend + DB) + Vercel (frontend) | Free tiers, zero-config deploys, SSL included |

### Technical Decisions

- **CSS Modules over Tailwind** — component-scoped styles without a build dependency. For a small app with a custom design system, utility classes add indirection without much benefit.
- **Server-side aggregation** — category breakdowns, recurring merchant detection, and monthly trends are computed in PostgreSQL queries (`GROUP BY category`, `HAVING COUNT(*) >= 3`), not client-side. Keeps the frontend thin and fast.
- **Production API always** — web client always hits the Railway backend directly. No localhost detection or environment switching needed.
- **Global scrollbar hiding** — `scrollbar-width: none` + `::-webkit-scrollbar { display: none }` for a native mobile feel in the browser.
- **Per-user gradient hashing** — `(hash << 5) - hash + charCode` hashed into 8 gradient pairs. Same user always gets the same color on both platforms.

---

## API Reference

All endpoints return JSON. Base URL: `https://server-production-dd0d.up.railway.app`

| Method | Endpoint | Description | Key Fields |
|--------|----------|-------------|------------|
| GET | `/api/users` | List all 150 users | `users[].id`, `name`, `vpa` |
| GET | `/api/users/:id/summary` | Spending overview | `totalSpend`, `totalCashback`, `totalCoins`, `failedAmount`, `txnCount` |
| GET | `/api/users/:id/breakdown` | Category spending | `categories[].name`, `amount`, `percent` |
| GET | `/api/users/:id/trends` | Monthly trends | `months[].month`, `spend`, `cashback` |
| GET | `/api/users/:id/recurring` | Recurring merchants (3+ txns) | `recurring[].payeeName`, `txnCount`, `avgAmount`, `totalAmount` |
| GET | `/api/users/:id/transactions` | Paginated transactions | `transactions[]`, supports `?limit=&offset=` |

---

## Database Schema

```sql
-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  vpa TEXT NOT NULL
);

-- Transactions table (~20K rows)
CREATE TABLE transactions (
  id TEXT PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  payee_name TEXT,
  payer_name TEXT,
  amount NUMERIC,
  status TEXT,            -- 'success' | 'failed'
  operation TEXT,         -- 'send' | 'receive'
  category TEXT,          -- Groceries, Transport, Supermarkets, Tech, etc.
  coins_earned NUMERIC,
  cashback NUMERIC,
  transacted_at TIMESTAMPTZ
);
```

Data is seeded from the provided `transactions.xlsx` dataset using a Node.js seeder (`npm run seed`).

---

## Running Locally

### Prerequisites

- Node.js 18+
- PostgreSQL 16
- Xcode 16+ (for iOS app)

### Backend

```bash
cd server
cp .env.example .env
# Set DATABASE_URL in .env (e.g., postgresql://localhost:5432/popinsights)

npm install
npm run seed    # Creates tables + seeds ~20K transactions from xlsx
npm run dev     # Starts API on http://localhost:3000
```

### Frontend

```bash
cd client
npm install
npm run dev     # Starts on http://localhost:5173
```

### Deployment

- **Backend + DB**: Deployed on Railway (auto-deploys from GitHub)
- **Frontend**: Deployed on Vercel (auto-deploys from GitHub)

Both use free tiers with SSL included.

---

## iOS Native App

The iOS implementation goes beyond the "one screen" requirement — it's a **full native app** with Home, Insights, and User Picker, all fetching live data from the Railway API.

### Building & Running

```bash
open ios/POPInsights/POPInsights.xcodeproj
```

1. Open in Xcode 16+
2. Select an iPhone simulator (iPhone 15/16, iOS 18+)
3. Build and run (`Cmd+R`)

The app fetches live data from the deployed Railway backend — no local server needed.

### What's Implemented Natively

| Screen | SwiftUI Features |
|--------|-----------------|
| **Home** | `ScrollView`, `TabView` carousel, custom `POPTabBar` with `matchedGeometryEffect`, gradient avatars with asset overlay |
| **Insights** | `@State` expand/collapse, `.contentTransition(.numericText())`, SF Symbol stroke icons, conditional section rendering |
| **User Picker** | `.fullScreenCover`, `LazyVGrid` 4-column layout, animated preview transitions, `DragGesture` swipe-back |
| **Tab Bar** | Custom `POPTabBar` with `matchedGeometryEffect` highlight animation, per-tab SVG icons, hide/show on navigation |

### Native Code Quality

- **MVVM architecture** — `SummaryViewModel` with `@Observable` macro, async/await API calls
- **Live API integration** — not mock data; fetches from the same Railway backend as the web app
- **Figma asset pipeline** — all assets exported from Figma and imported as xcassets
- **Platform-native patterns** — `NavigationStack`, `@Environment(\.dismiss)`, `@Namespace` for animations

---

## Project Structure

```
kharche/
├── server/                           # Express.js backend
│   ├── src/
│   │   ├── index.js                  # Entry point, CORS, routes
│   │   ├── routes/users.js           # All 6 API endpoints
│   │   └── db/
│   │       ├── pool.js               # PostgreSQL connection pool (SSL-aware)
│   │       ├── init.js               # Schema creation
│   │       └── seed.js               # Excel → PostgreSQL seeder
│   └── data/transactions.xlsx        # Provided dataset
│
├── client/                           # React web frontend
│   ├── public/assets/                # iOS-synced assets (hero, nav icons, avatar, etc.)
│   ├── src/
│   │   ├── api/client.js             # API client (production URL)
│   │   ├── pages/
│   │   │   ├── Home.jsx              # Home (hero, banners, UPI grid, carousel, footer)
│   │   │   ├── Home.module.css
│   │   │   ├── Insights.jsx          # Insights (spending, categories, recurring, promo)
│   │   │   ├── Insights.module.css
│   │   │   ├── Shop.jsx              # Placeholder
│   │   │   └── Card.jsx              # Placeholder
│   │   ├── components/
│   │   │   ├── HomeNav.jsx           # Bottom navigation bar
│   │   │   └── HomeNav.module.css
│   │   ├── App.jsx                   # Router + full-page user picker
│   │   ├── App.module.css
│   │   └── index.css                 # Theme variables + global styles
│   └── index.html                    # Favicon, meta tags
│
├── ios/POPInsights/                  # SwiftUI iOS app
│   └── POPInsights/
│       ├── Models/                   # UserInfo, Transaction Codables
│       ├── ViewModels/               # SummaryViewModel (@Observable, async/await)
│       ├── Views/
│       │   ├── Home/HomeView.swift   # Home (hero, banners, UPI, carousel)
│       │   └── Insights/
│       │       └── InsightsView.swift # Insights (spending, categories, recurring)
│       ├── Theme/POPTheme.swift      # Colors, gradients, Color(hex:) extension
│       ├── POPInsightsApp.swift      # MainTabView, POPTabBar, UserPickerView
│       └── Assets.xcassets/          # All Figma-exported assets
│
└── docs/
    └── POP_FSBuilder_Assignment.pdf  # Assignment brief
```
