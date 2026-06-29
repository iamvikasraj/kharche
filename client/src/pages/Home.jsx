import { useNavigate } from 'react-router-dom';
import HomeNav from '../components/HomeNav';
import styles from './Home.module.css';

export default function Home({ activeUser, onAvatarClick, summary }) {
  const navigate = useNavigate();

  return (
    <div className={styles.page}>
      {/* Sticky Top Bar */}
      <div className={styles.heroTop}>
        <button className={styles.userDot} onClick={onAvatarClick} />
        <div className={styles.coinBadge}>
          <img src="/assets/pop-coin.png" alt="" className={styles.coinIcon} />
        </div>
      </div>

      {/* Hero Section */}
      <div className={styles.hero}>
        <img src="/assets/hero-bg.png" alt="" className={styles.heroBg} />
      </div>

      {/* Banner Cards */}
      <div className={styles.statsRow}>
        <div className={styles.bannerCard} />
        <div className={styles.bannerCard} />
        <div className={styles.bannerCard} />
      </div>

      {/* Everything UPI */}
      <div className={styles.upiSection}>
        <div className={styles.upiHeader}>
          <span className={styles.upiTitle}>Everything UPI</span>
          <img src="/assets/chevron-right.svg" alt="" className={styles.chevron} />
        </div>
        <div className={styles.upiGrid}>
          <div className={styles.upiBtn}>
            <div className={styles.upiBtnIcon}>
              <img src="/assets/icon-pay-friends.svg" alt="" />
            </div>
            <span className={styles.upiBtnLabel}>Pay{'\n'}friends</span>
          </div>
          <div className={styles.upiBtn}>
            <div className={styles.upiBtnIcon}>
              <img src="/assets/icon-bank.svg" alt="" className={styles.bankIcon} />
            </div>
            <span className={styles.upiBtnLabel}>To bank &{'\n'}self a/c</span>
          </div>
          <div className={styles.upiBtn}>
            <div className={styles.upiBtnIcon}>
              <img src="/assets/icon-balance-circle.svg" alt="" />
            </div>
            <span className={styles.upiBtnLabel}>Check{'\n'}balance</span>
          </div>
          <button className={styles.upiBtn} onClick={() => navigate('/insights')}>
            <div className={styles.upiBtnIcon}>
              <img src="/assets/icon-insights-circle.svg" alt="" />
            </div>
            <span className={styles.upiBtnLabel}>Pop{'\n'}Insights</span>
          </button>
        </div>
      </div>

      {/* UPI ID Pills */}
      {activeUser && (
        <div className={styles.pillRow}>
          <div className={styles.pill}>{activeUser.vpa}</div>
          <div className={styles.pill}>UPI Lite • Activate</div>
        </div>
      )}

      {/* Recharges and bills */}
      <div className={styles.section}>
        <div className={styles.sectionHeader}>
          <span className={styles.sectionTitle}>Recharges and bills</span>
          <img src="/assets/chevron-right.svg" alt="" className={styles.chevron} />
        </div>
        <div className={styles.rechargeRow}>
          <div className={`${styles.rechargeCard} ${styles.rechargeCardGreen}`}>
            <span className={styles.rechargeLabel}>Mobile prepaid</span>
          </div>
          <div className={`${styles.rechargeCard} ${styles.rechargeCardPurple}`}>
            <span className={styles.rechargeLabel}>Mobile prepaid</span>
          </div>
          <div className={`${styles.rechargeCard} ${styles.rechargeCardPurple}`}>
            <span className={styles.rechargeLabel}>Mobile postpaid</span>
          </div>
        </div>
      </div>

      {/* What more? */}
      <div className={styles.whatMore}>
        <img src="/assets/what-more.svg" alt="What more?" className={styles.whatMoreImg} />
      </div>

      {/* Featured Card */}
      <div className={styles.featuredSection}>
        <div className={styles.featuredCard} />
        <div className={styles.carouselDots}>
          <img src="/assets/carousel-dots.svg" alt="" className={styles.carouselDotsImg} />
        </div>
      </div>

      {/* Bottom spacing for nav */}
      <div className={styles.bottomSpacer} />

      <HomeNav />
    </div>
  );
}
