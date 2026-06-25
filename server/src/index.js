import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import { initDb } from './db/init.js';
import usersRouter from './routes/users.js';

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.use('/api/users', usersRouter);

async function start() {
  await initDb();
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`POP Insights server running on http://localhost:${PORT}`);
  });
}

start().catch((err) => {
  console.error('Failed to start server:', err);
  process.exit(1);
});
