import pg from 'pg';

const dbUrl = process.env.DATABASE_URL || '';
const useSSL = dbUrl.includes('railway');

const pool = new pg.Pool({
  connectionString: dbUrl,
  ssl: useSSL ? { rejectUnauthorized: false } : false,
});

export default pool;
