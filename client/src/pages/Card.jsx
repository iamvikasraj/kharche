import HomeNav from '../components/HomeNav';
import styles from './PlaceholderPage.module.css';

export default function Card() {
  return (
    <div className={styles.page}>
      <div className={styles.content}>
        <span className={styles.icon}>💳</span>
        <h2 className={styles.title}>Card</h2>
        <p className={styles.subtitle}>Coming soon</p>
      </div>
      <HomeNav />
    </div>
  );
}
