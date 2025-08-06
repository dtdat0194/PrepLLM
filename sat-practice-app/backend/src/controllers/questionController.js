const prisma = require('../models/prisma');

// Get questions with optional filters
const getQuestions = async (req, res) => {
  try {
    const { section, domain, skill, difficulty, type, questionId, page = 1, limit = 10 } = req.query;
    
    const where = {};
    
    if (section) {
      where.section = section;
    }
    
    if (domain) {
      where.domain = domain;
    }
    
    if (skill) {
      where.skill = {
        contains: skill
        // SQLite doesn't support 'mode: insensitive' - we'll handle case sensitivity in the query
      };
    }
    
    if (difficulty) {
      where.difficulty = parseInt(difficulty);
    }
    
    if (type) {
      where.type = type;
    }
    
    if (questionId) {
      where.questionId = questionId;
      console.log('Filtering by questionId:', questionId);
    }
    
    const skip = (parseInt(page) - 1) * parseInt(limit);
    
    console.log('Database query where clause:', where);
    const questions = await prisma.question.findMany({
      where,
      skip,
      take: parseInt(limit),
      orderBy: {
        createdAt: 'desc'
      }
    });
    console.log(`Found ${questions.length} questions`);
    
    // Parse JSON strings back to arrays for frontend
    const processedQuestions = questions.map(question => ({
      ...question,
      choices: JSON.parse(question.choices || '[]'),
      correctAnswer: JSON.parse(question.correctAnswer || '[]')
    }));
    
    const total = await prisma.question.count({ where });
    
    res.json({
      questions: processedQuestions,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / parseInt(limit))
      }
    });
  } catch (error) {
    console.error('Error fetching questions:', error);
    res.status(500).json({ error: 'Failed to fetch questions' });
  }
};

// Get single question by ID
const getQuestionById = async (req, res) => {
  try {
    const { id } = req.params;
    
    const question = await prisma.question.findUnique({
      where: { id }
    });
    
    if (!question) {
      return res.status(404).json({ error: 'Question not found' });
    }
    
    // Parse JSON strings back to arrays
    const processedQuestion = {
      ...question,
      choices: JSON.parse(question.choices || '[]'),
      correctAnswer: JSON.parse(question.correctAnswer || '[]')
    };
    
    res.json(processedQuestion);
  } catch (error) {
    console.error('Error fetching question:', error);
    res.status(500).json({ error: 'Failed to fetch question' });
  }
};

// Get single question by questionId
const getQuestionByQuestionId = async (req, res) => {
  try {
    const { questionId } = req.params;
    
    const question = await prisma.question.findUnique({
      where: { questionId }
    });
    
    if (!question) {
      return res.status(404).json({ error: 'Question not found' });
    }
    
    // Parse JSON strings back to arrays
    const processedQuestion = {
      ...question,
      choices: JSON.parse(question.choices || '[]'),
      correctAnswer: JSON.parse(question.correctAnswer || '[]')
    };
    
    res.json(processedQuestion);
  } catch (error) {
    console.error('Error fetching question:', error);
    res.status(500).json({ error: 'Failed to fetch question' });
  }
};

// Get available filters
const getFilters = async (req, res) => {
  try {
    const sections = await prisma.question.findMany({
      select: { section: true },
      distinct: ['section']
    });
    
    const domains = await prisma.question.findMany({
      select: { domain: true },
      distinct: ['domain']
    });
    
    const skills = await prisma.question.findMany({
      select: { skill: true },
      distinct: ['skill']
    });
    
    const types = await prisma.question.findMany({
      select: { type: true },
      distinct: ['type']
    });
    
    res.json({
      sections: sections.map(s => s.section),
      domains: domains.map(d => d.domain),
      skills: skills.map(s => s.skill),
      types: types.map(t => t.type),
      difficulties: [1, 2, 3] // Easy, Medium, Hard
    });
  } catch (error) {
    console.error('Error fetching filters:', error);
    res.status(500).json({ error: 'Failed to fetch filters' });
  }
};

// Bulk load questions from JSON file
const bulkLoadQuestions = async (req, res) => {
  try {
    const fs = require('fs');
    const path = require('path');
    
    const jsonPath = path.join(__dirname, '../../data/cleaned_questions_full.json');
    console.log('JSON file path:', jsonPath);
    console.log('File exists:', fs.existsSync(jsonPath));
    const questionsData = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));
    
    let processed = 0;
    let errors = 0;
    let skipped = 0;
    
    for (const questionData of questionsData) {
      try {
        // Check if question already exists
        const existingQuestion = await prisma.question.findUnique({
          where: { questionId: questionData.id }
        });
        
        if (existingQuestion) {
          skipped++;
          continue; // Skip if already exists
        }
        
        // Convert arrays to JSON strings for SQLite
        const choicesJson = JSON.stringify(questionData.question.choices || []);
        const correctAnswerJson = JSON.stringify(questionData.question.correct_answer || []);
        
        // Create question with new structure
        const question = await prisma.question.create({
          data: {
            questionId: questionData.id,
            program: questionData.program,
            section: questionData.section,
            domain: questionData.domain,
            skill: questionData.skill,
            difficulty: questionData.difficulty,
            type: questionData.type,
            paragraph: questionData.question.paragraph,
            questionText: questionData.question.question,
            choices: choicesJson,
            correctAnswer: correctAnswerJson,
            explanation: questionData.question.explanation,
            visualType: questionData.visuals.type,
            svgContent: questionData.visuals.svg_content,
            imageUrl: questionData.image_url
          }
        });
        
        processed++;
      } catch (error) {
        console.error(`Error processing question ${questionData.id}:`, error);
        errors++;
      }
    }
    
    res.json({
      message: 'Bulk load completed',
      processed,
      errors,
      skipped
    });
  } catch (error) {
    console.error('Error in bulk load:', error);
    res.status(500).json({ error: 'Failed to bulk load questions' });
  }
};

module.exports = {
  getQuestions,
  getQuestionById,
  getQuestionByQuestionId,
  getFilters,
  bulkLoadQuestions
};