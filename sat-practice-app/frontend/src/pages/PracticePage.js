import React, { useState, useEffect, useCallback } from 'react';
import FilterPanel from '../components/FilterPanel';
import QuestionViewer from '../components/QuestionViewer';
import { questionsAPI } from '../api/api';

const PracticePage = () => {
  const [questions, setQuestions] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [filters, setFilters] = useState({});
  const [pagination, setPagination] = useState({
    page: 1,
    limit: 10,
    total: 0,
    pages: 0
  });
  const [globalQuestionIndex, setGlobalQuestionIndex] = useState(0);

  const loadQuestions = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      
      const params = {
        ...filters,
        page: pagination.page,
        limit: pagination.limit
      };
      
      console.log('Loading questions with params:', params);
      const response = await questionsAPI.getQuestions(params);
      console.log('API response:', response);
      setQuestions(response.questions);
      setPagination(response.pagination);
    } catch (error) {
      console.error('Error loading questions:', error);
      setError('Failed to load questions. Please try again.');
    } finally {
      setLoading(false);
    }
  }, [filters, pagination.page, pagination.limit]);

  useEffect(() => {
    loadQuestions();
  }, [loadQuestions]);

  // Reset global index when questions are loaded or page changes
  useEffect(() => {
    if (questions.length > 0) {
      const expectedGlobalIndex = (pagination.page - 1) * pagination.limit + currentIndex;
      if (globalQuestionIndex !== expectedGlobalIndex) {
        setGlobalQuestionIndex(expectedGlobalIndex);
      }
    }
  }, [questions, pagination.page, currentIndex, globalQuestionIndex, pagination.limit]);

  const handleFiltersChange = (newFilters) => {
    setFilters(newFilters);
    setCurrentIndex(0);
    setGlobalQuestionIndex(0);
    setPagination(prev => ({ ...prev, page: 1 }));
  };

  const handleNavigate = (newIndex) => {
    if (newIndex >= 0 && newIndex < questions.length) {
      setCurrentIndex(newIndex);
      // Update global index based on current page and local index
      const newGlobalIndex = (pagination.page - 1) * pagination.limit + newIndex;
      setGlobalQuestionIndex(newGlobalIndex);
    }
  };

  const handleAnswerChange = (answer) => {
    // Handle answer change if needed
    console.log('Answer changed:', answer);
  };

  const handlePageChange = (newPage) => {
    setPagination(prev => ({ ...prev, page: newPage }));
    setCurrentIndex(0);
    // Update global index when changing pages
    setGlobalQuestionIndex((newPage - 1) * pagination.limit);
  };

  // Calculate the current global question number
  const getCurrentQuestionNumber = () => {
    return globalQuestionIndex + 1;
  };

  if (loading && questions.length === 0) {
    return (
      <div className="min-h-screen bg-gray-50 py-8">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="animate-pulse">
            <div className="h-8 bg-gray-200 rounded mb-4"></div>
            <div className="h-64 bg-gray-200 rounded"></div>
          </div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-gray-50 py-8">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="bg-red-50 border border-red-200 rounded-lg p-4">
            <div className="flex">
              <div className="flex-shrink-0">
                <svg className="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
                </svg>
              </div>
              <div className="ml-3">
                <h3 className="text-sm font-medium text-red-800">Error</h3>
                <div className="mt-2 text-sm text-red-700">{error}</div>
                <div className="mt-4">
                  <button
                    onClick={loadQuestions}
                    className="text-sm font-medium text-red-800 hover:text-red-900"
                  >
                    Try again
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">SAT Practice Questions</h1>
          <p className="text-gray-600">
            Practice with real SAT questions. Use the filters below to find specific topics or difficulty levels.
          </p>
        </div>

        {/* Filters */}
        <FilterPanel 
          onFiltersChange={handleFiltersChange}
          currentQuestionIndex={getCurrentQuestionNumber() - 1}
          totalQuestions={pagination.total}
        />

        {/* Questions Section */}
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
          {/* Question List */}
          <div className="lg:col-span-1">
            <div className="bg-white rounded-lg shadow p-4">
              <h3 className="text-lg font-medium text-gray-800 mb-4">Questions</h3>
              
              {loading ? (
                <div className="space-y-2">
                  {[...Array(5)].map((_, i) => (
                    <div key={i} className="h-12 bg-gray-200 rounded animate-pulse"></div>
                  ))}
                </div>
              ) : questions.length === 0 ? (
                <div className="text-center text-gray-500 py-8">
                  No questions found with the current filters.
                </div>
              ) : (
                <div className="space-y-2 max-h-96 overflow-y-auto">
                  {questions.map((question, index) => {
                    const globalQuestionNumber = (pagination.page - 1) * pagination.limit + index + 1;
                    return (
                      <button
                        key={question.id}
                        onClick={() => {
                          setCurrentIndex(index);
                          // Update global index when clicking on sidebar questions
                          const newGlobalIndex = (pagination.page - 1) * pagination.limit + index;
                          setGlobalQuestionIndex(newGlobalIndex);
                        }}
                        className={`w-full text-left p-3 rounded-lg border transition-colors ${
                          index === currentIndex
                            ? 'border-blue-500 bg-blue-50 text-blue-800'
                            : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50'
                        }`}
                      >
                        <div className="text-sm font-medium">
                          Question {globalQuestionNumber}
                        </div>
                        <div className="text-xs text-gray-500 mt-1">
                          {question.section} • {question.domain}
                        </div>
                        <div className="text-xs text-gray-400 mt-1">
                          {question.type === 'multiple-choice' ? 'Multiple Choice' : 'Grid-In'}
                        </div>
                      </button>
                    );
                  })}
                </div>
              )}
            </div>

            {/* Pagination */}
            {pagination.pages > 1 && (
              <div className="mt-4 bg-white rounded-lg shadow p-4">
                <div className="flex justify-between items-center">
                  <button
                    onClick={() => handlePageChange(pagination.page - 1)}
                    disabled={pagination.page === 1}
                    className="px-3 py-1 text-sm text-gray-600 hover:text-gray-800 disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    Previous
                  </button>
                  
                  <span className="text-sm text-gray-600">
                    Page {pagination.page} of {pagination.pages}
                  </span>
                  
                  <button
                    onClick={() => handlePageChange(pagination.page + 1)}
                    disabled={pagination.page === pagination.pages}
                    className="px-3 py-1 text-sm text-gray-600 hover:text-gray-800 disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    Next
                  </button>
                </div>
              </div>
            )}
          </div>

          {/* Question Viewer */}
          <div className="lg:col-span-3">
            {questions.length > 0 ? (
              <QuestionViewer
                questions={questions}
                currentIndex={currentIndex}
                onNavigate={handleNavigate}
                onAnswerChange={handleAnswerChange}
                globalQuestionNumber={getCurrentQuestionNumber()}
                totalQuestions={pagination.total}
              />
            ) : (
              <div className="bg-white p-8 rounded-lg shadow text-center">
                <div className="text-gray-500">
                  {loading ? 'Loading questions...' : 'No questions available'}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default PracticePage; 