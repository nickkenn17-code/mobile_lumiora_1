const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const bcrypt = require('bcryptjs');

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Database Connection Configuration
// Replace these values with your actual PostgreSQL credentials
const pool = new Pool({
  user: 'postgres',       // Your default PostgreSQL username
  host: 'localhost',
  database: 'lumiora_db', // The name of the database where you ran the SQL script
  password: '123', // Your PostgreSQL password
  port: 5432,
});

app.get('/', (req, res) => {
  res.send('lumiora app API wooooooooooooooooooooooo');
});

// The API Endpoint
// When Flutter asks for data, this queries the database and sends JSON back
app.get('/api/menu', async (req, res) => {
  try {
    console.log('Fetching menu items...');
    const result = await pool.query('SELECT * FROM menu_items');
    
    // Send the rows back as a JSON array
    res.json(result.rows);
  } catch (error) {
    console.error('Error executing query', error.stack);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Lumiora API is online and running at http://localhost:${port}`);
});

// Simple login endpoint
app.post('/api/login', async (req, res) => {
  const { username, phone, password } = req.body;
  if (!username || !password || !phone) {
    return res.status(400).json({ success: false, message: 'Missing username, phone number, or password' });
  }

  try {
    const result = await pool.query('SELECT password, phone FROM users WHERE username = $1', [username]);
    if (result.rows.length === 0) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    const stored = result.rows[0].password;

    // If stored value looks like a bcrypt hash, use bcrypt.compare
    if (typeof stored === 'string' && stored.startsWith('$2')) {
      const match = await bcrypt.compare(password, stored);
      if (match) return res.json({ success: true, phone });
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    // Otherwise, fallback to plain-text comparison (demo only)
    if (password === stored) {
      return res.json({ success: true });
    }

    // Also allow SHA256 hex match if stored is 64-char hex
    const isHex64 = typeof stored === 'string' && /^[a-f0-9]{64}$/.test(stored);
    if (isHex64) {
      const crypto = require('crypto');
      const hash = crypto.createHash('sha256').update(password).digest('hex');
      if (hash === stored) return res.json({ success: true });
    }

    return res.status(401).json({ success: false, message: 'Invalid credentials' });
  } catch (error) {
    console.error('Login error', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});