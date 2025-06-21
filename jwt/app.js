const express = require('express');
const jwt = require('jsonwebtoken');
const fs = require('fs');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
app.use(bodyParser.json());

const ACCESS_TOKEN_EXPIRY='15m'
const REFRESH_TOKEN_EXPIRY='7d'

// Load RSA Keys
const privateKey = fs.readFileSync('private.key', 'utf8');
const publicKey = fs.readFileSync('public.key', 'utf8');
console.log("privateKey",privateKey);

// Simulated User Data
const users = [
  { id: 1, username: 'john', mpin: '1234' },
  { id: 2, username: 'jane', mpin: '5678' },
];

// In-memory Refresh Token Store
let refreshTokens = [];

// Generate Tokens
function generateAccessToken(user) {
  return jwt.sign({ id: user.id, username: user.username }, privateKey, {
    algorithm: 'ES256',
    expiresIn: ACCESS_TOKEN_EXPIRY,
  });
}

function generateRefreshToken(user) {
  const refreshToken = jwt.sign({ id: user.id }, privateKey, {
    algorithm: 'ES256',
    expiresIn: REFRESH_TOKEN_EXPIRY,
  });
  refreshTokens.push(refreshToken);
  return refreshToken;
}

// Login Endpoint
app.post('/login', (req, res) => {
  const { username, mpin } = req.body;

  // Validate user credentials
  const user = users.find(u => u.username === username && u.mpin === mpin);
  if (!user) {
    return res.status(401).json({ message: 'Invalid username or MPIN' });
  }

  // Generate tokens
  const accessToken = generateAccessToken(user);
  const refreshToken = generateRefreshToken(user);

  res.json({ accessToken, refreshToken });
});

// Refresh Token Endpoint
app.post('/token', (req, res) => {
  const { refreshToken } = req.body;

  // Check if the refresh token exists
  if (!refreshToken || !refreshTokens.includes(refreshToken)) {
    return res.status(403).json({ message: 'Invalid refresh token' });
  }

  // Verify refresh token
  jwt.verify(refreshToken, publicKey, { algorithms: ['RS256'] }, (err, user) => {
    if (err) return res.status(403).json({ message: 'Invalid refresh token' });

    // Generate new access token
    const newAccessToken = generateAccessToken({ id: user.id, username: user.username });
    res.json({ accessToken: newAccessToken });
  });
});

// Protected Route
app.get('/protected', (req, res) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return res.status(401).json({ message: 'Token is missing' });

  // Verify access token
  jwt.verify(token, publicKey, { algorithms: ['RS256'] }, (err, user) => {
    if (err) return res.status(403).json({ message: 'Invalid or expired token' });

    res.json({ message: 'Protected data', user });
  });
});

// Logout Endpoint (Revoke Refresh Token)
app.post('/logout', (req, res) => {
  const { refreshToken } = req.body;

  refreshTokens = refreshTokens.filter(token => token !== refreshToken);
  res.json({ message: 'Logged out successfully' });
});

// Start Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
