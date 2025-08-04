const axios = require('axios');

async function testAPI() {
  try {
    console.log('Testing API endpoints...');
    
    // Test getting questions
    const response = await axios.get('http://localhost:3001/api/questions?limit=5');
    console.log('Questions response:', response.data);
    
    // Test getting a specific question
    if (response.data.questions && response.data.questions.length > 0) {
      const questionId = response.data.questions[0].id;
      const questionResponse = await axios.get(`http://localhost:3001/api/questions/${questionId}`);
      console.log('Single question response:', questionResponse.data);
    }
    
  } catch (error) {
    console.error('API test failed:', error.message);
  }
}

testAPI(); 