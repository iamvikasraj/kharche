import { useState, useEffect } from 'react';
import { getRecurring } from '../api/client';
import styles from './Recurring.module.css';

export default function Recurring({ userId }) {
  const [data, setData] = useState(null);

  useEffect(() => {
    getRecurring(userId).then(setData);
  }, [userId]);

  if (!data) return <div className={styles.page}><div className={styles.loader}>Loading...</div></div>;

  return (
    <div className={styles.page}>
      <h1 className={styles.title}>Recurring</h1>
      <p className={styles.subtitle}>Frequent merchants</p>
      <div className={styles.list}>
        {data.recurring.map((r) => (
          <div key={r.payeeName} className={styles.card}>
            <div className={styles.avatar}>
              {r.payeeName.charAt(0)}
            </div>
            <div className={styles.info}>
              <span className={styles.payee}>{r.payeeName}</span>
              <span className={styles.meta}>{r.txnCount} txns · avg ₹{Number(r.avgAmount).toLocaleString('en-IN')}</span>
            </div>
            <span className={styles.total}>₹{Number(r.totalAmount).toLocaleString('en-IN')}</span>
          </div>
        ))}
        {data.recurring.length === 0 && (
          <p className={styles.empty}>No recurring merchants found.</p>
        )}
      </div>
    </div>
  );
}
