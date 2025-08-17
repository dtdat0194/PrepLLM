// Static JSON data loader
let questionsCache = null;

const loadQuestions = async () => {
  if (questionsCache) return questionsCache;
  
  try {
    // Use process.env.PUBLIC_URL to handle GitHub Pages subdirectory
    const questionsUrl = `${process.env.PUBLIC_URL || ''}/questions.json`;
    console.log('Loading questions from:', questionsUrl);
    const response = await fetch(questionsUrl);
    if (!response.ok) {
      throw new Error(`Failed to load questions data: ${response.status} ${response.statusText}`);
    }
    questionsCache = await response.json();
    console.log(`Loaded ${questionsCache.length} questions from static JSON`);
    return questionsCache;
  } catch (error) {
    console.error('Error loading questions:', error);
    throw error;
  }
};

// Questions API - Static version
export const questionsAPI = {
  // Get questions with optional filters
  getQuestions: async (params = {}) => {
    const allQuestions = await loadQuestions();
    let filteredQuestions = [...allQuestions];
    
    // Apply filters
    if (params.section) {
      filteredQuestions = filteredQuestions.filter(q => q.section === params.section);
    }
    if (params.domain) {
      filteredQuestions = filteredQuestions.filter(q => q.domain === params.domain);
    }
    if (params.skill) {
      filteredQuestions = filteredQuestions.filter(q => q.skill === params.skill);
    }
    if (params.difficulty) {
      filteredQuestions = filteredQuestions.filter(q => q.difficulty === parseInt(params.difficulty));
    }
    if (params.type) {
      filteredQuestions = filteredQuestions.filter(q => q.type === params.type);
    }
    if (params.questionId) {
      filteredQuestions = filteredQuestions.filter(q => q.id === params.questionId);
    }
    
    // Apply pagination
    const limit = parseInt(params.limit) || 50;
    const offset = parseInt(params.offset) || 0;
    const page = parseInt(params.page) || 1;
    const startIndex = offset || ((page - 1) * limit);
    const endIndex = startIndex + limit;
    
    const paginatedQuestions = filteredQuestions.slice(startIndex, endIndex);
    
    console.log(`Filtered ${filteredQuestions.length} questions, returning ${paginatedQuestions.length}`);
    
    return {
      questions: paginatedQuestions,
      total: filteredQuestions.length,
      limit: limit,
      offset: startIndex,
      page: page
    };
  },

  // Get single question by ID
  getQuestionById: async (id) => {
    const allQuestions = await loadQuestions();
    const question = allQuestions.find(q => q.id === id);
    
    if (!question) {
      throw new Error('Question not found');
    }
    
    return { question };
  },

  // Get single question by questionId
  getQuestionByQuestionId: async (questionId) => {
    const allQuestions = await loadQuestions();
    const question = allQuestions.find(q => q.id === questionId);
    
    if (!question) {
      throw new Error('Question not found');
    }
    
    return { question };
  },

  // Get available filters
  getFilters: async () => {
    const allQuestions = await loadQuestions();
    
    const sections = [...new Set(allQuestions.map(q => q.section))].filter(Boolean);
    const domains = [...new Set(allQuestions.map(q => q.domain))].filter(Boolean);
    const skills = [...new Set(allQuestions.map(q => q.skill))].filter(Boolean);
    const difficulties = [...new Set(allQuestions.map(q => q.difficulty))].filter(Boolean).sort((a, b) => a - b);
    const types = [...new Set(allQuestions.map(q => q.type))].filter(Boolean);
    
    return {
      sections,
      domains,
      skills,
      difficulties,
      types
    };
  },

  // Bulk load questions (already loaded)
  bulkLoadQuestions: async () => {
    const questions = await loadQuestions();
    return { 
      message: 'Questions loaded successfully',
      count: questions.length
    };
  }
};

// Skills API (static version)
export const skillsAPI = {
  getSkills: async () => {
    const filters = await questionsAPI.getFilters();
    return filters.skills.map(skill => ({ name: skill }));
  }
};

// Modules API (static version)
export const modulesAPI = {
  getModules: async () => {
    const filters = await questionsAPI.getFilters();
    return filters.domains.map(domain => ({ name: domain }));
  }
}; 