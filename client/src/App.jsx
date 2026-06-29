import { useState, useEffect } from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Home from './pages/Home';
import Shop from './pages/Shop';
import Card from './pages/Card';
import Insights from './pages/Insights';
import { apiGet, getSummary } from './api/client';
import styles from './App.module.css';

export default function App() {
  const [users, setUsers] = useState([]);
  const [userId, setUserId] = useState(null);
  const [showPicker, setShowPicker] = useState(false);
  const [summary, setSummary] = useState(null);

  useEffect(() => {
    apiGet('/api/users').then((data) => {
      setUsers(data.users);
      if (data.users.length) setUserId(data.users[0].id);
    });
  }, []);

  useEffect(() => {
    if (userId) getSummary(userId).then(setSummary);
  }, [userId]);

  const activeUser = users.find((u) => u.id === userId);

  return (
    <BrowserRouter>
      <Routes>
        <Route
          path="/"
          element={
            <Home
              activeUser={activeUser}
              onAvatarClick={() => setShowPicker(true)}
              summary={summary}
            />
          }
        />
        <Route path="/shop" element={<Shop />} />
        <Route path="/card" element={<Card />} />
        <Route
          path="/insights/*"
          element={userId && <Insights userId={userId} summary={summary} />}
        />
      </Routes>

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
    </BrowserRouter>
  );
}
