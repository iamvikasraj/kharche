import { useNavigate, useLocation } from 'react-router-dom';
import styles from './HomeNav.module.css';

const tabs = [
  { path: '/', label: 'Home', icon: '/assets/nav-home-inactive.svg', activeIcon: '/assets/nav-home-active.svg' },
  { path: '/shop', label: 'Shop', icon: '/assets/nav-shop-inactive.svg', activeIcon: '/assets/nav-shop-active.svg' },
  { path: '/card', label: 'Card', icon: '/assets/nav-card-inactive.svg', activeIcon: '/assets/nav-card-active.svg' },
];

export default function HomeNav() {
  const navigate = useNavigate();
  const { pathname } = useLocation();

  return (
    <div className={styles.bottomBar}>
      <div className={styles.navPill}>
        {tabs.map((tab) => {
          const isActive = pathname === tab.path;
          return (
            <button
              key={tab.path}
              className={`${styles.navTab} ${isActive ? styles.navTabActive : ''}`}
              onClick={() => navigate(tab.path)}
            >
              <img
                src={isActive ? tab.activeIcon : tab.icon}
                alt=""
                className={styles.navIcon}
              />
              <span className={isActive ? styles.navLabelActive : styles.navLabel}>
                {tab.label}
              </span>
            </button>
          );
        })}
      </div>
      <button className={styles.scanBtn}>
        <img src="/assets/nav-scan.svg" alt="" className={styles.scanIcon} />
      </button>
    </div>
  );
}
