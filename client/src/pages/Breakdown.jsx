import { useState, useEffect } from 'react';
import { getBreakdown } from '../api/client';
import styles from './Breakdown.module.css';

const COLORS = ['#FF6B2C', '#22C55E', '#F59E0B', '#3B82F6', '#8B5CF6', '#EC4899', '#14B8A6', '#EF4444', '#06B6D4', '#84CC16'];

export default function Breakdown({ userId }) {
  const [data, setData] = useState(null);

  useEffect(() => {
    getBreakdown(userId).then(setData);
  }, [userId]);

  if (!data) return <div className={styles.page}><div className={styles.loader}>Loading...</div></div>;

  const max = Math.max(...data.categories.map((c) => Number(c.amount)));

  return (
    <div className={styles.page}>
      <h1 className={styles.title}>Breakdown</h1>
      <p className={styles.subtitle}>Spending by category</p>
      <div className={styles.list}>
        {data.categories.map((cat, i) => (
          <div key={cat.name} className={styles.row}>
            <div className={styles.rowLeft}>
              <div className={styles.dot} style={{ background: COLORS[i % COLORS.length] }} />
              <div className={styles.rowInfo}>
                <span className={styles.catName}>{cat.name}</span>
                <span className={styles.percent}>{cat.percent}%</span>
              </div>
            </div>
            <span className={styles.catAmount}>₹{Number(cat.amount).toLocaleString('en-IN')}</span>
          </div>
        ))}
      </div>
    </div>
  );
}
