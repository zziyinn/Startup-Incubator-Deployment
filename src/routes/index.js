const express = require('express');
const router = express.Router();

// Example route
router.get('/', (req, res) => {
  res.json({
    message: 'Welcome to the Startup Incubator API',
    version: '1.0.0',
    documentation: '/api/docs'
  });
});

// Add more routes as needed
// router.use('/users', require('./users'));
// router.use('/projects', require('./projects'));

// Documentation route (you would implement this with Swagger or similar)
router.get('/docs', (req, res) => {
  res.json({
    message: 'API Documentation',
    endpoints: [
      { path: '/api', method: 'GET', description: 'API information' },
      { path: '/api/docs', method: 'GET', description: 'API documentation' },
      { path: '/health', method: 'GET', description: 'Health check endpoint' }
    ]
  });
});

module.exports = router; 