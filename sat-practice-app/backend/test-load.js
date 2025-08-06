const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const path = require('path');

const prisma = new PrismaClient();

async function loadTestQuestions() {
  try {
    const jsonPath = path.join(__dirname, '../data/cleaned_questions_full.json');
    console.log('Loading from:', jsonPath);
    
    if (!fs.existsSync(jsonPath)) {
      console.error('JSON file not found at:', jsonPath);
      return;
    }
    
    const questionsData = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));
    console.log(`Found ${questionsData.length} questions in JSON file`);
    
    // Load first 5 questions for testing
    const questionsToLoad = questionsData.slice(0, 5);
    
    for (const questionData of questionsToLoad) {
      try {
        // Check if question already exists
        const existingQuestion = await prisma.question.findUnique({
          where: { questionId: questionData.id }
        });
        
        if (existingQuestion) {
          console.log(`Question ${questionData.id} already exists, skipping`);
          continue;
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
        
        console.log(`Loaded question: ${questionData.id}`);
      } catch (error) {
        console.error(`Error processing question ${questionData.id}:`, error);
      }
    }
    
    console.log('Test loading completed');
  } catch (error) {
    console.error('Error in test load:', error);
  } finally {
    await prisma.$disconnect();
  }
}

loadTestQuestions(); 