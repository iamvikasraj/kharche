import { useNavigate, useLocation } from 'react-router-dom';
import styles from './HomeNav.module.css';

const tabs = [
  { path: '/', label: 'Home' },
  { path: '/shop', label: 'Shop' },
  { path: '/card', label: 'Card' },
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
                src={isActive ? '/assets/nav-home.svg' : '/assets/nav-inactive.svg'}
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
      <button className={styles.scanBtn} onClick={() => navigate('/insights')}>
        <img src="/assets/nav-scan.svg" alt="" className={styles.scanIcon} />
      </button>
    </div>
  );
}
