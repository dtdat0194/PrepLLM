const API_BASE_URL = 'http://localhost:5001/api';

// Questions API
export const questionsAPI = {
  // Get questions with optional filters
  getQuestions: async (params = {}) => {
    const queryParams = new URLSearchParams();
    
    if (params.section) queryParams.append('section', params.section);
    if (params.domain) queryParams.append('domain', params.domain);
    if (params.skill) queryParams.append('skill', params.skill);
    if (params.difficulty) queryParams.append('difficulty', params.difficulty);
    if (params.type) queryParams.append('type', params.type);
    if (params.questionId) queryParams.append('questionId', params.questionId);
    if (params.page) queryParams.append('page', params.page);
    if (params.limit) queryParams.append('limit', params.limit);
    
    const url = `${API_BASE_URL}/questions?${queryParams}`;
    console.log('API call URL:', url);
    
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error('Failed to fetch questions');
    }
    return response.json();
  },

  // Get single question by ID
  getQuestionById: async (id) => {
    const response = await fetch(`${API_BASE_URL}/questions/${id}`);
    if (!response.ok) {
      throw new Error('Failed to fetch question');
    }
    return response.json();
  },

  // Get single question by questionId
  getQuestionByQuestionId: async (questionId) => {
    const response = await fetch(`${API_BASE_URL}/questions/by-question-id/${questionId}`);
    if (!response.ok) {
      throw new Error('Failed to fetch question');
    }
    return response.json();
  },

  // Get available filters
  getFilters: async () => {
    const response = await fetch(`${API_BASE_URL}/questions/filters`);
    if (!response.ok) {
      throw new Error('Failed to fetch filters');
    }
    return response.json();
  },

  // Bulk load questions
  bulkLoadQuestions: async () => {
    const response = await fetch(`${API_BASE_URL}/questions/bulk-load`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
    });
    if (!response.ok) {
      throw new Error('Failed to bulk load questions');
    }
    return response.json();
  }
};

// Skills API (if needed for backward compatibility)
export const skillsAPI = {
  getSkills: async () => {
    const response = await fetch(`${API_BASE_URL}/skills`);
    if (!response.ok) {
      throw new Error('Failed to fetch skills');
    }
    return response.json();
  }
};

// Modules API (if needed for backward compatibility)
export const modulesAPI = {
  getModules: async () => {
    const response = await fetch(`${API_BASE_URL}/modules`);
    if (!response.ok) {
      throw new Error('Failed to fetch modules');
    }
    return response.json();
  }
}; 