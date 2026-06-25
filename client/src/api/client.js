const isLocal = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1';
const BASE_URL = isLocal
  ? `http://${window.location.hostname}:3000`
  : 'https://server-production-dd0d.up.railway.app';

export async function apiGet(path) {
  const res = await fetch(`${BASE_URL}${path}`);
  if (!res.ok) throw new Error(`API error: ${res.status}`);
  return res.json();
}

export const getSummary = (userId) => apiGet(`/api/users/${userId}/summary`);
export const getBreakdown = (userId) => apiGet(`/api/users/${userId}/breakdown`);
export const getTrends = (userId) => apiGet(`/api/users/${userId}/trends`);
export const getRecurring = (userId) => apiGet(`/api/users/${userId}/recurring`);
export const getTransactions = (userId) => apiGet(`/api/users/${userId}/transactions`);
