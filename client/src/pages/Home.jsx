import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import HomeNav from '../components/HomeNav';
import styles from './Home.module.css';

const GRADIENTS = [
  ['#FF720C', '#CB1400'],
  ['#6366F1', '#4338CA'],
  ['#22C55E', '#15803D'],
  ['#F59E0B', '#D97706'],
  ['#EC4899', '#BE185D'],
  ['#06B6D4', '#0E7490'],
  ['#8B5CF6', '#6D28D9'],
  ['#EF4444', '#B91C1C'],
];

function gradientFor(id) {
  if (!id) return GRADIENTS[0];
  let hash = 0;
  for (let i = 0; i < id.length; i++) hash = ((hash << 5) - hash + id.charCodeAt(i)) | 0;
  return GRADIENTS[Math.abs(hash) % GRADIENTS.length];
}

export default function Home({ activeUser, onAvatarClick, summary }) {
  const navigate = useNavigate();
  const [carouselPage, setCarouselPage] = useState(0);
  const pageCount = 6;

  const colors = gradientFor(activeUser?.id);
  const coinsFormatted = (() => {
    const coins = summary?.totalCoins ?? 0;
    if (coins >= 1000) {
      const k = coins / 1000;
      return k % 1 === 0 ? `${k}k` : `${k.toFixed(1)}k`;
    }
    return `${coins}`;
  })();

  return (
    <div className={styles.page}>
      {/* Sticky Top Bar */}
      <div className={styles.heroTop}>
        <button
          className={styles.userDot}
          style={{ background: `linear-gradient(to bottom, ${colors[0]}, ${colors[1]})` }}
          onClick={onAvatarClick}
        >
          <img src="/assets/avatar.png" alt="" className={styles.avatarImg} />
        </button>
        <div className={styles.coinBadge}>
          <img src="/assets/pop-coin.png" alt="" className={styles.coinIcon} />
          <span className={styles.coinText}>{coinsFormatted}</span>
        </div>
      </div>

      {/* Hero Section */}
      <div className={styles.hero}>
        <img src="/assets/hero.png" alt="" className={styles.heroBg} />
      </div>

      {/* Banner Cards */}
      <div className={styles.bannerRow}>
        {[0, 1, 2].map((i) => (
          <img key={i} src="/assets/banner-1.png" alt="" className={styles.bannerCard} />
        ))}
      </div>

      {/* Everything UPI */}
      <div className={styles.upiSection}>
        <div className={styles.upiHeader}>
          <span className={styles.upiTitle}>Everything UPI</span>
          <img src="/assets/chevron-right.png" alt="" className={styles.chevron} />
        </div>
        <div className={styles.upiGrid}>
          <div className={styles.upiBtn}>
            <div className={styles.upiBtnIcon}>
              <img src="/assets/icon-pay-friends.png" alt="" />
            </div>
            <span className={styles.upiBtnLabel}>{'Pay\nfriends'}</span>
          </div>
          <div className={styles.upiBtn}>
            <div className={styles.upiBtnIcon}>
              <img src="/assets/icon-bank.png" alt="" />
            </div>
            <span className={styles.upiBtnLabel}>{'To bank &\nself a/c'}</span>
          </div>
          <div className={styles.upiBtn}>
            <div className={styles.upiBtnIcon}>
              <img src="/assets/icon-balance.png" alt="" />
            </div>
            <span className={styles.upiBtnLabel}>{'Check\nbalance'}</span>
          </div>
          <button className={styles.upiBtn} onClick={() => navigate('/insights')}>
            <div className={styles.upiBtnIcon}>
              <img src="/assets/icon-insights.png" alt="" />
            </div>
            <span className={styles.upiBtnLabel}>{'Pop\nInsights'}</span>
          </button>
        </div>
      </div>

      {/* UPI ID Pills */}
      {activeUser && (
        <div className={styles.pillRow}>
          <div className={styles.pill}>{activeUser.vpa}</div>
          <div className={styles.pill}>
            <span>UPI Lite</span>
            <span className={styles.pillDot} />
            <span>Activate</span>
          </div>
        </div>
      )}

      {/* Recharges and bills */}
      <div className={styles.section}>
        <div className={styles.sectionHeader}>
          <span className={styles.sectionTitle}>Recharges and bills</span>
          <img src="/assets/chevron-right.png" alt="" className={styles.chevron} />
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
        <img src="/assets/what-more.png" alt="What more?" className={styles.whatMoreImg} />
      </div>

      {/* Featured Carousel */}
      <div className={styles.featuredSection}>
        <div className={styles.carouselTrack}>
          {Array.from({ length: pageCount }).map((_, i) => (
            <img
              key={i}
              src="/assets/cashback-promo.png"
              alt=""
              className={styles.carouselSlide}
              style={{ display: i === carouselPage ? 'block' : 'none' }}
            />
          ))}
        </div>
        <div className={styles.carouselDots}>
          {Array.from({ length: pageCount }).map((_, i) => (
            <button
              key={i}
              className={`${styles.dot} ${i === carouselPage ? styles.dotActive : ''}`}
              onClick={() => setCarouselPage(i)}
            />
          ))}
        </div>
      </div>

      {/* Footer */}
      <div className={styles.footerSection}>
        <img src="/assets/footer.png" alt="" className={styles.footerImg} />
      </div>

      <div className={styles.bottomSpacer} />
      <HomeNav />
    </div>
  );
}
