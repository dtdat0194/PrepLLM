const express = require('express');
const router = express.Router();
const questionController = require('../controllers/questionController');

// Get all questions with optional filters
router.get('/', questionController.getQuestions);

// Get available filters
router.get('/filters', questionController.getFilters);

// Get single question by ID
router.get('/:id', questionController.getQuestionById);

// Get single question by questionId
router.get('/by-question-id/:questionId', questionController.getQuestionByQuestionId);

// Bulk load questions from JSON file
router.post('/bulk-load', questionController.bulkLoadQuestions);

module.exports = router; 