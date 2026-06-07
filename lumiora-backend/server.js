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
// This connects to the shared database container defined in the root docker-compose.yml
const pool = new Pool({
  user: 'postgres',     
  host: 'postgres',        // The name of the database service in docker-compose
  database: 'lumiora_db', 
  password: '123', 
  port: 5432,
});

app.get('/', (req, res) => {
  res.send('lumiora app API wooooooooooooooooooooooo');
});

// GET Menu - Reads from Django's menu table
app.get('/api/menu', async (req, res) => {
  try {
    console.log('Fetching menu items...');
    // We are now reading from Django's app_menuitem table
    const result = await pool.query('SELECT * FROM app_menuitem');
    res.json(result.rows);
  } catch (error) {
    console.error('Error executing query', error.stack);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

/**
 * POST /api/orders
 * Receives order from Flutter and saves to Django tables so CMS can see it.
 */
app.post('/api/orders', async (req, res) => {
  const { customer, items, totalAmount, notes } = req.body;

  if (!customer || !items || items.length === 0) {
    return res.status(400).json({ success: false, message: 'Missing order details' });
  }

  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    // 1. Get or Create Customer in 'app_customer' table
    let customerId;
    const customerRes = await client.query(
      'SELECT id FROM app_customer WHERE email = $1',
      [customer.email]
    );

    if (customerRes.rows.length > 0) {
      customerId = customerRes.rows[0].id;
    } else {
      const newCust = await client.query(
        `INSERT INTO app_customer 
        (email, phone, first_name, last_name, is_active, total_orders, total_spent, created_at, updated_at, address, city, postal_code) 
        VALUES ($1, $2, $3, $4, true, 1, $5, NOW(), NOW(), '', '', '') RETURNING id`,
        [customer.email, customer.phone, customer.firstName || 'Guest', customer.lastName || '', totalAmount]
      );
      customerId = newCust.rows[0].id;
    }

    // 2. Create the Order in 'app_order' table
    const orderRes = await client.query(
      `INSERT INTO app_order (customer_id, status, total_amount, notes, created_at, updated_at) 
       VALUES ($1, 'pending', $2, $3, NOW(), NOW()) RETURNING id`,
      [customerId, totalAmount, notes || '']
    );
    const orderId = orderRes.rows[0].id;

    // 3. Create Order Items in 'app_orderitem' table
    for (const item of items) {
      // NOTE: item.menu_item_id MUST be the integer ID from 'app_menuitem'
      await client.query(
        `INSERT INTO app_orderitem (order_id, menu_item_id, quantity, price) 
         VALUES ($1, $2, $3, $4)`,
        [orderId, item.menu_item_id, item.qty, item.price]
      );
    }

    await client.query('COMMIT');
    res.status(201).json({ success: true, orderId: orderId });

  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Order processing error:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  } finally {
    client.release();
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