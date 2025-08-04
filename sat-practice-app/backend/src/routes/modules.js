const express = require('express');
const router = express.Router();
const { getModules } = require('../controllers/moduleController');

// GET /api/modules - Get all modules
router.get('/', getModules);

module.exports = router; 