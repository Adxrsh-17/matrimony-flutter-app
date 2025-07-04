const express = require('express');
const crypto = require('crypto');
const uuid = require('uuid');

const app = express();
const port = 3000;

const privateAPIKey = 'your_imagekit_private_key'; // Replace with your private key

app.get('/auth', (req, res) => {
  const token = uuid.v4();
  const expire = Math.floor(Date.now() / 1000) + 2400;
  const signature = crypto.createHmac('sha1', privateAPIKey).update(token + expire).digest('hex');

  res.json({ token, expire, signature });
});

app.listen(port, () => {
  console.log(`✅ ImageKit auth backend running on http://localhost:${port}`);
});
