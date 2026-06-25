import { Router } from 'express';
import pool from '../db/pool.js';

const router = Router();

router.get('/', async (req, res) => {
  const { rows } = await pool.query('SELECT id, name, vpa FROM users ORDER BY name');
  res.json({ users: rows });
});

router.get('/:userId/summary', async (req, res) => {
  const { userId } = req.params;
  const { rows } = await pool.query(
    `SELECT
       COALESCE(SUM(amount) FILTER (WHERE status = 'success' AND operation = 'send'), 0) AS "totalSpend",
       COALESCE(SUM(cashback), 0) AS "totalCashback",
       COALESCE(SUM(coins_earned)::int, 0) AS "totalCoins",
       COALESCE(SUM(amount) FILTER (WHERE status = 'failed'), 0) AS "failedAmount",
       COUNT(*)::int AS "txnCount"
     FROM transactions WHERE user_id = $1`,
    [userId]
  );
  res.json(rows[0]);
});

router.get('/:userId/breakdown', async (req, res) => {
  const { userId } = req.params;
  const { rows } = await pool.query(
    `WITH cats AS (
       SELECT category AS name, SUM(amount) AS amount
       FROM transactions
       WHERE user_id = $1 AND status = 'success' AND operation = 'send'
       GROUP BY category
     )
     SELECT name, amount,
       ROUND(amount * 100.0 / NULLIF(SUM(amount) OVER (), 0), 1) AS percent
     FROM cats
     ORDER BY amount DESC`,
    [userId]
  );
  res.json({ categories: rows });
});

router.get('/:userId/trends', async (req, res) => {
  const { userId } = req.params;
  const { rows } = await pool.query(
    `SELECT
       TO_CHAR(DATE_TRUNC('month', transacted_at), 'YYYY-MM') AS month,
       COALESCE(SUM(amount) FILTER (WHERE status = 'success' AND operation = 'send'), 0) AS spend,
       COALESCE(SUM(cashback), 0) AS cashback
     FROM transactions
     WHERE user_id = $1
     GROUP BY DATE_TRUNC('month', transacted_at)
     ORDER BY DATE_TRUNC('month', transacted_at)`,
    [userId]
  );
  res.json({ months: rows });
});

router.get('/:userId/recurring', async (req, res) => {
  const { userId } = req.params;
  const { rows } = await pool.query(
    `SELECT
       payee_name AS "payeeName",
       COUNT(*)::int AS "txnCount",
       ROUND(AVG(amount)::numeric, 2) AS "avgAmount",
       ROUND(SUM(amount)::numeric, 2) AS "totalAmount"
     FROM transactions
     WHERE user_id = $1 AND status = 'success' AND operation = 'send'
     GROUP BY payee_name
     HAVING COUNT(*) >= 3
     ORDER BY COUNT(*) DESC`,
    [userId]
  );
  res.json({ recurring: rows });
});

router.get('/:userId/transactions', async (req, res) => {
  const { userId } = req.params;
  const limit = Math.min(parseInt(req.query.limit) || 50, 200);
  const offset = parseInt(req.query.offset) || 0;

  const { rows } = await pool.query(
    `SELECT id, payee_name AS "payeeName", payer_name AS "payerName",
       amount, status, operation, category, note,
       coins_earned AS "coinsEarned", cashback,
       transacted_at AS "transactedAt"
     FROM transactions
     WHERE user_id = $1
     ORDER BY transacted_at DESC
     LIMIT $2 OFFSET $3`,
    [userId, limit, offset]
  );
  res.json({ transactions: rows });
});

export default router;
