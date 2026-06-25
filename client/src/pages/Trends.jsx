import { useState, useEffect } from 'react';
import { getTrends } from '../api/client';
import styles from './Trends.module.css';

export default function Trends({ userId }) {
  const [data, setData] = useState(null);

  useEffect(() => {
    getTrends(userId).then(setData);
  }, [userId]);

  if (!data) return <div className={styles.page}><div className={styles.loader}>Loading...</div></div>;

  const months = data.months;
  const maxSpend = Math.max(...months.map((m) => Number(m.spend)));

  return (
    <div className={styles.page}>
      <h1 className={styles.title}>Trends</h1>
      <p className={styles.subtitle}>Monthly spending patterns</p>

      <div className={styles.chartCard}>
        <div className={styles.chart}>
          {months.map((m) => (
            <div key={m.month} className={styles.bar}>
              <span className={styles.barValue}>₹{(Number(m.spend) / 1000).toFixed(0)}k</span>
              <div className={styles.barWrapper}>
                <div
                  className={styles.barFill}
                  style={{ height: `${(Number(m.spend) / maxSpend) * 100}%` }}
                />
              </div>
              <span className={styles.barLabel}>{m.month.slice(5)}</span>
            </div>
          ))}
        </div>
      </div>

      <div className={styles.table}>
        {months.map((m) => (
          <div key={m.month} className={styles.tableRow}>
            <span className={styles.monthLabel}>{m.month}</span>
            <div className={styles.rowValues}>
              <span className={styles.spend}>₹{Number(m.spend).toLocaleString('en-IN')}</span>
              <span className={styles.cashback}>+₹{Number(m.cashback).toLocaleString('en-IN')}</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
