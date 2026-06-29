import { useState, useEffect } from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Home from './pages/Home';
import Shop from './pages/Shop';
import Card from './pages/Card';
import Insights from './pages/Insights';
import { apiGet, getSummary } from './api/client';
import styles from './App.module.css';

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
  let hash = 0;
  for (let i = 0; i < id.length; i++) hash = ((hash << 5) - hash + id.charCodeAt(i)) | 0;
  return GRADIENTS[Math.abs(hash) % GRADIENTS.length];
}

export default function App() {
  const [users, setUsers] = useState([]);
  const [userId, setUserId] = useState(null);
  const [showPicker, setShowPicker] = useState(false);
  const [summary, setSummary] = useState(null);
  const [highlighted, setHighlighted] = useState(null);

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
  const previewUser = users.find((u) => u.id === (highlighted ?? userId));
  const previewColors = previewUser ? gradientFor(previewUser.id) : GRADIENTS[0];

  return (
    <BrowserRouter>
      <Routes>
        <Route
          path="/"
          element={
            <Home
              activeUser={activeUser}
              onAvatarClick={() => { setHighlighted(null); setShowPicker(true); }}
              summary={summary}
            />
          }
        />
        <Route path="/shop" element={<Shop />} />
        <Route path="/card" element={<Card />} />
        <Route
          path="/insights"
          element={userId && <Insights userId={userId} summary={summary} />}
        />
      </Routes>

      {showPicker && (
        <div className={styles.pickerPage}>
          {/* Top bar */}
          <div className={styles.pickerTop}>
            <button className={styles.pickerClose} onClick={() => setShowPicker(false)}>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                <path d="M18 6L6 18M6 6l12 12" />
              </svg>
            </button>
            <span className={styles.pickerTitle}>Switch User</span>
            <div style={{ width: 32 }} />
          </div>

          {/* Preview */}
          {previewUser && (
            <div className={styles.pickerPreview}>
              <div
                className={styles.previewAvatar}
                style={{ background: `linear-gradient(to bottom, ${previewColors[0]}, ${previewColors[1]})` }}
              >
                <img src="/assets/avatar.png" alt="" className={styles.previewAvatarImg} />
              </div>
              <span className={styles.previewName}>{previewUser.name}</span>
              <span className={styles.previewVpa}>{previewUser.vpa}</span>
            </div>
          )}

          {/* Divider */}
          <div className={styles.pickerDivider} />

          {/* Grid */}
          <div className={styles.pickerGrid}>
            {users.map((u) => {
              const colors = gradientFor(u.id);
              const isActive = u.id === (highlighted ?? userId);
              return (
                <button
                  key={u.id}
                  className={styles.pickerUser}
                  onClick={() => {
                    setHighlighted(u.id);
                    setUserId(u.id);
                    setTimeout(() => setShowPicker(false), 300);
                  }}
                >
                  <div
                    className={`${styles.pickerUserAvatar} ${isActive ? styles.pickerUserActive : ''}`}
                    style={{ background: `linear-gradient(to bottom, ${colors[0]}, ${colors[1]})` }}
                  >
                    <img src="/assets/avatar.png" alt="" className={styles.pickerUserAvatarImg} />
                  </div>
                  <span className={`${styles.pickerUserName} ${isActive ? styles.pickerUserNameActive : ''}`}>
                    {u.name.split(' ')[0]}
                  </span>
                </button>
              );
            })}
          </div>
        </div>
      )}
    </BrowserRouter>
  );
}
