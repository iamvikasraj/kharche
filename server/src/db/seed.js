import 'dotenv/config';
import path from 'path';
import { fileURLToPath } from 'url';
import xlsx from 'xlsx';
import pool from './pool.js';
import { initDb } from './init.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const DATA_PATH = path.join(__dirname, '../../data/transactions.xlsx');

const MCC_MAP = {
  5411: 'Groceries',
  5812: 'Food & Dining',
  4722: 'Travel',
  5691: 'Shopping',
  7372: 'Tech',
  5413: 'Supermarkets',
  5661: 'Fashion',
  8062: 'Healthcare',
  4111: 'Transport',
  0: 'Other',
};

function toUuid(hex) {
  const h = hex.replace(/-/g, '');
  return `${h.slice(0, 8)}-${h.slice(8, 12)}-${h.slice(12, 16)}-${h.slice(16, 20)}-${h.slice(20)}`;
}

function mccToCategory(mcc) {
  const code = parseInt(String(mcc), 10);
  return MCC_MAP[code] ?? 'Other';
}

function extractUserVpa(row) {
  if (row.payer_vpa?.includes('@yespop')) return row.payer_vpa;
  if (row.payee_vpa?.includes('@yespop')) return row.payee_vpa;
  return row.payer_vpa || row.payee_vpa || null;
}

function num(val) {
  if (val === null || val === undefined || val === '') return 0;
  return Number(val);
}

async function upsertUsers(users) {
  const values = [];
  const placeholders = users.map((u, i) => {
    const offset = i * 3;
    values.push(u.id, u.name, u.vpa);
    return `($${offset + 1}, $${offset + 2}, $${offset + 3})`;
  });

  await pool.query(
    `INSERT INTO users (id, name, vpa) VALUES ${placeholders.join(', ')}
     ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name, vpa = EXCLUDED.vpa`,
    values
  );
}

async function upsertTransactions(batch) {
  const cols = 14;
  const values = [];
  const placeholders = batch.map((t, i) => {
    const offset = i * cols;
    values.push(
      t.id, t.user_id, t.payee_name, t.payer_name, t.amount,
      t.status, t.failure_reason, t.operation, t.transaction_type,
      t.category, t.note, t.coins_earned, t.cashback, t.transacted_at
    );
    const ps = Array.from({ length: cols }, (_, j) => `$${offset + j + 1}`);
    return `(${ps.join(', ')})`;
  });

  await pool.query(
    `INSERT INTO transactions (
      id, user_id, payee_name, payer_name, amount, status, failure_reason,
      operation, transaction_type, category, note, coins_earned, cashback, transacted_at
    ) VALUES ${placeholders.join(', ')}
    ON CONFLICT (id) DO UPDATE SET
      user_id = EXCLUDED.user_id,
      payee_name = EXCLUDED.payee_name,
      payer_name = EXCLUDED.payer_name,
      amount = EXCLUDED.amount,
      status = EXCLUDED.status,
      failure_reason = EXCLUDED.failure_reason,
      operation = EXCLUDED.operation,
      transaction_type = EXCLUDED.transaction_type,
      category = EXCLUDED.category,
      note = EXCLUDED.note,
      coins_earned = EXCLUDED.coins_earned,
      cashback = EXCLUDED.cashback,
      transacted_at = EXCLUDED.transacted_at`,
    values
  );
}

async function seed() {
  await initDb();

  const workbook = xlsx.readFile(DATA_PATH);
  const sheet = workbook.Sheets[workbook.SheetNames[0]];
  const rows = xlsx.utils.sheet_to_json(sheet);

  const userMap = new Map();
  for (const row of rows) {
    const id = toUuid(row.user_id);
    if (!userMap.has(id)) {
      userMap.set(id, {
        id,
        name: row.user_name,
        vpa: extractUserVpa(row),
      });
    }
  }

  const users = [...userMap.values()];
  await upsertUsers(users);
  console.log(`Upserted ${users.length} users`);

  const BATCH_SIZE = 500;
  let txnCount = 0;

  for (let i = 0; i < rows.length; i += BATCH_SIZE) {
    const batch = rows.slice(i, i + BATCH_SIZE).map((row) => ({
      id: row.pop_transaction_id,
      user_id: toUuid(row.user_id),
      payee_name: row.payee_name,
      payer_name: row.payer_name,
      amount: num(row['amount (in Rs)']),
      status: row.status,
      failure_reason: row.failure_reason || null,
      operation: row.operation,
      transaction_type: row.transaction_type,
      category: mccToCategory(row.payee_mcc),
      note: row.note || null,
      coins_earned: num(row.coins_earned),
      cashback: num(row['cashback_amount (in Rs)']),
      transacted_at: new Date(row.transaction_timestamp),
    }));

    await upsertTransactions(batch);
    txnCount += batch.length;
    console.log(`Upserted ${txnCount}/${rows.length} transactions`);
  }

  console.log('Seed complete');
  await pool.end();
}

seed().catch((err) => {
  console.error('Seed failed:', err);
  process.exit(1);
});
