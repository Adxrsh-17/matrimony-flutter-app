const express = require('express');
const crypto = require('crypto');
const uuid = require('uuid');

const app = express();
const port = 3000;

// ✅ Your actual ImageKit private key
const privateAPIKey = 'private_TdQoVJ9YCgopStQxDP19KdtEHQc=';

// ✅ Your ImageKit URL endpoint
const urlEndpoint = 'https://ik.imagekit.io/sdjEvhaJsdjkj/';

app.get('/auth', (req, res) => {
  const token = uuid.v4();
  const expire = Math.floor(Date.now() / 1000) + 2400;
  const signature = crypto
    .createHmac('sha1', privateAPIKey)
    .update(token + expire)
    .digest('hex');

  res.json({
    token,
    expire,
    signature,
    urlEndpoint
  });
});

app.listen(port, () => {
  console.log(`✅ ImageKit auth backend running on http://localhost:${port}`);
});
