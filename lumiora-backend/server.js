const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

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