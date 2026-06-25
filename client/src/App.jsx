import { useState, useEffect } from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import BottomNav from './components/BottomNav';
import Summary from './pages/Summary';
import Breakdown from './pages/Breakdown';
import Trends from './pages/Trends';
import Recurring from './pages/Recurring';
import { apiGet } from './api/client';
import styles from './App.module.css';

export default function App() {
  const [users, setUsers] = useState([]);
  const [userId, setUserId] = useState(null);
  const [showPicker, setShowPicker] = useState(false);

  useEffect(() => {
    apiGet('/api/users').then((data) => {
      setUsers(data.users);
      if (data.users.length) setUserId(data.users[0].id);
    });
  }, []);

  const activeUser = users.find((u) => u.id === userId);

  return (
    <BrowserRouter>
      <div className={styles.app}>
        <header className={styles.header}>
          <h1 className={styles.brand}>POP Insights</h1>
          {activeUser && (
            <button className={styles.avatar} onClick={() => setShowPicker(true)}>
              {activeUser.name.charAt(0)}
            </button>
          )}
        </header>
        <main className={styles.main}>
          {userId && (
            <Routes>
              <Route path="/" element={<Summary userId={userId} />} />
              <Route path="/breakdown" element={<Breakdown userId={userId} />} />
              <Route path="/trends" element={<Trends userId={userId} />} />
              <Route path="/recurring" element={<Recurring userId={userId} />} />
            </Routes>
          )}
        </main>
        <BottomNav />

        {showPicker && (
          <div className={styles.overlay} onClick={() => setShowPicker(false)}>
            <div className={styles.modal} onClick={(e) => e.stopPropagation()}>
              <div className={styles.modalHeader}>
                <h2 className={styles.modalTitle}>Select User</h2>
                <button className={styles.closeBtn} onClick={() => setShowPicker(false)}>
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M18 6L6 18M6 6l12 12" />
                  </svg>
                </button>
              </div>
              <div className={styles.userGrid}>
                {users.map((u) => (
                  <button
                    key={u.id}
                    className={`${styles.userCard} ${u.id === userId ? styles.userCardActive : ''}`}
                    onClick={() => { setUserId(u.id); setShowPicker(false); }}
                  >
                    <div className={`${styles.userAvatar} ${u.id === userId ? styles.userAvatarActive : ''}`}>
                      {u.name.charAt(0)}
                    </div>
                    <span className={styles.userName}>{u.name.split(' ')[0]}</span>
                  </button>
                ))}
              </div>
            </div>
          </div>
        )}
      </div>
    </BrowserRouter>
  );
}
