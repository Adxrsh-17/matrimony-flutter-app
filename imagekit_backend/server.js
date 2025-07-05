const express = require("express");
const ImageKit = require("imagekit");
const cors = require("cors");

const app = express();
app.use(cors());

const imagekit = new ImageKit({
  publicKey: "your_public_api_key",
  privateKey: "your_private_api_key",
  urlEndpoint: "https://ik.imagekit.io/your_imagekit_id"
});

// Endpoint to get authentication parameters
app.get("/auth", (req, res) => {
  const authParams = imagekit.getAuthenticationParameters();
  res.json(authParams);
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`✅ Server running on port ${PORT}`);
});
