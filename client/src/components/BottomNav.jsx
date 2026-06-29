import { NavLink } from 'react-router-dom';
import styles from './BottomNav.module.css';

const navItems = [
  {
    path: '/breakdown',
    label: 'Breakdown',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
        <path d="M12 2v20M2 12h20" />
        <circle cx="12" cy="12" r="9" />
      </svg>
    ),
  },
  {
    path: '/trends',
    label: 'Trends',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
        <polyline points="3 17 9 11 13 15 21 7" />
        <polyline points="14 7 21 7 21 14" />
      </svg>
    ),
  },
  {
    path: '/recurring',
    label: 'Recurring',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
        <path d="M1 4v6h6" />
        <path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10" />
      </svg>
    ),
  },
];

export default function BottomNav({ basePath = '' }) {
  return (
    <nav className={styles.nav}>
      {navItems.map(({ path, label, icon }) => (
        <NavLink
          key={path}
          to={`${basePath}${path}`}
          end={path === '/'}
          className={({ isActive }) =>
            isActive ? `${styles.link} ${styles.active}` : styles.link
          }
        >
          <span className={styles.icon}>{icon}</span>
          <span className={styles.label}>{label}</span>
        </NavLink>
      ))}
    </nav>
  );
}
