const express = require('express');
const admin = require('firebase-admin');
const bodyParser = require('body-parser');
const cors = require("cors");

const app = express();
app.use(cors()); // Enable CORS for all origins
app.use(bodyParser.json());

// Initialize Firebase Admin SDK
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// welcome route
app.get("/", (req, res) => {
  res.send("Welcome to the FCM REST API server!");
});

// Send notification to a single device
app.post('/send-notification', async (req, res) => {
  const { token, title, body, data } = req.body;

  if (!token || !title || !body) {
    return res.status(400).json({ error: 'token, title, and body are required' });
  }

  const message = {
    notification: {
      title,
      body,
    },
    data: data || {},
    token,
  };

  try {
    const response = await admin.messaging().send(message);
    return res.status(200).json({ success: true, messageId: response });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
});

// Send notification to multiple devices
app.post('/send-multicast', async (req, res) => {
  const { tokens, title, body, data } = req.body;

  if (!tokens || !Array.isArray(tokens) || tokens.length === 0 || !title || !body) {
    return res.status(400).json({ error: 'tokens (array), title, and body are required' });
  }

  const message = {
    notification: {
      title,
      body,
    },
    data: data || {},
    tokens,
  };

  try {
    const response = await admin.messaging().sendEachForMulticast(message);
    return res.status(200).json({
      success: true,
      successCount: response.successCount,
      failureCount: response.failureCount,
      responses: response.responses,
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
});

// Send notification to a topic
app.post('/send-to-topic', async (req, res) => {
  const { topic, title, body, data } = req.body;

  if (!topic || !title || !body) {
    return res.status(400).json({ error: 'topic, title, and body are required' });
  }

  const message = {
    notification: {
      title,
      body,
    },
    data: data || {},
    topic,
  };

  try {
    const response = await admin.messaging().send(message);
    return res.status(200).json({ success: true, messageId: response });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
});

// Subscribe tokens to a topic
app.post('/subscribe-to-topic', async (req, res) => {
  const { tokens, topic } = req.body;

  if (!tokens || !Array.isArray(tokens) || tokens.length === 0 || !topic) {
    return res.status(400).json({ error: 'tokens (array) and topic are required' });
  }

  try {
    const response = await admin.messaging().subscribeToTopic(tokens, topic);
    return res.status(200).json({
      success: true,
      successCount: response.successCount,
      failureCount: response.failureCount,
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
});

// Unsubscribe tokens from a topic
app.post('/unsubscribe-from-topic', async (req, res) => {
  const { tokens, topic } = req.body;

  if (!tokens || !Array.isArray(tokens) || tokens.length === 0 || !topic) {
    return res.status(400).json({ error: 'tokens (array) and topic are required' });
  }

  try {
    const response = await admin.messaging().unsubscribeFromTopic(tokens, topic);
    return res.status(200).json({
      success: true,
      successCount: response.successCount,
      failureCount: response.failureCount,
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`FCM REST API server running on port ${PORT}`);
});
