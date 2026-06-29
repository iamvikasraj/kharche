import HomeNav from '../components/HomeNav';
import styles from './PlaceholderPage.module.css';

export default function Shop() {
  return (
    <div className={styles.page}>
      <div className={styles.content}>
        <span className={styles.icon}>🛍️</span>
        <h2 className={styles.title}>Shop</h2>
        <p className={styles.subtitle}>Coming soon</p>
      </div>
      <HomeNav />
    </div>
  );
}
