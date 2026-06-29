import { Routes, Route, Navigate, useNavigate } from 'react-router-dom';
import BottomNav from '../components/BottomNav';
import Breakdown from './Breakdown';
import Trends from './Trends';
import Recurring from './Recurring';
import styles from './Insights.module.css';

export default function Insights({ userId, summary }) {
  const navigate = useNavigate();

  return (
    <div className={styles.page}>
      <header className={styles.header}>
        <button className={styles.backBtn} onClick={() => navigate('/')}>
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M19 12H5M12 19l-7-7 7-7" />
          </svg>
        </button>
        <h1 className={styles.title}>Pop Insights</h1>
      </header>

      {summary && (
        <div className={styles.summaryStrip}>
          <div className={styles.heroRow}>
            <span className={styles.heroLabel}>TOTAL SPEND</span>
            <span className={styles.heroValue}>₹{Number(summary.totalSpend).toLocaleString('en-IN')}</span>
          </div>
          <div className={styles.statsRow}>
            <div className={styles.stat}>
              <span className={styles.statValue} style={{ color: 'var(--accent-green)' }}>₹{Number(summary.totalCashback).toLocaleString('en-IN')}</span>
              <span className={styles.statLabel}>CASHBACK</span>
            </div>
            <div className={styles.statDivider} />
            <div className={styles.stat}>
              <span className={styles.statValue} style={{ color: 'var(--accent-amber)' }}>{Number(summary.totalCoins).toLocaleString('en-IN')}</span>
              <span className={styles.statLabel}>POPCOINS</span>
            </div>
            <div className={styles.statDivider} />
            <div className={styles.stat}>
              <span className={styles.statValue} style={{ color: 'var(--accent-red)' }}>₹{Number(summary.failedAmount).toLocaleString('en-IN')}</span>
              <span className={styles.statLabel}>FAILED</span>
            </div>
          </div>
          <span className={styles.txnCount}>{summary.txnCount} transactions</span>
        </div>
      )}

      <main className={styles.main}>
        <Routes>
          <Route path="/" element={<Navigate to="/insights/breakdown" replace />} />
          <Route path="/breakdown" element={<Breakdown userId={userId} />} />
          <Route path="/trends" element={<Trends userId={userId} />} />
          <Route path="/recurring" element={<Recurring userId={userId} />} />
        </Routes>
      </main>
      <BottomNav basePath="/insights" />
    </div>
  );
}
