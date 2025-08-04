const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const path = require('path');

const prisma = new PrismaClient();

async function main() {
  console.log('Starting database seed...');
  
  try {
    // Read the new JSON file
    const jsonPath = path.join(__dirname, '../../../cleaned_questions_full.json');
    const questionsData = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));
    
    console.log(`Found ${questionsData.length} questions to process`);
    
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
            choices: questionData.question.choices || [],
            correctAnswer: questionData.question.correct_answer || [],
            explanation: questionData.question.explanation,
            visualType: questionData.visuals.type,
            svgContent: questionData.visuals.svg_content,
            imageUrl: questionData.image_url
          }
        });
        
        processed++;
        
        if (processed % 100 === 0) {
          console.log(`Processed ${processed} questions...`);
        }
      } catch (error) {
        console.error(`Error processing question ${questionData.id}:`, error);
        errors++;
      }
    }
    
    console.log('Seed completed!');
    console.log(`Processed: ${processed}`);
    console.log(`Skipped: ${skipped}`);
    console.log(`Errors: ${errors}`);
    
  } catch (error) {
    console.error('Error in seed:', error);
    throw error;
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  }); 