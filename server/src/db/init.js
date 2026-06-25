import pool from './pool.js';

export async function initDb() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS users (
      id UUID PRIMARY KEY,
      name TEXT,
      vpa TEXT
    )
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS transactions (
      id TEXT PRIMARY KEY,
      user_id UUID REFERENCES users(id),
      payee_name TEXT,
      payer_name TEXT,
      amount NUMERIC,
      status TEXT,
      failure_reason TEXT,
      operation TEXT,
      transaction_type TEXT,
      category TEXT,
      note TEXT,
      coins_earned NUMERIC,
      cashback NUMERIC,
      transacted_at TIMESTAMPTZ
    )
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS monthly_insights (
      user_id UUID,
      month DATE,
      total_spend NUMERIC,
      total_cashback NUMERIC,
      total_coins INTEGER,
      failed_amount NUMERIC,
      txn_count INTEGER,
      PRIMARY KEY (user_id, month)
    )
  `);
}
