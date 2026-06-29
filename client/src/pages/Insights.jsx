import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { getBreakdown, getRecurring } from '../api/client';
import {
  ShoppingCart, UtensilsCrossed, Plane, ShoppingBag, Laptop,
  Hospital, Shirt, Car, Store, Package, Zap, Home, Wifi,
  Gamepad2, Gift, Heart, Briefcase, Music, Dumbbell, BookOpen,
} from 'lucide-react';
import styles from './Insights.module.css';

const CATEGORY_ICONS = {
  'Groceries': ShoppingCart,
  'Food & Dining': UtensilsCrossed,
  'Travel': Plane,
  'Shopping': ShoppingBag,
  'Tech': Laptop,
  'Healthcare': Hospital,
  'Fashion': Shirt,
  'Transport': Car,
  'Supermarkets': Store,
  'Other': Package,
  'Utilities': Zap,
  'Rent': Home,
  'Telecom': Wifi,
  'Entertainment': Gamepad2,
  'Gifts': Gift,
  'Insurance': Heart,
  'Business': Briefcase,
  'Subscriptions': Music,
  'Fitness': Dumbbell,
  'Education': BookOpen,
};

export default function Insights({ userId, summary }) {
  const navigate = useNavigate();
  const [breakdown, setBreakdown] = useState([]);
  const [recurring, setRecurring] = useState([]);
  const [showAll, setShowAll] = useState(false);

  useEffect(() => {
    if (!userId) return;
    getBreakdown(userId).then((d) => setBreakdown(d.categories || []));
    getRecurring(userId).then((d) => setRecurring(d.recurring || []));
  }, [userId]);

  const fmt = (n) => Number(n).toLocaleString('en-IN');
  const totalSpend = summary ? fmt(summary.totalSpend) : '0';
  const visibleCategories = showAll ? breakdown : breakdown.slice(0, 3);

  const dateRange = (() => {
    const now = new Date();
    const month = now.toLocaleString('en-IN', { month: 'short' });
    return `${month} 1 - Today`;
  })();

  return (
    <div className={styles.page}>
      {/* Hero Header */}
      <div className={styles.hero}>
        <img src="/assets/insights-header-bg.png" alt="" className={styles.heroBg} />
        <div className={styles.heroOverlay} />
        <div className={styles.heroContent}>
          <span className={styles.dateRange}>{dateRange}</span>
          <img src="/assets/insights-title.svg" alt="Pop Insights" className={styles.heroTitle} />
          <div className={styles.heroPills}>
            <div className={styles.heroPill}>
              <span className={styles.pillLabel}>Collected</span>
              <img src="/assets/pop-coin.png" alt="" className={styles.pillCoin} />
              <span className={styles.pillValue}>{summary?.totalCoins ?? 0}</span>
            </div>
            <div className={styles.heroPill}>
              <span className={styles.pillLabel}>Cashback</span>
              <span className={styles.pillValue}>₹{summary ? fmt(summary.totalCashback) : '0'}</span>
            </div>
          </div>
        </div>

        {/* Back button */}
        <button className={styles.backBtn} onClick={() => navigate('/')}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
            <path d="M15 18l-6-6 6-6" />
          </svg>
        </button>

        {/* Coins badge */}
        <div className={styles.coinsBadge}>
          <img src="/assets/pop-coin.png" alt="" className={styles.coinsBadgeIcon} />
          <span className={styles.coinsBadgeText}>
            {summary ? (summary.totalCoins >= 1000 ? `${(summary.totalCoins / 1000).toFixed(1).replace(/\.0$/, '')}k` : summary.totalCoins) : '0'}
          </span>
        </div>
      </div>

      {/* Spending So Far Card */}
      {summary && (
        <div className={styles.spendingCard}>
          <div className={styles.spendingRow}>
            <span className={styles.spendingLabel}>Spending so far</span>
            <span className={styles.spendingValue}>₹{totalSpend}</span>
          </div>
          <div className={styles.spendingRow}>
            <span className={styles.spendingSub}>vs last month</span>
            <span className={styles.spendingDelta}>+₹342</span>
          </div>
        </div>
      )}

      {/* Top 3 Spends */}
      {breakdown.length > 0 && (
        <>
          <div className={styles.sectionLabel}>
            <div className={styles.sectionLine} />
            <span className={styles.sectionLabelText}>TOP 3 SPENDS</span>
            <div className={styles.sectionLine} />
          </div>

          <div className={styles.spendsCard}>
            <div className={styles.spendsRows}>
              {visibleCategories.map((cat, i) => (
                <div key={cat.name}>
                  <div className={styles.spendRow}>
                    <div className={styles.iconBox}>
                      {(() => { const Icon = CATEGORY_ICONS[cat.name] || Package; return <Icon size={16} color="#8f97a3" strokeWidth={1.5} />; })()}
                    </div>
                    <div className={styles.spendInfo}>
                      <span className={styles.spendName}>{cat.name}</span>
                      <span className={styles.spendPercent}>{Number(cat.percent).toFixed(2)}%</span>
                    </div>
                    <span className={styles.spendAmount}>₹{fmt(cat.amount)}</span>
                  </div>
                  {i < visibleCategories.length - 1 && <div className={styles.divider} />}
                </div>
              ))}
            </div>
            {breakdown.length > 3 && (
              <button className={styles.viewAllBtn} onClick={() => setShowAll(!showAll)}>
                {showAll ? 'SHOW LESS' : 'VIEW ALL'}
              </button>
            )}
          </div>
        </>
      )}

      {/* Recurring */}
      {recurring.length > 0 && (
        <>
          <div className={styles.sectionLabel}>
            <div className={styles.sectionLine} />
            <span className={styles.sectionLabelText}>RECURRING</span>
            <div className={styles.sectionLine} />
          </div>

          <div className={styles.recurringCard}>
            {recurring.map((r, i) => (
              <div key={r.payeeName}>
                <div className={styles.spendRow}>
                  <div className={styles.iconBox}>
                    <span className={styles.merchantInitial}>{r.payeeName.charAt(0)}</span>
                  </div>
                  <div className={styles.spendInfo}>
                    <span className={styles.spendName}>{r.payeeName}</span>
                    <span className={styles.spendPercent}>Avg ₹{fmt(r.avgAmount)} per {r.txnCount} transactions</span>
                  </div>
                  <span className={styles.spendAmount}>₹{fmt(r.totalAmount)}</span>
                </div>
                {i < recurring.length - 1 && <div className={styles.dividerLight} />}
              </div>
            ))}
          </div>
        </>
      )}

      {/* Cashback Promo */}
      <div className={styles.promoCard}>
        <img src="/assets/cashback-promo.png" alt="Cashback offer" className={styles.promoImg} />
      </div>

      <div className={styles.bottomSpacer} />
    </div>
  );
}
