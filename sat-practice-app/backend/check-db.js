const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function checkDatabase() {
  try {
    const count = await prisma.question.count();
    console.log(`Total questions in database: ${count}`);
    
    const questions = await prisma.question.findMany({
      take: 5,
      select: {
        id: true,
        questionId: true,
        section: true,
        domain: true
      }
    });
    
    console.log('First 5 questions:');
    questions.forEach((q, i) => {
      console.log(`${i + 1}. ID: ${q.questionId}, Section: ${q.section}, Domain: ${q.domain}`);
    });
    
  } catch (error) {
    console.error('Error checking database:', error);
  } finally {
    await prisma.$disconnect();
  }
}

checkDatabase(); 