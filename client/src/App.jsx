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

  useEffect(() => {
    apiGet('/api/users').then((data) => {
      setUsers(data.users);
      if (data.users.length) setUserId(data.users[0].id);
    });
  }, []);

  return (
    <BrowserRouter>
      <div className={styles.app}>
        <header className={styles.header}>
          <h1 className={styles.brand}>POP Insights</h1>
          {users.length > 0 && (
            <select
              className={styles.userPicker}
              value={userId || ''}
              onChange={(e) => setUserId(e.target.value)}
            >
              {users.map((u) => (
                <option key={u.id} value={u.id}>{u.name}</option>
              ))}
            </select>
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
      </div>
    </BrowserRouter>
  );
}
