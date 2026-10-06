const express = require('express');
const https = require('https');
const http = require('http');
const cors = require('cors');

const app = express();
const PORT = 3000;

app.use(cors());

// Proxy handler — fetches from Google and strips frame-blocking headers
app.use('/proxy', (req, res) => {
  // Reconstruct the target Google URL
  const targetPath = req.url; // everything after /proxy
  const targetUrl = `https://script.google.com${targetPath}`;

  console.log(`→ Proxying: ${targetUrl}`);

  const options = {
    hostname: 'script.google.com',
    path: targetPath,
    method: req.method,
    headers: {
      'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1',
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'Accept-Language': 'en-US,en;q=0.9',
    },
  };

  const proxyReq = https.request(options, (proxyRes) => {
    // Follow redirects (Google Apps Script redirects a lot)
    if (proxyRes.statusCode >= 300 && proxyRes.statusCode < 400 && proxyRes.headers.location) {
      const location = proxyRes.headers.location;
      console.log(`  ↳ Redirect to: ${location}`);

      // If redirect is to script.google.com, rewrite to go through proxy
      let newLocation = location;
      if (location.startsWith('https://script.google.com')) {
        newLocation = location.replace('https://script.google.com', `http://localhost:${PORT}/proxy`);
      }

      res.redirect(proxyRes.statusCode, newLocation);
      return;
    }

    // Strip headers that block framing
    const headers = { ...proxyRes.headers };
    delete headers['x-frame-options'];
    delete headers['content-security-policy'];
    delete headers['x-content-type-options'];
    // Remove transfer-encoding to avoid chunking issues
    delete headers['transfer-encoding'];

    res.writeHead(proxyRes.statusCode, headers);
    proxyRes.pipe(res);
  });

  proxyReq.on('error', (err) => {
    console.error('Proxy error:', err.message);
    res.status(502).send(`Proxy error: ${err.message}`);
  });

  if (req.method === 'POST') {
    req.pipe(proxyReq);
  } else {
    proxyReq.end();
  }
});

app.listen(PORT, () => {
  console.log(`✅ Proxy running at http://localhost:${PORT}`);
});
