import { useState, useEffect } from 'react';
import { getSummary } from '../api/client';
import styles from './Summary.module.css';

export default function Summary({ userId }) {
  const [data, setData] = useState(null);

  useEffect(() => {
    getSummary(userId).then(setData);
  }, [userId]);

  if (!data) return <div className={styles.page}><div className={styles.loader}>Loading...</div></div>;

  const cards = [
    { label: 'Total Spend', value: `₹${Number(data.totalSpend).toLocaleString('en-IN')}`, color: 'var(--accent-orange)' },
    { label: 'Cashback', value: `₹${Number(data.totalCashback).toLocaleString('en-IN')}`, color: 'var(--accent-green)' },
    { label: 'POPcoins', value: data.totalCoins.toLocaleString('en-IN'), color: 'var(--accent-amber)' },
    { label: 'Failed', value: `₹${Number(data.failedAmount).toLocaleString('en-IN')}`, color: 'var(--accent-red)' },
  ];

  return (
    <div className={styles.page}>
      <h1 className={styles.title}>Overview</h1>
      <p className={styles.subtitle}>{data.txnCount} transactions</p>

      <div className={styles.hero}>
        <span className={styles.heroLabel}>Total Spend</span>
        <span className={styles.heroValue}>₹{Number(data.totalSpend).toLocaleString('en-IN')}</span>
      </div>

      <div className={styles.grid}>
        {cards.slice(1).map((c) => (
          <div key={c.label} className={styles.card}>
            <span className={styles.cardLabel}>{c.label}</span>
            <span className={styles.cardValue} style={{ color: c.color }}>{c.value}</span>
          </div>
        ))}
      </div>
    </div>
  );
}
